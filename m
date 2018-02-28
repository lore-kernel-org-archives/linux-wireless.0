Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:40833 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751605AbeB1SDD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Feb 2018 13:03:03 -0500
Received: by mail-wr0-f172.google.com with SMTP id o76so3377719wrb.7
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2018 10:03:02 -0800 (PST)
Subject: Re: [PATCH] mt7601u: Fix system freeze after resuming from
 hibernation
To: "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Jakub Kicinski <kubakici@wp.pl>
Cc: linux-wireless@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <f542e9c6-5106-c79c-6e38-7a2f50e6be2d@gmail.com>
 <20180215134738.722654a9@cakuba.netronome.com>
 <7cebda93-4b7a-e8b3-271f-0144c5e94248@gmail.com>
 <20180218215520.65c1e9fd@cakuba.netronome.com>
 <6783d9b9-3523-761f-a8b4-b87732006b3c@gmail.com>
 <20180225175425.GL14069@wotan.suse.de>
 <20180226182859.03184215@cakuba.netronome.com>
 <3382fa4d-c652-68eb-13c3-12dc84ba0dd5@gmail.com>
 <20180227165451.GS14069@wotan.suse.de>
 <20180227102253.04a3a01c@cakuba.netronome.com>
 <20180227204240.GW14069@wotan.suse.de>
From: cantabile <cantabile.desu@gmail.com>
Message-ID: <498eb998-0dce-83c6-87c9-76cb83b148ea@gmail.com> (sfid-20180228_190309_099187_B68EFF16)
Date: Wed, 28 Feb 2018 20:02:59 +0200
MIME-Version: 1.0
In-Reply-To: <20180227204240.GW14069@wotan.suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 27/02/18 22:42, Luis R. Rodriguez wrote:
> I'd be curious if someone who can trigger the situation can test what
> happens if you use:
> 
> diff --git a/drivers/net/wireless/mediatek/mt7601u/mcu.c b/drivers/net/wireless/mediatek/mt7601u/mcu.c
> index 65a8004418ea..04cbffd225a1 100644
> --- a/drivers/net/wireless/mediatek/mt7601u/mcu.c
> +++ b/drivers/net/wireless/mediatek/mt7601u/mcu.c
> @@ -421,7 +421,7 @@ static int mt7601u_load_firmware(struct mt7601u_dev *dev)
>   					 MT_USB_DMA_CFG_TX_BULK_EN));
>   
>   	if (firmware_running(dev))
> -		return 0;
> +		pr_info("Firmware already loaded but going to reload...");
>   
>   	ret = request_firmware(&fw, MT7601U_FIRMWARE, dev->dev);
>   	if (ret)
>   
> 
> 
> Curious, will it really fail?

This change brings no new messages from mt7601u in dmesg (other than 
this pr_info), and the device works fine, as far as I can tell.

> 
> Note that I see mt7601u_stop() just calls mt7601u_mac_stop(). The big cleanup
> happens via mt7601u_cleanup(), but I see mt7601u_disconnect() calls it.
> 
> Just curious, does that not get called on shutdown?
> 
> diff --git a/drivers/net/wireless/mediatek/mt7601u/usb.c b/drivers/net/wireless/mediatek/mt7601u/usb.c
> index b9e4f6793138..126ef2ba77c2 100644
> --- a/drivers/net/wireless/mediatek/mt7601u/usb.c
> +++ b/drivers/net/wireless/mediatek/mt7601u/usb.c
> @@ -311,6 +311,7 @@ static void mt7601u_disconnect(struct usb_interface *usb_intf)
>   {
>   	struct mt7601u_dev *dev = usb_get_intfdata(usb_intf);
>   
> +	pr_info("Calling mt7601u_disconnect()...");
>   	ieee80211_unregister_hw(dev->hw);
>   	mt7601u_cleanup(dev);
> 
> If it does, one option is mt7601u_cleanup() can use some love to really shut down
> the device more... But its not clear to me what else could be done and I'm very
> inclined to believe its not sensible.
> 
"Calling mt7601u_disconnect" does not appear in journalctl after a reboot.

> The idea of an optimization of *not* having to load firmware one more time if
> it already has it since power hasn't been shut off on the device seems sensible
> to me.
> 
> Give the few deltas above a quick test just to fill in curiosity if you like
> and to be complete -- I'll post RFCs shortly for you Cantabile to test, is
> that your name?

Yes.
