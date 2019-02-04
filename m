Return-Path: <SRS0=6Uy3=QL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F6AAC282C4
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 15:52:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E566F2087C
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 15:52:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Mn3iU+i2";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RlkZkLIt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729219AbfBDPw0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Feb 2019 10:52:26 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:51174 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728379AbfBDPw0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Feb 2019 10:52:26 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CDDF46047C; Mon,  4 Feb 2019 15:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549295545;
        bh=XUjMbKwgkSIM54PB4jELZ9ovlzczm+wtbs80e0C/Pck=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Mn3iU+i2S4oEGGUv44colONBRVi2WONLd7o3Wj4f6aXMAy9++cXuTjw6uuuB8bV+n
         Gj8pzZeH195TfNaGUVuet6JW9zhoatf/vc6xqXSghnQKYYnfwk2hfzL8Wc+Ny64uFB
         /+LIDK1s/T715bb+OwOp66WIhXfFgqxcxMqZtodA=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5C3346047C;
        Mon,  4 Feb 2019 15:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549295545;
        bh=XUjMbKwgkSIM54PB4jELZ9ovlzczm+wtbs80e0C/Pck=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=RlkZkLItc1AOpvxCuD7jLo26/gspu+5fUZzdBuhhtCDS8Ob78AkXsTOzwxosxIQvZ
         qbD8JNdxRKdQlrL8y7pmfA8bcj3QOkHNG4RfFvnq43WzkOcmJL7fAj+zBPkwFj0Tmx
         cWMElMe0VBdahgDQDxWPq0nctPKx9Wbzay+hgLzY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5C3346047C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Add support for extended HTT aggr msg support
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190116112942.11687-1-govinds@codeaurora.org>
References: <20190116112942.11687-1-govinds@codeaurora.org>
To:     Govind Singh <govinds@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190204155225.CDDF46047C@smtp.codeaurora.org>
Date:   Mon,  4 Feb 2019 15:52:25 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Govind Singh <govinds@codeaurora.org> wrote:

> HTT aggr message parameter in HL2.0 fw are different in comparison
> to legacy fw version. Fill correct HTT aggr msg parameter for
> targets using HL2.0 firmware.
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

5cbb11747750 ath10k: Add support for extended HTT aggr msg support

-- 
https://patchwork.kernel.org/patch/10765773/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

