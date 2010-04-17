Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43192 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab0DQOFx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Apr 2010 10:05:53 -0400
Received: by wyb39 with SMTP id 39so1685865wyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 17 Apr 2010 07:05:51 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Sat, 17 Apr 2010 16:05:51 +0200
Message-ID: <n2g2d0a357f1004170705j6d0750fdkc4784f86aab51c97@mail.gmail.com>
Subject: iwl3945: Error sending REPLY_{RXON|SCAN_CMD|TX_PWR_TABLE_CMD} time
	out after 500ms
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: wireless <linux-wireless@vger.kernel.org>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have already sent an bug-report "iwl3945: Network dropouts w/
flash-stream in firefox" in [1].
Unfortunately, the problem still remains, especially when
fast-forwarding flash movies in firefox-3.6.3.
It seems the wifi-card is hanging and my system needs a coldstart.

My wifi-card is an iwl3945 and my access-point is a speedport-w701v.
I am using a Debian/sid 32-bit system.

Today, I enabled CONFIG_IWLWIFI_DEBUG=y to see what is going on.

I stopped networking, unloaded the kernel-module and re-loaded with
module-option debug=0x43fff [2].

# /etc/init.d/networking stop
# modprobe -r -v iwl3945
# modprobe -v iwl3945 debug=0x43fff

The kernel I use is a Linux-2.6.34-rc4-git4 with these 3 patches in addition:

patches/wireless-2.6:
0001-iwlwifi-work-around-bogus-active-chains-detection.patch

patches/iwlwifi-fixes-for-2.6.34:
1-2-iwlwifi-fix-scan-races.patch
2-2-iwlwifi-correct-6000-EEPROM-regulatory-address.patch

According to Johannes (on IRC) iwl3945 doesn't use internal scans yet
(see my patch below).
Thus, I am not sure if this needs to be fixed separately for iwl3945
and if I ran into a scan race condition here.

If this matters: I am using Debian's wpasupplicant (0.6.10-2) and wext
wpa-driver.

I collected all data and provide them in [3].

Hope, this helps.

Kind Regards,
- Sedat -

[1] http://marc.info/?l=linux-wireless&m=127135267301937&w=2
[2] http://intellinuxwireless.org/?n=fw_error_report
[3] http://files.iniza.org/BUG_iwl3945_20100417/

[PATCH]
$ cat iwl3945-fix-scan-races.patch
--- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2010-04-13
03:41:35.000000000 +0200
+++ linux-2.6/drivers/net/wireless/iwlwifi/iwl3945-base.c	2010-04-17
10:46:52.765166367 +0200
@@ -3792,6 +3792,7 @@ static void iwl3945_cancel_deferred_work

 	cancel_delayed_work_sync(&priv->init_alive_start);
 	cancel_delayed_work(&priv->scan_check);
+	cancel_work_sync(&priv->start_internal_scan);
 	cancel_delayed_work(&priv->alive_start);
 	cancel_work_sync(&priv->beacon_update);
 }
[/PATCH]
