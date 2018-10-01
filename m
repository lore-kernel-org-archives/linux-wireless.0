Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9C04C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 15:43:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DAC32089A
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 15:43:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="S5fRZk0H";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lKvJj6Bq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7DAC32089A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbeJAWVi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 18:21:38 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:42896 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725738AbeJAWVi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 18:21:38 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A8F5360C1D; Mon,  1 Oct 2018 15:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538408593;
        bh=2ROj9yBxlwpUHUlk9aND9/0ZGHLV+77WiAJgD4yijG0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=S5fRZk0HN0d0Vp2lnKnFfEFZ7ao1CvSekPZ67GzkrYQ+VsNUMCDN1vuj4ggXLiTxR
         PJ0YscVaOcMVlIkJpsMzqt/0L131kUaaUl3/daMTIiAWMoVfTg7bJiEJUCtikQrwIf
         HUwQ7dhblJyKm1/P+dT4zNABCpg0L+OnDGfxvv4Q=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id ED3A06076A;
        Mon,  1 Oct 2018 15:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538408592;
        bh=2ROj9yBxlwpUHUlk9aND9/0ZGHLV+77WiAJgD4yijG0=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=lKvJj6BqNLo18CRJxP05DXH1QiNPs8m07Re9xx6W3eeMxqP7nLCppYc8tJZmBi0vP
         s5gndP47e7GF87K0jKHo9mfkB3zPoaBimxPG8Z5+LDHn5h1NWBF+aBtk1zbA7HapM9
         VJf+QCzLc1VSue4sywjmR+mKj/DWJr9axPyM4Sh8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org ED3A06076A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] b43: fix spelling mistake "hw_registred" ->
 "hw_registered"
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180927161119.6698-1-colin.king@canonical.com>
References: <20180927161119.6698-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181001154313.A8F5360C1D@smtp.codeaurora.org>
Date:   Mon,  1 Oct 2018 15:43:13 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Trivial fix to spelling mistake struct field name, rename it.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Patch applied to wireless-drivers-next.git, thanks.

297fab130cdf b43: fix spelling mistake "hw_registred" -> "hw_registered"

-- 
https://patchwork.kernel.org/patch/10618179/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

