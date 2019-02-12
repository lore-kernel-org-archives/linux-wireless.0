Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5BBDC282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 09:14:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7306621773
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 09:14:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728524AbfBLJOm convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 04:14:42 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:59518 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbfBLJOm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 04:14:42 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x1C9EEoc027289, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcas12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x1C9EEoc027289
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Tue, 12 Feb 2019 17:14:14 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITCAS12.realtek.com.tw ([::1]) with mapi id 14.03.0415.000; Tue, 12 Feb
 2019 17:14:13 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Brian Norris <briannorris@chromium.org>
CC:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v4 06/13] rtw88: fw and efuse files
Thread-Topic: [PATCH v4 06/13] rtw88: fw and efuse files
Thread-Index: AQHUuFCxMon07SnYNUy97NOkg2+036XJeiEAgBJK/xA=
Date:   Tue, 12 Feb 2019 09:14:12 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D17A3C74@RTITMBSVM04.realtek.com.tw>
References: <1548820940-15237-1-git-send-email-yhchuang@realtek.com>
 <1548820940-15237-7-git-send-email-yhchuang@realtek.com>
 <20190131225809.GB191502@google.com>
In-Reply-To: <20190131225809.GB191502@google.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.124]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



> -----Original Message-----
> From: Brian Norris [mailto:briannorris@chromium.org]
> Sent: Friday, February 01, 2019 6:58 AM
> To: Tony Chuang
> Cc: kvalo@codeaurora.org; johannes@sipsolutions.net;
> Larry.Finger@lwfinger.net; Pkshih; Andy Huang; sgruszka@redhat.com;
> linux-wireless@vger.kernel.org
> Subject: Re: [PATCH v4 06/13] rtw88: fw and efuse files
> 
> Hi,
> 
> On Wed, Jan 30, 2019 at 12:02:13PM +0800, yhchuang@realtek.com wrote:
> > From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> >
> > fw and efuse files for Realtek 802.11ac wireless network chips
> >
> > Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> > ---
> >  drivers/net/wireless/realtek/rtw88/efuse.c | 150 +++++++
> >  drivers/net/wireless/realtek/rtw88/efuse.h |  53 +++
> >  drivers/net/wireless/realtek/rtw88/fw.c    | 611
> +++++++++++++++++++++++++++++
> >  drivers/net/wireless/realtek/rtw88/fw.h    | 213 ++++++++++
> >  4 files changed, 1027 insertions(+)
> >  create mode 100644 drivers/net/wireless/realtek/rtw88/efuse.c
> >  create mode 100644 drivers/net/wireless/realtek/rtw88/efuse.h
> >  create mode 100644 drivers/net/wireless/realtek/rtw88/fw.c
> >  create mode 100644 drivers/net/wireless/realtek/rtw88/fw.h
> >
> > diff --git a/drivers/net/wireless/realtek/rtw88/efuse.c
> b/drivers/net/wireless/realtek/rtw88/efuse.c
> > new file mode 100644
> > index 0000000..7c1b782
> > --- /dev/null
> > +++ b/drivers/net/wireless/realtek/rtw88/efuse.c
> > @@ -0,0 +1,150 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright(c) 2018  Realtek Corporation.
> > + */
> > +
> > +#include "main.h"
> > +#include "efuse.h"
> > +#include "reg.h"
> > +#include "debug.h"
> > +
> > +#define RTW_EFUSE_BANK_WIFI		0x0
> > +
> > +static void switch_efuse_bank(struct rtw_dev *rtwdev)
> > +{
> > +	rtw_write32_mask(rtwdev, REG_LDO_EFUSE_CTRL,
> BIT_MASK_EFUSE_BANK_SEL,
> > +			 RTW_EFUSE_BANK_WIFI);
> > +}
> > +
> > +static int rtw_dump_logical_efuse_map(struct rtw_dev *rtwdev, u8
> *phy_map,
> > +				      u8 *log_map)
> > +{
> > +	u32 physical_size = rtwdev->efuse.physical_size;
> > +	u32 protect_size = rtwdev->efuse.protect_size;
> > +	u32 logical_size = rtwdev->efuse.logical_size;
> > +	u32 phy_idx, log_idx;
> > +	u8 hdr1, hdr2;
> > +	u8 blk_idx;
> > +	u8 valid;
> > +	u8 word_en;
> > +	int i;
> > +
> > +	phy_idx = 0;
> > +
> > +	do {
> 
> See my comments below about termination, but I think you need some
> bounds checks up front to ensure you're not running over the buffers.
> You have some checks at the end of the embedded for-loop, but it's not
> clear you will always run them.
> 
> > +		hdr1 = *(phy_map + phy_idx);
> > +		if ((hdr1 & 0x1f) == 0xf) {
> > +			phy_idx++;
> > +			hdr2 = *(phy_map + phy_idx);
> > +			if (hdr2 == 0xff)
> > +				break;
> > +			blk_idx = ((hdr2 & 0xf0) >> 1) | ((hdr1 >> 5) & 0x07);
> > +			word_en = hdr2 & 0x0f;
> > +		} else {
> > +			blk_idx = (hdr1 & 0xf0) >> 4;
> > +			word_en = hdr1 & 0x0f;
> > +		}
> > +
> > +		if (hdr1 == 0xff)
> > +			break;
> > +
> > +		phy_idx++;
> > +		for (i = 0; i < 4; i++) {
> > +			valid = (~(word_en >> i)) & 0x1;
> > +			if (valid != 0x1)
> > +				continue;
> > +			log_idx = (blk_idx << 3) + (i << 1);
> > +			*(log_map + log_idx) = *(phy_map + phy_idx);
> > +			log_idx++;
> > +			phy_idx++;
> > +			*(log_map + log_idx) = *(phy_map + phy_idx);
> > +			phy_idx++;
> > +			if (phy_idx > physical_size - protect_size ||
> > +			    log_idx > logical_size)
> > +				return -EINVAL;
> > +		}
> > +	} while (1);
> 
> This is a complicated and ugly loop. Can you make this easier to read?
> Comments? Describe the layout in words or a diagram? Macros? At the
> moment, I can't even guarantee that this while(1) loop is guaranteed to
> terminate, let alone actually determine what exactly you're trying to
> parse.
> 

Yes, I can make this easier to read.

> > +
> > +	return 0;
> > +}
> > +

...

> > +int rtw_parse_efuse_map(struct rtw_dev *rtwdev)
> > +{
> > +	struct rtw_chip_info *chip = rtwdev->chip;
> > +	struct rtw_efuse *efuse = &rtwdev->efuse;
> > +	u32 phy_size = efuse->physical_size;
> > +	u32 log_size = efuse->logical_size;
> > +	u8 *phy_map = NULL;
> > +	u8 *log_map = NULL;
> > +	int ret = 0;
> > +
> > +	phy_map = kmalloc(phy_size, GFP_KERNEL);
> > +	log_map = kmalloc(log_size, GFP_KERNEL);
> > +	if (!phy_map || !log_map) {
> > +		ret = -ENOMEM;
> > +		goto out_free;
> > +	}
> > +
> > +	ret = rtw_dump_physical_efuse_map(rtwdev, phy_map);
> > +	if (ret) {
> > +		rtw_err(rtwdev, "failed to dump efuse physical map\n");
> > +		goto out_free;
> > +	}
> > +
> > +	memset(log_map, 0xff, log_size);
> > +	ret = rtw_dump_logical_efuse_map(rtwdev, phy_map, log_map);
> > +	if (ret) {
> > +		rtw_err(rtwdev, "failed to dump efuse logical map\n");
> > +		goto out_free;
> > +	}
> > +
> > +	print_hex_dump_bytes("efuse: ", DUMP_PREFIX_OFFSET, log_map,
> log_size);
> 
> Do you really want to dump this at every boot? It goes at KERN_DEBUG
> level, so it may or may not be showing up by default, but still, this
> doesn't feel like the right thing here.
> 
> > +
> > +	efuse->x3d7 = phy_map[0x3d7];
> > +	efuse->x3d8 = phy_map[0x3d8];
> 
> Fortunately I had KASAN enabled (you should try it!), because it noticed
> that on 8822C, this is out of bounds. See how 8822c's phy_efuse_size is
> only 512, and so you end up reading beyond the end of the boundary.

I will try it, looks like very useful.

> 
> Why are you doing this anyway? You don't use the ->x3d{7,8} fields
> anywhere.
> 
> On a related note, it still feels like you have too many magic nubers in
> some places.

The three lines above can be removed. Should put the dump log in debugfs.
And x3d{7,8} indeed are not used in the code. I think it was written to
develop 8822BE and is no more required here.

> 
> > +
> > +	ret = chip->ops->read_efuse(rtwdev, log_map);
> > +	if (ret) {
> > +		rtw_err(rtwdev, "failed to read efuse map\n");
> > +		goto out_free;
> > +	}
> > +
> > +out_free:
> > +	kfree(log_map);
> > +	kfree(phy_map);
> > +
> > +	return ret;
> > +}
> > diff --git a/drivers/net/wireless/realtek/rtw88/efuse.h
> b/drivers/net/wireless/realtek/rtw88/efuse.h
> > new file mode 100644
> > index 0000000..3635d08
> > --- /dev/null
> > +++ b/drivers/net/wireless/realtek/rtw88/efuse.h
> > @@ -0,0 +1,53 @@
> > +/* SPDX-License-Identifier: GPL-2.0 */
> > +/* Copyright(c) 2018  Realtek Corporation.
> > + */
> > +
> > +#ifndef __RTW_EFUSE_H__
> > +#define __RTW_EFUSE_H__
> > +
> > +#define EFUSE_HW_CAP_IGNORE		0
> > +#define EFUSE_HW_CAP_PTCL_VHT		3
> > +#define EFUSE_HW_CAP_SUPP_BW80		7
> > +#define EFUSE_HW_CAP_SUPP_BW40		6
> > +
> > +struct efuse_hw_cap {
> > +	u8 rsvd_0;
> > +	u8 rsvd_1;
> > +	u8 rsvd_2;
> > +	u8 rsvd_3;
> > +#ifdef __LITTLE_ENDIAN
> > +	u8 hci:4;
> > +	u8 rsvd_4:4;
> > +#else
> > +	u8 rsvd_4:4;
> > +	u8 hci:4;
> > +#endif
> 
> Ugh, do you *really* have too all this endian-aware bitfield layout?
> IIUC, a lot of the layout behavior is completely implementation
> specific. While you might get away with something like this, it doesn't
> seem particularly wise to me.
> 
> Also, don't you need __packed on this struct? Otherwise, you're not even
> really guaranteed your u8 fields to be aligned contiguously.
> 
> > +	u8 rsvd_5;
> > +#ifdef __LITTLE_ENDIAN
> > +	u8 bw:3;
> > +	u8 nss:2;
> > +	u8 ant_num:3;
> > +#else
> > +	u8 ant_num:3;
> > +	u8 nss:2;
> > +	u8 bw:3;
> > +#endif
> > +#ifdef __LITTLE_ENDIAN
> > +	u8 rsvd_7_1:2;
> > +	u8 ptcl:2;
> > +	u8 rsvd_7_2:4;
> > +#else
> > +	u8 rsvd_7_2:4;
> > +	u8 ptcl:2;
> > +	u8 rsvd_7_1:2;
> > +#endif
> > +	u8 rsvd_8;
> > +	u8 rsvd_9;
> > +	u8 rsvd_10;
> > +	u8 rsvd_11;
> > +	u8 rsvd_12;
> > +};


I think I can turn them into macros, such as:
#define GET_HW_CAP le32_get_bits(...)


> > +
> > +int rtw_parse_efuse_map(struct rtw_dev *rtwdev);
> > +
> > +#endif
> > diff --git a/drivers/net/wireless/realtek/rtw88/fw.c
> b/drivers/net/wireless/realtek/rtw88/fw.c
> > new file mode 100644
> > index 0000000..194bb87
> > --- /dev/null
> > +++ b/drivers/net/wireless/realtek/rtw88/fw.c
> > @@ -0,0 +1,611 @@
> 
> ...
> 
> > +int rtw_fw_write_data_rsvd_page(struct rtw_dev *rtwdev, u16 pg_addr,
> > +				u8 *buf, u32 size)
> > +{
> > +	u8 bckp[2];
> > +	u8 val;
> > +	u16 rsvd_pg_head;
> > +	int ret;
> > +
> > +	lockdep_assert_held(&rtwdev->mutex);
> > +
> > +	if (!size)
> > +		return -EINVAL;
> > +
> > +	pg_addr &= BIT_MASK_BCN_HEAD_1_V1;
> > +	rtw_write16(rtwdev, REG_FIFOPAGE_CTRL_2, pg_addr |
> BIT_BCN_VALID_V1);
> > +
> > +	val = rtw_read8(rtwdev, REG_CR + 1);
> > +	bckp[0] = val;
> > +	val |= BIT(0);
> 
> Magic number.
> 
> > +	rtw_write8(rtwdev, REG_CR + 1, val);
> > +
> > +	val = rtw_read8(rtwdev, REG_FWHW_TXQ_CTRL + 2);
> > +	bckp[1] = val;
> > +	val &= ~BIT(6);
> 
> Magic number.
> 
> Brian
> 

Yan-Hsuan
