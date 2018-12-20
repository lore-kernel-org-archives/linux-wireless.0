Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA046C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 16:53:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAC3C21720
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 16:53:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="C9YUSE8a";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Zoa5+Uny"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732530AbeLTQxs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 11:53:48 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:45220 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727652AbeLTQxs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 11:53:48 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6F0A86053B; Thu, 20 Dec 2018 16:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545324827;
        bh=v9epmXo0GWaM6Q0d1JWIlr8Zd81k1lc/JPBAr53sCjM=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=C9YUSE8aeuNrCs9vbN1ZBMeqlP90JF+FCcnJZu2HntoVnS+pAKxyKmzsmJmNQNc2m
         CS+tMUe+9AyTd6cBFa9V5MAH+lyzlCn0eKWkVaZRu8VQ2BsQtsUhf2IVZqU48e2TJn
         uGEM94K9AOfBMycfw2Jko33lJb10IbuoHK07pdLw=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5FFE560734;
        Thu, 20 Dec 2018 16:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545324827;
        bh=v9epmXo0GWaM6Q0d1JWIlr8Zd81k1lc/JPBAr53sCjM=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Zoa5+UnyMim+SXBPh9FXFwGCV/u3pJcPVx+XfJQv3c+qi5qbmuAFL8WMRvU52MVgA
         8eihXbXnngrzeJBzqpjzxyqxaQ7ho1ZmvoP+KRYszYulvyHM31hJVLBQhCCjeNKCGc
         6GPlheHPI97bOctQ/e5NpMx4PGDW9UqqM7LnwEqM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5FFE560734
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: add amsdu support for monitor mode
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1540794104-30957-2-git-send-email-yyuwang@codeaurora.org>
References: <1540794104-30957-2-git-send-email-yyuwang@codeaurora.org>
To:     Yu Wang <yyuwang@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181220165347.6F0A86053B@smtp.codeaurora.org>
Date:   Thu, 20 Dec 2018 16:53:47 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Yu Wang <yyuwang@codeaurora.org> wrote:

> When processing HTT_T2H_MSG_TYPE_RX_IN_ORD_PADDR_IND, if the length of a msdu
> is larger than the tailroom of the rx skb, skb_over_panic issue will happen
> when calling skb_put.  In monitor mode, amsdu will be handled in this path, and
> msdu_len of the first msdu_desc is the length of the entire amsdu, which might
> be larger than the maximum length of a skb, in such case, it will hit the issue
> upon.
> 
> To fix this issue, process msdu list separately for monitor mode.
> 
> Successfully tested with:
> QCA6174 (FW version: RM.4.4.1.c2-00057-QCARMSWP-1).
> 
> Signed-off-by: Yu Wang <yyuwang@codeaurora.org>
> [kvalo@codeaurora.org: cosmetic cleanup]
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

85bd0107c6cd ath10k: add amsdu support for monitor mode

-- 
https://patchwork.kernel.org/patch/10658777/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

