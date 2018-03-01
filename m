Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39466 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1161716AbeCAVBk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Mar 2018 16:01:40 -0500
Date: Thu, 1 Mar 2018 21:01:39 +0000
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: cantabile <cantabile.desu@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Jakub Kicinski <kubakici@wp.pl>,
        linux-wireless@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mt7601u: Fix system freeze after resuming from
 hibernation
Message-ID: <20180301210139.GX14069@wotan.suse.de> (sfid-20180301_220144_709792_9F9EE9CF)
References: <20180227165451.GS14069@wotan.suse.de>
 <20180227102253.04a3a01c@cakuba.netronome.com>
 <20180227204240.GW14069@wotan.suse.de>
 <498eb998-0dce-83c6-87c9-76cb83b148ea@gmail.com>
 <20180228184820.GL14069@wotan.suse.de>
 <ba4c6079-ca45-2048-1e7d-3cb4e1a80cdb@gmail.com>
 <20180301002813.GQ14069@wotan.suse.de>
 <9088ab38-5a88-f479-1225-5988f9890aaa@gmail.com>
 <20180301172920.GV14069@wotan.suse.de>
 <877eb47d-5750-c3ef-0238-bbfc73476ed2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <877eb47d-5750-c3ef-0238-bbfc73476ed2@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 01, 2018 at 10:11:01PM +0200, cantabile wrote:
> On 01/03/18 19:29, Luis R. Rodriguez wrote:
> > 
> > Correct?
> > 
> 
> The above log is from "20180227-firmware-cache" kernel plus your suggested
> change that makes it always upload the firmware:
> 
> diff --git a/drivers/net/wireless/mediatek/mt7601u/mcu.c
> b/drivers/net/wireless/mediatek/mt7601u/mcu.c
> index 65a8004418ea..04cbffd225a1 100644
> --- a/drivers/net/wireless/mediatek/mt7601u/mcu.c
> +++ b/drivers/net/wireless/mediatek/mt7601u/mcu.c
> @@ -421,7 +421,7 @@ static int mt7601u_load_firmware(struct mt7601u_dev
> *dev)
>  					 MT_USB_DMA_CFG_TX_BULK_EN));
> 
>  	if (firmware_running(dev))
> -		return 0;
> +		pr_info("Firmware already loaded but going to reload...");
> 
>  	ret = request_firmware(&fw, MT7601U_FIRMWARE, dev->dev);
>  	if (ret)

Huh, if you are using 20180227-firmware-cache, then your diff should instead
be this no?

diff --git a/drivers/net/wireless/mediatek/mt7601u/mcu.c b/drivers/net/wireless/mediatek/mt7601u/mcu.c
index b90456a4b4d7..04cbffd225a1 100644
--- a/drivers/net/wireless/mediatek/mt7601u/mcu.c
+++ b/drivers/net/wireless/mediatek/mt7601u/mcu.c
@@ -421,7 +421,7 @@ static int mt7601u_load_firmware(struct mt7601u_dev *dev)
 					 MT_USB_DMA_CFG_TX_BULK_EN));
 
 	if (firmware_running(dev))
-		return request_firmware_cache(dev->dev, MT7601U_FIRMWARE);
+		pr_info("Firmware already loaded but going to reload...");
 
 	ret = request_firmware(&fw, MT7601U_FIRMWARE, dev->dev);
 	if (ret)


> I recompiled the kernel with CONFIG_DEBUG_INFO=y, but the messages in
> journalctl look pretty much the same as before. There are still question
> marks in the call traces, there are no line numbers, and it still says
> "verbose debug info unavailable". /proc/config.gz contains
> CONFIG_DEBUG_INFO=y. What else do I need to do?

Hrm, odd.

CONFIG_FRAME_POINTER=y

Maybe.

> > But if the patches I posted help, I guess we already have a solution, The rest of
> > these email exchanges are all just hypothetical exercises.
> > 
> 
> Your patches definitely fix the problem I reported in my initial email.

Ah OK :)

  Luis
