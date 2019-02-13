Return-Path: <SRS0=xkZe=QU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18A50C282C2
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 16:40:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CFA5D222B2
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 16:40:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KxGr/eFF";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Lpanqxnk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404221AbfBMQky (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Feb 2019 11:40:54 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:59586 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392704AbfBMQkx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Feb 2019 11:40:53 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9C00A608D2; Wed, 13 Feb 2019 16:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550076053;
        bh=W8yV57rtezoQ6j5uEI2k0oMkghwavhnGkNWFantJMtE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=KxGr/eFFDurqV06YkPXIYHwztufOMAqvfHS4osFeeBZuDSZln7gkqTJdwjgQHw2eK
         gUp1F/kyoa761BL7Brd6hCVsS27Ue8Yl7KAZWOiV1pvX+P6txDQ4ymO5rdpwldkt1c
         1PdnKtkkEO+L1Voj2GFDjTPsVfsOK/to7ZHimSyY=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 05A376092B;
        Wed, 13 Feb 2019 16:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550076051;
        bh=W8yV57rtezoQ6j5uEI2k0oMkghwavhnGkNWFantJMtE=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=LpanqxnkzVXcOExDqpdL2mgUR45DDPPYdvLBnWGjHn0KZnDDY5aFN/gts3jieKTc8
         8j84vsv+bQ7cJGlmfqUL+k7rCkFaaz6lBoxyUBfxR9bceAUOVvyjGHnK4T9K3p9jpn
         JKe1wtBGyye7C4PTofyq1ZUGt7hcVvBsTxKK9YnU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 05A376092B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 01/12] wil6210: remove rtap_include_phy_info module
 param
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1548689786-23288-2-git-send-email-merez@codeaurora.org>
References: <1548689786-23288-2-git-send-email-merez@codeaurora.org>
To:     Maya Erez <merez@codeaurora.org>
Cc:     Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190213164052.9C00A608D2@smtp.codeaurora.org>
Date:   Wed, 13 Feb 2019 16:40:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Maya Erez <merez@codeaurora.org> wrote:

> rtap_include_phy_info is not in use, hence can be removed.
> 
> Signed-off-by: Maya Erez <merez@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Kbuild bot reported a warning:

   drivers/net/wireless/ath/wil6210/txrx.c: In function 'wil_vring_reap_rx':
>> drivers/net/wireless/ath/wil6210/txrx.c:341:25: warning: 'rtap' may be used uninitialized in this function [-Wmaybe-uninitialized]
     rtap->rthdr.it_version = PKTHDR_RADIOTAP_VERSION;

-- 
https://patchwork.kernel.org/patch/10783915/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

