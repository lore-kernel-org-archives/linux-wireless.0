Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33351 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751628AbeB0Umm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Feb 2018 15:42:42 -0500
Date: Tue, 27 Feb 2018 20:42:40 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Jakub Kicinski <kubakici@wp.pl>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
        cantabile <cantabile.desu@gmail.com>,
        linux-wireless@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mt7601u: Fix system freeze after resuming from
 hibernation
Message-ID: <20180227204240.GW14069@wotan.suse.de> (sfid-20180227_214256_109487_670E9F99)
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180227102253.04a3a01c@cakuba.netronome.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 27, 2018 at 10:22:53AM -0800, Jakub Kicinski wrote:
> On Tue, 27 Feb 2018 16:54:51 +0000, Luis R. Rodriguez wrote:
> > OK, this just confirms that firmware is not needed on reboot sometimes,
> > but it does not explain *why*. What driver and code lines are involved
> > so I can go read? 
> 
> mt7601u_load_firmware() is probably the place to look at.

I checked.

static inline int firmware_running(struct mt7601u_dev *dev)                     
{                                                                               
        return mt7601u_rr(dev, MT_MCU_COM_REG0) == 1;                           
}

static int mt7601u_load_firmware(struct mt7601u_dev *dev)                       
{  
	...
        if (firmware_running(dev))                                              
                return 0;    

There you go. That's why. Now one would have to check the spec or
ask a person at the company what it means when:

	MT_MCU_COM_REG0 (0x0730) == 1.

Note that when we load the firmware we use the same check on intervals until
this is true to confirm or deny if the firmware got loaded.  I can only infer
this just means that the firmware is loaded and the device is ready. So this
just seems like an optimization given mt7601u_upload_firmware() seems to hint 
that this this device can take up to 100 * 10ms = 1s to load. Ie, we check
every 10ms to see if the firmware loaded, and we do so 100 times, so minimum
time expected for firmware load can take may be 10ms, and max 1s.

I'd be curious if someone who can trigger the situation can test what
happens if you use:

diff --git a/drivers/net/wireless/mediatek/mt7601u/mcu.c b/drivers/net/wireless/mediatek/mt7601u/mcu.c
index 65a8004418ea..04cbffd225a1 100644
--- a/drivers/net/wireless/mediatek/mt7601u/mcu.c
+++ b/drivers/net/wireless/mediatek/mt7601u/mcu.c
@@ -421,7 +421,7 @@ static int mt7601u_load_firmware(struct mt7601u_dev *dev)
 					 MT_USB_DMA_CFG_TX_BULK_EN));
 
 	if (firmware_running(dev))
-		return 0;
+		pr_info("Firmware already loaded but going to reload...");
 
 	ret = request_firmware(&fw, MT7601U_FIRMWARE, dev->dev);
 	if (ret)
 


Curious, will it really fail?

Note that I see mt7601u_stop() just calls mt7601u_mac_stop(). The big cleanup
happens via mt7601u_cleanup(), but I see mt7601u_disconnect() calls it.

Just curious, does that not get called on shutdown?

diff --git a/drivers/net/wireless/mediatek/mt7601u/usb.c b/drivers/net/wireless/mediatek/mt7601u/usb.c
index b9e4f6793138..126ef2ba77c2 100644
--- a/drivers/net/wireless/mediatek/mt7601u/usb.c
+++ b/drivers/net/wireless/mediatek/mt7601u/usb.c
@@ -311,6 +311,7 @@ static void mt7601u_disconnect(struct usb_interface *usb_intf)
 {
 	struct mt7601u_dev *dev = usb_get_intfdata(usb_intf);
 
+	pr_info("Calling mt7601u_disconnect()...");
 	ieee80211_unregister_hw(dev->hw);
 	mt7601u_cleanup(dev);

If it does, one option is mt7601u_cleanup() can use some love to really shut down
the device more... But its not clear to me what else could be done and I'm very
inclined to believe its not sensible.

The idea of an optimization of *not* having to load firmware one more time if
it already has it since power hasn't been shut off on the device seems sensible
to me.

Give the few deltas above a quick test just to fill in curiosity if you like
and to be complete -- I'll post RFCs shortly for you Cantabile to test, is
that your name?

  Luis
