Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2406BC43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 15:41:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF0CD2089A
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 15:41:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="X0wnqIQv";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ZQURk1B4"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BF0CD2089A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725815AbeJAWTb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 18:19:31 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:41970 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725740AbeJAWTb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 18:19:31 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 36A986076A; Mon,  1 Oct 2018 15:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538408468;
        bh=u8h2RFj5gwsGV/Cg5Rs2PWSskRuk25cideB31R1u+LE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=X0wnqIQvWAWVBiL9ZhG1BwvJ5VWUpbLKLcCigYTIJ9FBeODBOYvi9HGUPHwwZFxvl
         eLHs3kHURWPR83hFQhQHhgQ7ludAGDgvrkdQipeY4QJeaGE8ggz1x7EfL5O+MoO9rm
         f8MEZSnKZol7XXkpEo7WXqoePWMruxHIXOXJ6ae0=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 94EB66076A;
        Mon,  1 Oct 2018 15:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538408467;
        bh=u8h2RFj5gwsGV/Cg5Rs2PWSskRuk25cideB31R1u+LE=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=ZQURk1B4/7avidX6KiECdBAkj8/99zn7Tf3scCFCawM+v8GHg62Huc1Nnf9KesEgl
         eiiaSbrhDFySjJ3NVLJ1T4AFGHDK6YffHCcHHbMd31ibWIxSGTxQ6cTFC9rd42RoJE
         jienziBRP17IUe4QkIgdOtdzsLq+p4joW6cwuQ08=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 94EB66076A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH V2 01/11] qtnfmac_pcie: do not store FW name in driver
 state structure
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180924221514.4273-2-igor.mitsyanko.os@quantenna.com>
References: <20180924221514.4273-2-igor.mitsyanko.os@quantenna.com>
To:     Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Cc:     linux-wireless@vger.kernel.org,
        sergey.matyukevich.os@quantenna.com, ashevchenko@quantenna.com,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181001154108.36A986076A@smtp.codeaurora.org>
Date:   Mon,  1 Oct 2018 15:41:08 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Igor Mitsyanko <igor.mitsyanko.os@quantenna.com> wrote:

> Firmware name is only needed at probe stage, no point in keeping it in
> driver state structure.
> 
> Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>

11 patches applied to wireless-drivers-next.git, thanks.

4059afc6bd17 qtnfmac_pcie: do not store FW name in driver state structure
2ef0ecd71700 qtnfmac_pcie: move Pearl pcie sources to pcie-specific directory
91dcecece019 qtnfmac_pcie: rename private Pearl PCIe state structure
d0b95bfa1178 qtnfmac_pcie: indicate pearl-specific structures by their names
21077d09b4a6 qtnfmac_pcie: pearl: rename spinlock tx0_lock to tx_lock
c9ff6c9157c2 qtnfmac_pcie: separate platform-independent PCIe structure
789763b683eb qtnfmac_pcie: rename platform-specific functions
5163309e9a4d qtnfmac: add missing header includes to bus.h
addc7540708f qtnfmac_pcie: extract platform-independent PCIe code
86ca238cf1e9 qtnfmac: wait for FW load work to finish at PCIe remove
033a759921d1 qtnfmac_pcie: check for correct CHIP ID at pcie probe

-- 
https://patchwork.kernel.org/patch/10612935/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

