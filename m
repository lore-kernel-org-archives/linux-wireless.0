Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754846Ab1DKSZs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Apr 2011 14:25:48 -0400
Date: Mon, 11 Apr 2011 20:25:31 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Robin Dong <hao.bigrat@gmail.com>
Cc: linux-wireless@vger.kernel.org, Robin Dong <sanbai@taobao.com>
Subject: Re: [PATCH] fix iwl3945 tx power setting in iwl3945_init_drv
Message-ID: <20110411182531.GA5344@redhat.com>
References: <1302433562-4078-1-git-send-email-hao.bigrat@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1302433562-4078-1-git-send-email-hao.bigrat@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Robin

> When I build and run the kernel-2.6.39-rc2 on my laptop, my intel-3945-a/b/g wireless
> card will not work and the dmesg is:
> 
> [   58.597834] iwl3945 0000:03:00.0: Requested user TXPOWER 15 above upper limit 14.
> [   58.597839] iwl3945 0000:03:00.0: Error setting Tx power (-22).
> [   58.598276] iwl3945 0000:03:00.0: Requested user TXPOWER 15 above upper limit 14.
> [   58.598279] iwl3945 0000:03:00.0: Error setting Tx power (-22).
> [   94.064147] iwl3945 0000:03:00.0: Requested user TXPOWER 15 above upper limit 14.
> [   94.064152] iwl3945 0000:03:00.0: Error setting Tx power (-22).
> [   94.064529] iwl3945 0000:03:00.0: Requested user TXPOWER 15 above upper limit 14.
> [   94.064533] iwl3945 0000:03:00.0: Error setting Tx power (-22).
> [  133.892160] sky2 0000:02:00.0: eth1: disabling interface
> [  473.313935] sky2 0000:02:00.0: eth1: enabling interface
> [  473.314238] ADDRCONF(NETDEV_UP): eth1: link is not ready
> [  473.383740] iwl3945 0000:03:00.0: Requested user TXPOWER 15 above upper limit 14.
> [  473.383748] iwl3945 0000:03:00.0: Error setting Tx power (-22).
> [  473.384146] iwl3945 0000:03:00.0: Requested user TXPOWER 15 above upper limit 14.
> [  473.384153] iwl3945 0000:03:00.0: Error setting Tx power (-22).
> [  473.455655] iwl3945 0000:03:00.0: Requested user TXPOWER 15 above upper limit 14.
> [  473.455663] iwl3945 0000:03:00.0: Error setting Tx power (-22).
> [  473.456128] iwl3945 0000:03:00.0: Requested user TXPOWER 15 above upper limit 14.
> [  473.456134] iwl3945 0000:03:00.0: Error setting Tx power (-22).
> 
> It is weird the iwl3945 set txpower 15 above limit 14.
> So I checked iwl4965 and iwl3945 driver and found out it will set 
> tx_power_next to 0 in "iwl4965_init_drv" but to 15 in "iwl3945_init_drv"
> I change tx_power_next=0 in "iwl3945_init_drv", and my wireless card works.

Thanks for catching this. I wonder if this is a problem of bad
tx_power_device_lmt value instead of default setting, because on older
kernel default tx_power value 15 worked, right? I would like to avoid
changing default setting is possible.

Could you apply below simple patch and apply similar changes on older
kernel to compare if tx_power_device_lmt change on your system between
kernels and why?

diff --git a/drivers/net/wireless/iwlegacy/iwl-core.c b/drivers/net/wireless/iwlegacy/iwl-core.c
index 7007d61..78af49b 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.c
+++ b/drivers/net/wireless/iwlegacy/iwl-core.c
@@ -235,6 +235,9 @@ int iwl_legacy_init_geos(struct iwl_priv *priv)
 
 			geo_ch->flags |= ch->ht40_extension_channel;
 
+			printk("ch->max_power_avg %u, priv->tx_power_device_lmt %u\n",
+				ch->max_power_avg, priv->tx_power_device_lmt);
+
 			if (ch->max_power_avg > priv->tx_power_device_lmt)
 				priv->tx_power_device_lmt = ch->max_power_avg;
 		} else {
diff --git a/drivers/net/wireless/iwlegacy/iwl-eeprom.c b/drivers/net/wireless/iwlegacy/iwl-eeprom.c
index 04c5648..45f458b 100644
--- a/drivers/net/wireless/iwlegacy/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlegacy/iwl-eeprom.c
@@ -448,6 +448,7 @@ int iwl_legacy_init_channel_map(struct iwl_priv *priv)
 			/* Initialize regulatory-based run-time data */
 			ch_info->max_power_avg = ch_info->curr_txpow =
 			    eeprom_ch_info[ch].max_power_avg;
+			printk("band %d ch %d max_power_avg %d\n", band, ch, ch_info->max_power_avg);
 			ch_info->scan_power = eeprom_ch_info[ch].max_power_avg;
 			ch_info->min_power = 0;
 
