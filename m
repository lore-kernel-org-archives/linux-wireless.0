Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:37590 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753411AbcHVU7y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Aug 2016 16:59:54 -0400
Received: by mail-wm0-f52.google.com with SMTP id i5so164539886wmg.0
        for <linux-wireless@vger.kernel.org>; Mon, 22 Aug 2016 13:59:40 -0700 (PDT)
Date: Mon, 22 Aug 2016 21:59:34 +0100
From: Jakub Kicinski <jakub.kicinski@netronome.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: [PATCHv7 4/4] mt7601u: use linux/bitfield.h
Message-ID: <20160822215934.03d51ba5@jkicinski-Precision-T1700> (sfid-20160822_225959_998807_0D9F4DFC)
In-Reply-To: <8958bdba-d01d-026c-a018-f2a94bff3e52@broadcom.com>
References: <1471625049-12643-1-git-send-email-jakub.kicinski@netronome.com>
        <1471625049-12643-5-git-send-email-jakub.kicinski@netronome.com>
        <161e3391-9a95-6388-6b93-99a5b12a2036@broadcom.com>
        <20160822115254.62ee6589@jkicinski-Precision-T1700>
        <8958bdba-d01d-026c-a018-f2a94bff3e52@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 22 Aug 2016 21:19:41 +0200, Arend Van Spriel wrote:
> On 22-8-2016 12:52, Jakub Kicinski wrote:
> > On Fri, 19 Aug 2016 21:02:02 +0200, Arend Van Spriel wrote:  
> >> On 19-8-2016 18:44, Jakub Kicinski wrote:  
> >>> Use the newly added linux/bitfield.h.
> >>>
> >>> Reviewed-by: Dinan Gunawardena <dinan.gunawardena@netronome.com>
> >>> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> >>> ---  
> 
> [snip]
> 
> >>> diff --git a/drivers/net/wireless/mediatek/mt7601u/eeprom.c b/drivers/net/wireless/mediatek/mt7601u/eeprom.c
> >>> index 8d8ee0344f7b..da6faea092d6 100644
> >>> --- a/drivers/net/wireless/mediatek/mt7601u/eeprom.c
> >>> +++ b/drivers/net/wireless/mediatek/mt7601u/eeprom.c
> >>> @@ -45,8 +45,8 @@ mt7601u_efuse_read(struct mt7601u_dev *dev, u16 addr, u8 *data,
> >>>  	val = mt76_rr(dev, MT_EFUSE_CTRL);
> >>>  	val &= ~(MT_EFUSE_CTRL_AIN |
> >>>  		 MT_EFUSE_CTRL_MODE);
> >>> -	val |= MT76_SET(MT_EFUSE_CTRL_AIN, addr & ~0xf) |
> >>> -	       MT76_SET(MT_EFUSE_CTRL_MODE, mode) |
> >>> +	val |= FIELD_PREP(MT_EFUSE_CTRL_AIN, addr & ~0xf) |
> >>> +	       FIELD_PREP(MT_EFUSE_CTRL_MODE, mode) |
> >>>  	       MT_EFUSE_CTRL_KICK;    
> >>
> >> MT_EFUSE_CTRL_KICK is probably a 1-bit field in MT_EFUSE_CTRL register.
> >> It looks like you did not want to go all the way although you do give an
> >> example in bitfield.h, ie. + *  #define REG_FIELD_B  BIT(7).  
> > 
> > True, I just wanted to show in the examples that BIT() is OK to use.
> > My feeling is that ORing in always set flags is acceptable, or at least
> > it was my feeling when I wrote this code ;)  
> 
> I find it tricky to have the user do the field clearing separately.
> Especially if you allow the calling function to pass additional opaque
> "flags". In my experience this is more error prone than anything else
> when dealing with bit fields and as such it is unfortunate this aspect
> is not addressed in your patches.

I don't think anything in this set prevents people from adding a
FIELD_SET() wrapper.  Quite the opposite and I'd encourage it.

> I would rather see:
> 
> 	val = mt76_rr(dev, MT_EFUSE_CTRL);
> 	FIELD_SET(val, MT_EFUSE_CTRL_AIN, addr & ~0xf);
> 	FIELD_SET(val, MT_EFUSE_CTRL_MODE, mode);
> 	FIELD_SET(val, MT_EFUSE_CTRL_KICK, 1);
>  	mt76_wr(dev, MT_EFUSE_CTRL, val);
> 
> in which FIELD_SET takes care of clearing the indicated field.

Yes, I agree this is a good solution as well.  The reason I didn't go
with this approach (apart from modifying an argument of a macro ;)) is
the experience with rt2x00 which followed this design and I wasn't
particularly fond of the resulting code.

I find PREP macro easier to read (less parameters).  It's also
often convenient to not have to zero the variable for pure write
and be able to combine the values in a parameter list:

+	mt7601u_wr(dev, MT_TXOP_CTRL_CFG,
+		   FIELD_PREP(MT_TXOP_TRUN_EN, 0x3f) |
+		   FIELD_PREP(MT_TXOP_EXT_CCA_DLY, 0x58));
or:
+	reg = cpu_to_le32(FIELD_PREP(MT_TXD_INFO_TYPE, DMA_PACKET) |
+			  FIELD_PREP(MT_TXD_INFO_D_PORT, CPU_TX_PORT) |
+			  FIELD_PREP(MT_TXD_INFO_LEN, len));

So each approach has it's advantages and I think they complement each
other.

Please note that I'm just using mt7601u as an example, I really don't
need SET in the new code I'm trying to use these macros for now [1].

[1] https://patchwork.ozlabs.org/patch/628779/
