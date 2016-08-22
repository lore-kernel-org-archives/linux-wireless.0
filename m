Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:33770 "EHLO
        mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751352AbcHVKxA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Aug 2016 06:53:00 -0400
Received: by mail-wm0-f43.google.com with SMTP id d196so20445556wmd.0
        for <linux-wireless@vger.kernel.org>; Mon, 22 Aug 2016 03:52:59 -0700 (PDT)
Date: Mon, 22 Aug 2016 11:52:54 +0100
From: Jakub Kicinski <jakub.kicinski@netronome.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: [PATCHv7 4/4] mt7601u: use linux/bitfield.h
Message-ID: <20160822115254.62ee6589@jkicinski-Precision-T1700> (sfid-20160822_125304_900506_419B78CA)
In-Reply-To: <161e3391-9a95-6388-6b93-99a5b12a2036@broadcom.com>
References: <1471625049-12643-1-git-send-email-jakub.kicinski@netronome.com>
        <1471625049-12643-5-git-send-email-jakub.kicinski@netronome.com>
        <161e3391-9a95-6388-6b93-99a5b12a2036@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 19 Aug 2016 21:02:02 +0200, Arend Van Spriel wrote:
> On 19-8-2016 18:44, Jakub Kicinski wrote:
> > Use the newly added linux/bitfield.h.
> > 
> > Reviewed-by: Dinan Gunawardena <dinan.gunawardena@netronome.com>
> > Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> > ---
> >  drivers/net/wireless/mediatek/mt7601u/dma.c     |  2 +-
> >  drivers/net/wireless/mediatek/mt7601u/dma.h     | 10 ++--
> >  drivers/net/wireless/mediatek/mt7601u/eeprom.c  | 12 ++--
> >  drivers/net/wireless/mediatek/mt7601u/init.c    | 10 ++--
> >  drivers/net/wireless/mediatek/mt7601u/mac.c     | 38 ++++++------
> >  drivers/net/wireless/mediatek/mt7601u/mcu.c     | 20 +++----
> >  drivers/net/wireless/mediatek/mt7601u/mt7601u.h |  4 +-
> >  drivers/net/wireless/mediatek/mt7601u/phy.c     | 44 +++++++-------
> >  drivers/net/wireless/mediatek/mt7601u/tx.c      | 19 +++---
> >  drivers/net/wireless/mediatek/mt7601u/util.h    | 77 -------------------------
> >  10 files changed, 81 insertions(+), 155 deletions(-)
> >  delete mode 100644 drivers/net/wireless/mediatek/mt7601u/util.h
> > 
> > diff --git a/drivers/net/wireless/mediatek/mt7601u/dma.c b/drivers/net/wireless/mediatek/mt7601u/dma.c
> > index 57a80cfa39b1..a8bc064bc14f 100644
> > --- a/drivers/net/wireless/mediatek/mt7601u/dma.c
> > +++ b/drivers/net/wireless/mediatek/mt7601u/dma.c
> > @@ -103,7 +103,7 @@ static void mt7601u_rx_process_seg(struct mt7601u_dev *dev, u8 *data,
> >  
> >  	if (unlikely(rxwi->zero[0] || rxwi->zero[1] || rxwi->zero[2]))
> >  		dev_err_once(dev->dev, "Error: RXWI zero fields are set\n");
> > -	if (unlikely(MT76_GET(MT_RXD_INFO_TYPE, fce_info)))
> > +	if (unlikely(FIELD_GET(MT_RXD_INFO_TYPE, fce_info)))
> >  		dev_err_once(dev->dev, "Error: RX path seen a non-pkt urb\n");
> >  
> >  	trace_mt_rx(dev, rxwi, fce_info);
> > diff --git a/drivers/net/wireless/mediatek/mt7601u/dma.h b/drivers/net/wireless/mediatek/mt7601u/dma.h
> > index 978e8a90b87f..270d126880c0 100644
> > --- a/drivers/net/wireless/mediatek/mt7601u/dma.h
> > +++ b/drivers/net/wireless/mediatek/mt7601u/dma.h
> > @@ -18,8 +18,6 @@
> >  #include <asm/unaligned.h>
> >  #include <linux/skbuff.h>
> >  
> > -#include "util.h"
> > -
> >  #define MT_DMA_HDR_LEN			4
> >  #define MT_RX_INFO_LEN			4
> >  #define MT_FCE_INFO_LEN			4
> > @@ -79,9 +77,9 @@ static inline int mt7601u_dma_skb_wrap(struct sk_buff *skb,
> >  	 */
> >  
> >  	info = flags |
> > -		MT76_SET(MT_TXD_INFO_LEN, round_up(skb->len, 4)) |
> > -		MT76_SET(MT_TXD_INFO_D_PORT, d_port) |
> > -		MT76_SET(MT_TXD_INFO_TYPE, type);
> > +		FIELD_PREP(MT_TXD_INFO_LEN, round_up(skb->len, 4)) |
> > +		FIELD_PREP(MT_TXD_INFO_D_PORT, d_port) |
> > +		FIELD_PREP(MT_TXD_INFO_TYPE, type);  
> 
> So what are those flags? Is there no field definition for those.
> 
> >  	put_unaligned_le32(info, skb_push(skb, sizeof(info)));
> >  	return skb_put_padto(skb, round_up(skb->len, 4) + 4);
> > @@ -90,7 +88,7 @@ static inline int mt7601u_dma_skb_wrap(struct sk_buff *skb,
> >  static inline int
> >  mt7601u_dma_skb_wrap_pkt(struct sk_buff *skb, enum mt76_qsel qsel, u32 flags)
> >  {
> > -	flags |= MT76_SET(MT_TXD_PKT_INFO_QSEL, qsel);
> > +	flags |= FIELD_PREP(MT_TXD_PKT_INFO_QSEL, qsel);  
> 
> Ah. This is the flags being ORed in above. I suppose there are more
> callsites to mt7601u_dma_skb_wrap().

Yes, the field layout differs slightly between data and MCU commands.
Additionally some packet flags depend on mac80211 info and I didn't
want to pollute dma.h with mac80211 info so I just pass those flags
as opaque u32.

> >  	return mt7601u_dma_skb_wrap(skb, WLAN_PORT, DMA_PACKET, flags);
> >  }
> >  
> > diff --git a/drivers/net/wireless/mediatek/mt7601u/eeprom.c b/drivers/net/wireless/mediatek/mt7601u/eeprom.c
> > index 8d8ee0344f7b..da6faea092d6 100644
> > --- a/drivers/net/wireless/mediatek/mt7601u/eeprom.c
> > +++ b/drivers/net/wireless/mediatek/mt7601u/eeprom.c
> > @@ -45,8 +45,8 @@ mt7601u_efuse_read(struct mt7601u_dev *dev, u16 addr, u8 *data,
> >  	val = mt76_rr(dev, MT_EFUSE_CTRL);
> >  	val &= ~(MT_EFUSE_CTRL_AIN |
> >  		 MT_EFUSE_CTRL_MODE);
> > -	val |= MT76_SET(MT_EFUSE_CTRL_AIN, addr & ~0xf) |
> > -	       MT76_SET(MT_EFUSE_CTRL_MODE, mode) |
> > +	val |= FIELD_PREP(MT_EFUSE_CTRL_AIN, addr & ~0xf) |
> > +	       FIELD_PREP(MT_EFUSE_CTRL_MODE, mode) |
> >  	       MT_EFUSE_CTRL_KICK;  
> 
> MT_EFUSE_CTRL_KICK is probably a 1-bit field in MT_EFUSE_CTRL register.
> It looks like you did not want to go all the way although you do give an
> example in bitfield.h, ie. + *  #define REG_FIELD_B  BIT(7).

True, I just wanted to show in the examples that BIT() is OK to use.
My feeling is that ORing in always set flags is acceptable, or at least
it was my feeling when I wrote this code ;)
