Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24740C7EE23
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Jun 2023 14:16:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240111AbjFGOQQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 7 Jun 2023 10:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241078AbjFGOQN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Jun 2023 10:16:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE321BEC
        for <linux-wireless@vger.kernel.org>; Wed,  7 Jun 2023 07:16:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E70496253B
        for <linux-wireless@vger.kernel.org>; Wed,  7 Jun 2023 14:16:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81762C433D2;
        Wed,  7 Jun 2023 14:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1686147370;
        bh=TDiiOgK7sBmAEfQQeEI924x7a7GyjNXOecc1L8fD9z0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=EGd4uHceFjuebE56IEXuCGODpqk194ImMVlaDURGuVVYbKKkIwj7i4yeaEtDWpfQx
         eM//WsrmRJq5ViU1iIEJRKMFLaQEz1Nn1ruZUk/VnKbE9NmfLe+A0vPB3CcmOeuq7W
         LK9TukO5EIM/ACfPwF7yDsZXp5pPQcCrhfLDuriQ+HPg+HrLPOxjQ0s9P4/Fp+vsRy
         DpWdm40t1XpMBak0trJ+ak5dmdzILBlQGLUAloNJ0ffG+H22WiCRSgoTWDCByrpu7R
         EdLa0IEcH/3hnKjmmg3MfXEdDggPcYHeN62Vh5/urCXGZS7Okt3L2fzXza3uClmCGr
         f3nAlY3fO010A==
From:   Kalle Valo <kvalo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Shayne Chen <shayne.chen@mediatek.com>,
        Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Evelyn Tsai <evelyn.tsai@mediatek.com>,
        Bo Jiao <Bo.Jiao@mediatek.com>,
        linux-mediatek <linux-mediatek@lists.infradead.org>,
        Peter Chiu <chui-hao.chiu@mediatek.com>
Subject: Re: [PATCH 03/12] wifi: mt76: mt7996: add dsp firmware download
References: <20230602152108.26860-1-shayne.chen@mediatek.com>
        <20230602152108.26860-3-shayne.chen@mediatek.com>
        <ZHotQTUHbWOt/ibt@lore-desk>
Date:   Wed, 07 Jun 2023 17:16:02 +0300
In-Reply-To: <ZHotQTUHbWOt/ibt@lore-desk> (Lorenzo Bianconi's message of "Fri,
        2 Jun 2023 19:56:17 +0200")
Message-ID: <878rcvgxy5.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

(I moved Lorenzo's comment to better see the macro)

Lorenzo Bianconi <lorenzo@kernel.org> writes:

>> From: Peter Chiu <chui-hao.chiu@mediatek.com>
>> 
>> Add DSP firmware for phy-related control. The firmware is transparent to
>> driver, but it's necessary for the firmware download process.
>> 
>> Reviewed-by: Shayne Chen <shayne.chen@mediatek.com>
>> Signed-off-by: Peter Chiu <chui-hao.chiu@mediatek.com>
>> Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>

[...]

>> +#define LOAD_RAM(_type) \
>> +	do {									\
>> +		ret = request_firmware(&fw, MT7996_FIRMWARE_##_type, dev->mt76.dev);\
>> +		if (ret)							\
>> +			return ret;						\
>> +										\
>> +		if (!fw || !fw->data || fw->size < sizeof(*hdr)) {		\
>> +			dev_err(dev->mt76.dev, "Invalid firmware\n");		\
>> +			release_firmware(fw);					\
>> +			return -EINVAL;						\
>> +		}								\
>> +										\
>> +		hdr = (const struct mt7996_fw_trailer *)			\
>> +				(fw->data + fw->size - sizeof(*hdr));		\
>> +										\
>> +		dev_info(dev->mt76.dev,						\
>> +			 "%s Firmware Version: %.10s, Build Time: %.15s\n",	\
>> +			 #_type, hdr->fw_ver, hdr->build_date);			\
>> +										\
>> +		ret = mt7996_mcu_send_ram_firmware(dev, hdr, fw->data,		\
>> +						   MT7996_RAM_TYPE_##_type);    \
>> +		if (ret) {							\
>> +			dev_err(dev->mt76.dev, "Failed to start %s firmware\n", #_type);\
>> +			release_firmware(fw);					\
>> +			return ret;						\
>> +		}								\
>> +										\
>> +		release_firmware(fw);						\
>> +	} while (0)
>> +
>> +	LOAD_RAM(WM);
>> +	LOAD_RAM(DSP);
>> +	LOAD_RAM(WA);
>> +#undef LOAD_RAM
>
> I think it would be better to used a regular function instead of a macro, the
> code would be much easier to read.

Yeah, a function is preferred. I think Andrew Morton says: prefer C over
CPP

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
