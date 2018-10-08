Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD021C65C20
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 13:39:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A079920652
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 13:39:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A079920652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbeJHUvB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 16:51:01 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:55958 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbeJHUvB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 16:51:01 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g9VkX-0007C1-GR; Mon, 08 Oct 2018 15:39:05 +0200
Message-ID: <1539005934.3687.20.camel@sipsolutions.net>
Subject: Re: [RFC v3 05/12] rtw88: mac files
From:   Johannes Berg <johannes@sipsolutions.net>
To:     yhchuang@realtek.com, kvalo@codeaurora.org
Cc:     Larry.Finger@lwfinger.net, pkshih@realtek.com, tehuang@realtek.com,
        sgruszka@redhat.com, linux-wireless@vger.kernel.org
Date:   Mon, 08 Oct 2018 15:38:54 +0200
In-Reply-To: <1538565659-29530-6-git-send-email-yhchuang@realtek.com> (sfid-20181003_132140_785991_2EB9771B)
References: <1538565659-29530-1-git-send-email-yhchuang@realtek.com>
         <1538565659-29530-6-git-send-email-yhchuang@realtek.com>
         (sfid-20181003_132140_785991_2EB9771B)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2018-10-03 at 19:20 +0800, yhchuang@realtek.com wrote:
> 
> +	do {
> +		cnt--;
> +		value = rtw_read8(rtwdev, offset);
> +		value &= cmd->mask;
> +		if (value == (cmd->value & cmd->mask))
> +			return 0;
> +		if (cnt == 0) {
> +			if (rtw_hci_type(rtwdev) == RTW_HCI_TYPE_PCIE &&
> +			    flag == 0) {
> +				value = rtw_read8(rtwdev, REG_SYS_PW_CTRL);
> +				value |= BIT(3);
> +				rtw_write8(rtwdev, REG_SYS_PW_CTRL, value);
> +				value &= ~BIT(3);
> +				rtw_write8(rtwdev, REG_SYS_PW_CTRL, value);

It stands to reason this might need some sort of udelay() inbetween
togging the bit?

> +			value = rtw_read8(rtwdev, offset);
> +			value &= ~cur_cmd->mask;
> +			value |= (cur_cmd->value & cur_cmd->mask);
> +			rtw_write8(rtwdev, offset, value);

You might want to have a helper function/inline for this type of
sequence? Hmm, maybe I'm confusing it - now I can't find where I thought
it was also used elsewhere.

> +static bool check_firmware_size(const u8 *data, u32 size)
> +{
> +	u32 dmem_size;
> +	u32 imem_size;
> +	u32 emem_size;
> +	u32 real_size;
> +
> +	dmem_size = le32_to_cpu(*((__le32 *)(data + FW_HDR_DMEM_SIZE)));
> +	imem_size = le32_to_cpu(*((__le32 *)(data + FW_HDR_IMEM_SIZE)));
> +	emem_size = ((*(data + FW_HDR_MEM_USAGE)) & BIT(4)) ?
> +		    le32_to_cpu(*((__le32 *)(data + FW_HDR_EMEM_SIZE))) : 0;

This dereferencing data as __le32 seems very problematic due to
alignment concerns?

> +static bool ltecoex_read_reg(struct rtw_dev *rtwdev, u16 offset, u32 *val)
> +{
> +	u32 cnt = 10000;
> +
> +	while ((rtw_read8(rtwdev, LTECOEX_ACCESS_CTRL + 3) & BIT(5)) == 0) {
> +		if (cnt-- == 0)
> +			return false;
> +		udelay(50);
> +	}

You have this sort of loop a lot it seems - perhaps make a macro out of
it?

> +	buf = kmalloc(size, GFP_KERNEL);
> +	memcpy(buf, data, size);

kmemdup, but you need an error check too

> +	while (rtw_read32(rtwdev, REG_DDMA_CH0CTRL) & BIT_DDMACH0_OWN) {
> +		cnt--;
> +		if (cnt == 0)
> +			return -EBUSY;
> +	}

Here's another one of the loops, but it probably needs a udelay()?

> +static int iddma_download_firmware(struct rtw_dev *rtwdev, u32 src, u32 dst,
> +				   u32 len, u8 first)
> +{
> +	u32 cnt = DDMA_POLLING_COUNT;
> +	u32 ch0_ctrl = BIT_DDMACH0_CHKSUM_EN | BIT_DDMACH0_OWN;
> +
> +	while (rtw_read32(rtwdev, REG_DDMA_CH0CTRL) & BIT_DDMACH0_OWN) {
> +		cnt--;
> +		if (cnt == 0)
> +			return -EBUSY;
> +	}

and here

> +static void update_firmware_info(struct rtw_dev *rtwdev, const u8 *data)
> +{
> +	struct rtw_fw_state *fw = &rtwdev->fw;
> +
> +	fw->h2c_version =
> +		le16_to_cpu(*((__le16 *)(data + FW_HDR_H2C_FMT_VER)));
> +	fw->version =
> +		le16_to_cpu(*((__le16 *)(data + FW_HDR_VERSION)));

more potential alignment issues

> +start_download_firmware(struct rtw_dev *rtwdev, const u8 *data, u32 size)
> +{
> +	const u8 *cur_fw;
> +	u16 val;
> +	u16 fw_ctrl;
> +	u32 imem_size;
> +	u32 dmem_size;
> +	u32 emem_size;
> +	u32 addr;
> +	int ret;
> +
> +	dmem_size = le32_to_cpu(*((__le32 *)(data + FW_HDR_DMEM_SIZE)));
> +	imem_size = le32_to_cpu(*((__le32 *)(data + FW_HDR_IMEM_SIZE)));
> +	emem_size = ((*(data + FW_HDR_MEM_USAGE)) & BIT(4)) ?
> +		    le32_to_cpu(*((__le32 *)(data + FW_HDR_EMEM_SIZE))) : 0;

same here

> +	cnt = 1000;
> +	while (rtw_read8(rtwdev, REG_AUTO_LLT_V1) & BIT_AUTO_INIT_LLT_V1)
> +		if (cnt-- == 0)
> +			return -EBUSY;

missing udelay again?

johannes

