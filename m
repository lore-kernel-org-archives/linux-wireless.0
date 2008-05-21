Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:36530 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757829AbYEUKBX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2008 06:01:23 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: Re: [PATCH] b43: Upload both beacon templates on initial load
Date: Wed, 21 May 2008 12:00:54 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <200805201216.29134.mb@bu3sch.de>
In-Reply-To: <200805201216.29134.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805211200.54484.mb@bu3sch.de> (sfid-20080521_120127_767783_44F3753B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 20 May 2008 12:16:28 Michael Buesch wrote:
> This updates the beacon template code to upload both templates,
> if we never uploaded one before.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> ---
> 
> John, we can apply that to 2.6.26, but I guess it's not too important
> there, as that doesn't support AP, IBSS or Mesh anyway.

Please try to merge this for 2.6.26, as most AP code actually is merged.

> 
> Index: wireless-testing/drivers/net/wireless/b43/b43.h
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2008-05-20 00:16:27.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/b43/b43.h	2008-05-20 00:54:16.000000000 +0200
> @@ -753,12 +753,13 @@ struct b43_wl {
>  	/* The beacon we are currently using (AP or IBSS mode).
>  	 * This beacon stuff is protected by the irq_lock. */
>  	struct sk_buff *current_beacon;
>  	struct ieee80211_tx_control beacon_txctl;
>  	bool beacon0_uploaded;
>  	bool beacon1_uploaded;
> +	bool beacon_templates_virgin; /* Never wrote the templates? */
>  	struct work_struct beacon_update_trigger;
>  
>  	/* The current QOS parameters for the 4 queues.
>  	 * This is protected by the irq_lock. */
>  	struct b43_qos_params qos_params[4];
>  	/* Workqueue for updating QOS parameters in hardware. */
> Index: wireless-testing/drivers/net/wireless/b43/main.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-05-20 00:18:53.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/b43/main.c	2008-05-20 01:05:04.000000000 +0200
> @@ -1541,12 +1541,36 @@ static void b43_write_probe_resp_templat
>  	b43_write_template_common(dev, probe_resp_data,
>  				  size, ram_offset, shm_size_offset,
>  				  rate->hw_value);
>  	kfree(probe_resp_data);
>  }
>  
> +static void b43_upload_beacon0(struct b43_wldev *dev)
> +{
> +	struct b43_wl *wl = dev->wl;
> +
> +	if (wl->beacon0_uploaded)
> +		return;
> +	b43_write_beacon_template(dev, 0x68, 0x18);
> +	/* FIXME: Probe resp upload doesn't really belong here,
> +	 *        but we don't use that feature anyway. */
> +	b43_write_probe_resp_template(dev, 0x268, 0x4A,
> +				      &__b43_ratetable[3]);
> +	wl->beacon0_uploaded = 1;
> +}
> +
> +static void b43_upload_beacon1(struct b43_wldev *dev)
> +{
> +	struct b43_wl *wl = dev->wl;
> +
> +	if (wl->beacon1_uploaded)
> +		return;
> +	b43_write_beacon_template(dev, 0x468, 0x1A);
> +	wl->beacon1_uploaded = 1;
> +}
> +
>  static void handle_irq_beacon(struct b43_wldev *dev)
>  {
>  	struct b43_wl *wl = dev->wl;
>  	u32 cmd, beacon0_valid, beacon1_valid;
>  
>  	if (!b43_is_mode(wl, IEEE80211_IF_TYPE_AP))
> @@ -1565,30 +1589,33 @@ static void handle_irq_beacon(struct b43
>  	if (beacon0_valid && beacon1_valid) {
>  		b43_write32(dev, B43_MMIO_GEN_IRQ_REASON, B43_IRQ_BEACON);
>  		dev->irq_savedstate |= B43_IRQ_BEACON;
>  		return;
>  	}
>  
> -	if (!beacon0_valid) {
> -		if (!wl->beacon0_uploaded) {
> -			b43_write_beacon_template(dev, 0x68, 0x18);
> -			b43_write_probe_resp_template(dev, 0x268, 0x4A,
> -						      &__b43_ratetable[3]);
> -			wl->beacon0_uploaded = 1;
> -		}
> +	if (unlikely(wl->beacon_templates_virgin)) {
> +		/* We never uploaded a beacon before.
> +		 * Upload both templates now, but only mark one valid. */
> +		wl->beacon_templates_virgin = 0;
> +		b43_upload_beacon0(dev);
> +		b43_upload_beacon1(dev);
>  		cmd = b43_read32(dev, B43_MMIO_MACCMD);
>  		cmd |= B43_MACCMD_BEACON0_VALID;
>  		b43_write32(dev, B43_MMIO_MACCMD, cmd);
> -	} else if (!beacon1_valid) {
> -		if (!wl->beacon1_uploaded) {
> -			b43_write_beacon_template(dev, 0x468, 0x1A);
> -			wl->beacon1_uploaded = 1;
> +	} else {
> +		if (!beacon0_valid) {
> +			b43_upload_beacon0(dev);
> +			cmd = b43_read32(dev, B43_MMIO_MACCMD);
> +			cmd |= B43_MACCMD_BEACON0_VALID;
> +			b43_write32(dev, B43_MMIO_MACCMD, cmd);
> +		} else if (!beacon1_valid) {
> +			b43_upload_beacon1(dev);
> +			cmd = b43_read32(dev, B43_MMIO_MACCMD);
> +			cmd |= B43_MACCMD_BEACON1_VALID;
> +			b43_write32(dev, B43_MMIO_MACCMD, cmd);
>  		}
> -		cmd = b43_read32(dev, B43_MMIO_MACCMD);
> -		cmd |= B43_MACCMD_BEACON1_VALID;
> -		b43_write32(dev, B43_MMIO_MACCMD, cmd);
>  	}
>  }
>  
>  static void b43_beacon_update_trigger_work(struct work_struct *work)
>  {
>  	struct b43_wl *wl = container_of(work, struct b43_wl,
> @@ -4164,12 +4191,15 @@ static int b43_op_start(struct ieee80211
>  	 * and mac80211 reconfiguring it. */
>  	memset(wl->bssid, 0, ETH_ALEN);
>  	memset(wl->mac_addr, 0, ETH_ALEN);
>  	wl->filter_flags = 0;
>  	wl->radiotap_enabled = 0;
>  	b43_qos_clear(wl);
> +	wl->beacon0_uploaded = 0;
> +	wl->beacon1_uploaded = 0;
> +	wl->beacon_templates_virgin = 1;
>  
>  	/* First register RFkill.
>  	 * LEDs that are registered later depend on it. */
>  	b43_rfkill_init(dev);
>  
>  	mutex_lock(&wl->mutex);
> 



-- 
Greetings Michael.
