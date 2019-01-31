Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4AF8C169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 22:58:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F1DE2087F
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 22:58:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="W7mqjpHl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727962AbfAaW6P (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 17:58:15 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38055 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbfAaW6P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 17:58:15 -0500
Received: by mail-pf1-f195.google.com with SMTP id q1so2172450pfi.5
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jan 2019 14:58:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eFcPnk7NqbxzDV628Vwzvsh+B0Z5Qjn87p/vNSsjP3s=;
        b=W7mqjpHlj1cT+tZbvwGdNHSMKuZuo57BpSxpQscR9yQydwLzaQwGWl6bTr1zsBDcF8
         V/DfNzoyxSJ0SCwNfiq9lQKGPFgyQuHgDN7iwu2424RqzdZrcNb7oYSxqbYVuv/Xv4yh
         +FW3Yj/ZsDNxwx5r2X5pf8bba2zR1HUqdH5U4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eFcPnk7NqbxzDV628Vwzvsh+B0Z5Qjn87p/vNSsjP3s=;
        b=nN1AUnvCT+UM7kUO4PGuuGimppKK13aWVpVbAJp8358rnfYLl3WPLv4BaCXGONc22g
         IZAsk9vF68Hlz2GVy0GKdDpvztLBueDfjQOlQs0/8xR7Ik2KPI7uv7MHgEZ+hbC/NRLk
         qKuC6KV4rOgyTDjx7wpkg3lJC+Nt1esUPcNiwGNQ8vrDfIjOACV63AhyhlhMlFn7cM3Y
         FJNzkLuW0TFlHjUtNv/G0uiFLuHWQtOXTk/So24iPBX/7/X7RdBSKkOLA3XpuYWBKeYZ
         OAR8LNXRrwgrPB3HUrrvUAfBIk0bRSxS0xgsrid2+dPpmWrSTO5m/DdL+9umZXGso2SC
         M1cg==
X-Gm-Message-State: AJcUukep5sI+20A00iXovldWbXUxmjFQcUHv46okNalubvWdcuUMoGLj
        l8xjJFYDrc78/xQ84bOnafyzCw==
X-Google-Smtp-Source: ALg8bN79yhs5kSEPH1YtoLvytEffluzJJYhuAwXwU7edi19KPSxDL+ctVOXfwI0nkrg4/b3xr2UUCA==
X-Received: by 2002:a65:500c:: with SMTP id f12mr32911444pgo.226.1548975494146;
        Thu, 31 Jan 2019 14:58:14 -0800 (PST)
Received: from google.com ([2620:15c:202:1:534:b7c0:a63c:460c])
        by smtp.gmail.com with ESMTPSA id 85sm8588772pfw.17.2019.01.31.14.58.11
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 31 Jan 2019 14:58:12 -0800 (PST)
Date:   Thu, 31 Jan 2019 14:58:10 -0800
From:   Brian Norris <briannorris@chromium.org>
To:     yhchuang@realtek.com
Cc:     kvalo@codeaurora.org, johannes@sipsolutions.net,
        Larry.Finger@lwfinger.net, pkshih@realtek.com, tehuang@realtek.com,
        sgruszka@redhat.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 06/13] rtw88: fw and efuse files
Message-ID: <20190131225809.GB191502@google.com>
References: <1548820940-15237-1-git-send-email-yhchuang@realtek.com>
 <1548820940-15237-7-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1548820940-15237-7-git-send-email-yhchuang@realtek.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On Wed, Jan 30, 2019 at 12:02:13PM +0800, yhchuang@realtek.com wrote:
> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> 
> fw and efuse files for Realtek 802.11ac wireless network chips
> 
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> ---
>  drivers/net/wireless/realtek/rtw88/efuse.c | 150 +++++++
>  drivers/net/wireless/realtek/rtw88/efuse.h |  53 +++
>  drivers/net/wireless/realtek/rtw88/fw.c    | 611 +++++++++++++++++++++++++++++
>  drivers/net/wireless/realtek/rtw88/fw.h    | 213 ++++++++++
>  4 files changed, 1027 insertions(+)
>  create mode 100644 drivers/net/wireless/realtek/rtw88/efuse.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/efuse.h
>  create mode 100644 drivers/net/wireless/realtek/rtw88/fw.c
>  create mode 100644 drivers/net/wireless/realtek/rtw88/fw.h
> 
> diff --git a/drivers/net/wireless/realtek/rtw88/efuse.c b/drivers/net/wireless/realtek/rtw88/efuse.c
> new file mode 100644
> index 0000000..7c1b782
> --- /dev/null
> +++ b/drivers/net/wireless/realtek/rtw88/efuse.c
> @@ -0,0 +1,150 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright(c) 2018  Realtek Corporation.
> + */
> +
> +#include "main.h"
> +#include "efuse.h"
> +#include "reg.h"
> +#include "debug.h"
> +
> +#define RTW_EFUSE_BANK_WIFI		0x0
> +
> +static void switch_efuse_bank(struct rtw_dev *rtwdev)
> +{
> +	rtw_write32_mask(rtwdev, REG_LDO_EFUSE_CTRL, BIT_MASK_EFUSE_BANK_SEL,
> +			 RTW_EFUSE_BANK_WIFI);
> +}
> +
> +static int rtw_dump_logical_efuse_map(struct rtw_dev *rtwdev, u8 *phy_map,
> +				      u8 *log_map)
> +{
> +	u32 physical_size = rtwdev->efuse.physical_size;
> +	u32 protect_size = rtwdev->efuse.protect_size;
> +	u32 logical_size = rtwdev->efuse.logical_size;
> +	u32 phy_idx, log_idx;
> +	u8 hdr1, hdr2;
> +	u8 blk_idx;
> +	u8 valid;
> +	u8 word_en;
> +	int i;
> +
> +	phy_idx = 0;
> +
> +	do {

See my comments below about termination, but I think you need some
bounds checks up front to ensure you're not running over the buffers.
You have some checks at the end of the embedded for-loop, but it's not
clear you will always run them.

> +		hdr1 = *(phy_map + phy_idx);
> +		if ((hdr1 & 0x1f) == 0xf) {
> +			phy_idx++;
> +			hdr2 = *(phy_map + phy_idx);
> +			if (hdr2 == 0xff)
> +				break;
> +			blk_idx = ((hdr2 & 0xf0) >> 1) | ((hdr1 >> 5) & 0x07);
> +			word_en = hdr2 & 0x0f;
> +		} else {
> +			blk_idx = (hdr1 & 0xf0) >> 4;
> +			word_en = hdr1 & 0x0f;
> +		}
> +
> +		if (hdr1 == 0xff)
> +			break;
> +
> +		phy_idx++;
> +		for (i = 0; i < 4; i++) {
> +			valid = (~(word_en >> i)) & 0x1;
> +			if (valid != 0x1)
> +				continue;
> +			log_idx = (blk_idx << 3) + (i << 1);
> +			*(log_map + log_idx) = *(phy_map + phy_idx);
> +			log_idx++;
> +			phy_idx++;
> +			*(log_map + log_idx) = *(phy_map + phy_idx);
> +			phy_idx++;
> +			if (phy_idx > physical_size - protect_size ||
> +			    log_idx > logical_size)
> +				return -EINVAL;
> +		}
> +	} while (1);

This is a complicated and ugly loop. Can you make this easier to read?
Comments? Describe the layout in words or a diagram? Macros? At the
moment, I can't even guarantee that this while(1) loop is guaranteed to
terminate, let alone actually determine what exactly you're trying to
parse.

> +
> +	return 0;
> +}
> +
> +static int rtw_dump_physical_efuse_map(struct rtw_dev *rtwdev, u8 *map)
> +{
> +	struct rtw_chip_info *chip = rtwdev->chip;
> +	u32 size = rtwdev->efuse.physical_size;
> +	u32 efuse_ctl;
> +	u32 addr;
> +	u32 cnt;
> +
> +	switch_efuse_bank(rtwdev);
> +
> +	/* disable 2.5V LDO */
> +	chip->ops->cfg_ldo25(rtwdev, false);
> +
> +	efuse_ctl = rtw_read32(rtwdev, REG_EFUSE_CTRL);
> +
> +	for (addr = 0; addr < size; addr++) {
> +		efuse_ctl &= ~(BIT_MASK_EF_DATA | BITS_EF_ADDR);
> +		efuse_ctl |= (addr & BIT_MASK_EF_ADDR) << BIT_SHIFT_EF_ADDR;
> +		rtw_write32(rtwdev, REG_EFUSE_CTRL, efuse_ctl & (~BIT_EF_FLAG));
> +
> +		cnt = 1000000;
> +		do {
> +			udelay(1);
> +			efuse_ctl = rtw_read32(rtwdev, REG_EFUSE_CTRL);
> +			if (--cnt == 0)
> +				return -EBUSY;
> +		} while (!(efuse_ctl & BIT_EF_FLAG));
> +
> +		*(map + addr) = (u8)(efuse_ctl & BIT_MASK_EF_DATA);
> +	}
> +
> +	return 0;
> +}
> +
> +int rtw_parse_efuse_map(struct rtw_dev *rtwdev)
> +{
> +	struct rtw_chip_info *chip = rtwdev->chip;
> +	struct rtw_efuse *efuse = &rtwdev->efuse;
> +	u32 phy_size = efuse->physical_size;
> +	u32 log_size = efuse->logical_size;
> +	u8 *phy_map = NULL;
> +	u8 *log_map = NULL;
> +	int ret = 0;
> +
> +	phy_map = kmalloc(phy_size, GFP_KERNEL);
> +	log_map = kmalloc(log_size, GFP_KERNEL);
> +	if (!phy_map || !log_map) {
> +		ret = -ENOMEM;
> +		goto out_free;
> +	}
> +
> +	ret = rtw_dump_physical_efuse_map(rtwdev, phy_map);
> +	if (ret) {
> +		rtw_err(rtwdev, "failed to dump efuse physical map\n");
> +		goto out_free;
> +	}
> +
> +	memset(log_map, 0xff, log_size);
> +	ret = rtw_dump_logical_efuse_map(rtwdev, phy_map, log_map);
> +	if (ret) {
> +		rtw_err(rtwdev, "failed to dump efuse logical map\n");
> +		goto out_free;
> +	}
> +
> +	print_hex_dump_bytes("efuse: ", DUMP_PREFIX_OFFSET, log_map, log_size);

Do you really want to dump this at every boot? It goes at KERN_DEBUG
level, so it may or may not be showing up by default, but still, this
doesn't feel like the right thing here.

> +
> +	efuse->x3d7 = phy_map[0x3d7];
> +	efuse->x3d8 = phy_map[0x3d8];

Fortunately I had KASAN enabled (you should try it!), because it noticed
that on 8822C, this is out of bounds. See how 8822c's phy_efuse_size is
only 512, and so you end up reading beyond the end of the boundary.

Why are you doing this anyway? You don't use the ->x3d{7,8} fields
anywhere.

On a related note, it still feels like you have too many magic nubers in
some places.

> +
> +	ret = chip->ops->read_efuse(rtwdev, log_map);
> +	if (ret) {
> +		rtw_err(rtwdev, "failed to read efuse map\n");
> +		goto out_free;
> +	}
> +
> +out_free:
> +	kfree(log_map);
> +	kfree(phy_map);
> +
> +	return ret;
> +}
> diff --git a/drivers/net/wireless/realtek/rtw88/efuse.h b/drivers/net/wireless/realtek/rtw88/efuse.h
> new file mode 100644
> index 0000000..3635d08
> --- /dev/null
> +++ b/drivers/net/wireless/realtek/rtw88/efuse.h
> @@ -0,0 +1,53 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright(c) 2018  Realtek Corporation.
> + */
> +
> +#ifndef __RTW_EFUSE_H__
> +#define __RTW_EFUSE_H__
> +
> +#define EFUSE_HW_CAP_IGNORE		0
> +#define EFUSE_HW_CAP_PTCL_VHT		3
> +#define EFUSE_HW_CAP_SUPP_BW80		7
> +#define EFUSE_HW_CAP_SUPP_BW40		6
> +
> +struct efuse_hw_cap {
> +	u8 rsvd_0;
> +	u8 rsvd_1;
> +	u8 rsvd_2;
> +	u8 rsvd_3;
> +#ifdef __LITTLE_ENDIAN
> +	u8 hci:4;
> +	u8 rsvd_4:4;
> +#else
> +	u8 rsvd_4:4;
> +	u8 hci:4;
> +#endif

Ugh, do you *really* have too all this endian-aware bitfield layout?
IIUC, a lot of the layout behavior is completely implementation
specific. While you might get away with something like this, it doesn't
seem particularly wise to me.

Also, don't you need __packed on this struct? Otherwise, you're not even
really guaranteed your u8 fields to be aligned contiguously.

> +	u8 rsvd_5;
> +#ifdef __LITTLE_ENDIAN
> +	u8 bw:3;
> +	u8 nss:2;
> +	u8 ant_num:3;
> +#else
> +	u8 ant_num:3;
> +	u8 nss:2;
> +	u8 bw:3;
> +#endif
> +#ifdef __LITTLE_ENDIAN
> +	u8 rsvd_7_1:2;
> +	u8 ptcl:2;
> +	u8 rsvd_7_2:4;
> +#else
> +	u8 rsvd_7_2:4;
> +	u8 ptcl:2;
> +	u8 rsvd_7_1:2;
> +#endif
> +	u8 rsvd_8;
> +	u8 rsvd_9;
> +	u8 rsvd_10;
> +	u8 rsvd_11;
> +	u8 rsvd_12;
> +};
> +
> +int rtw_parse_efuse_map(struct rtw_dev *rtwdev);
> +
> +#endif
> diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
> new file mode 100644
> index 0000000..194bb87
> --- /dev/null
> +++ b/drivers/net/wireless/realtek/rtw88/fw.c
> @@ -0,0 +1,611 @@

...

> +int rtw_fw_write_data_rsvd_page(struct rtw_dev *rtwdev, u16 pg_addr,
> +				u8 *buf, u32 size)
> +{
> +	u8 bckp[2];
> +	u8 val;
> +	u16 rsvd_pg_head;
> +	int ret;
> +
> +	lockdep_assert_held(&rtwdev->mutex);
> +
> +	if (!size)
> +		return -EINVAL;
> +
> +	pg_addr &= BIT_MASK_BCN_HEAD_1_V1;
> +	rtw_write16(rtwdev, REG_FIFOPAGE_CTRL_2, pg_addr | BIT_BCN_VALID_V1);
> +
> +	val = rtw_read8(rtwdev, REG_CR + 1);
> +	bckp[0] = val;
> +	val |= BIT(0);

Magic number.

> +	rtw_write8(rtwdev, REG_CR + 1, val);
> +
> +	val = rtw_read8(rtwdev, REG_FWHW_TXQ_CTRL + 2);
> +	bckp[1] = val;
> +	val &= ~BIT(6);

Magic number.

Brian

> +	rtw_write8(rtwdev, REG_FWHW_TXQ_CTRL + 2, val);
> +
> +	ret = rtw_hci_write_data_rsvd_page(rtwdev, buf, size);
> +	if (ret) {
> +		rtw_err(rtwdev, "failed to write data to rsvd page\n");
> +		goto restore;
> +	}
> +
> +	if (!check_hw_ready(rtwdev, REG_FIFOPAGE_CTRL_2, BIT_BCN_VALID_V1, 1)) {
> +		rtw_err(rtwdev, "error beacon valid\n");
> +		ret = -EBUSY;
> +	}
> +
> +restore:
> +	rsvd_pg_head = rtwdev->fifo.rsvd_boundary;
> +	rtw_write16(rtwdev, REG_FIFOPAGE_CTRL_2,
> +		    rsvd_pg_head | BIT_BCN_VALID_V1);
> +	rtw_write8(rtwdev, REG_FWHW_TXQ_CTRL + 2, bckp[1]);
> +	rtw_write8(rtwdev, REG_CR + 1, bckp[0]);
> +
> +	return ret;
> +}
> +

... 
