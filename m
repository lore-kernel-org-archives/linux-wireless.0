Return-Path: <SRS0=P1q9=MZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81867C28CF8
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 17:16:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7DC22064A
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 17:16:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="R2bjPHFo";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Veoe/DtY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B7DC22064A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726647AbeJNAyT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Oct 2018 20:54:19 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:42002 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726129AbeJNAyT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Oct 2018 20:54:19 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EB26460BF7; Sat, 13 Oct 2018 17:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539450981;
        bh=ZzjQHxEo5hmeqoOWUXb+Rq/79hKuagz+SBmjQb38SYs=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=R2bjPHFoXkEoHOaUJ6Vv4XaB1MpnfXhCvTxmg1kJgKIWi7iJOQPCpK3Qj0L1w22KS
         dL1w7EzrwAMyYaDGcMMxt6kZD6JmbEeA21iooZMbuPF4ARd0yyjZfLw0syTtGbAChH
         yx/TwtEOPI14fzki7xv652Oi9QZ2VtcTpSbAknj8=
Received: from potku.adurom.net (88-114-240-228.elisa-laajakaista.fi [88.114.240.228])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5120360A98;
        Sat, 13 Oct 2018 17:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539450981;
        bh=ZzjQHxEo5hmeqoOWUXb+Rq/79hKuagz+SBmjQb38SYs=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=Veoe/DtYjcNE9X+lNsL3nUvTxCt3tRWGdY7s9emF8NttTaji6niZRu0e+BsdkMJ3X
         s89YsYAcbZE7q3KMJOFS0uWUYZu2gm+t1FbRKW2nY3EqIYS/nw0dTlKn7GELBUJygA
         enGnU9VNbDFMqXTXamLUEfxARv0tJEhM0MZ8buYI=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5120360A98
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Fix possible out of bound access of ath10k_rates
 array
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1538536430-6555-1-git-send-email-srirrama@codeaurora.org>
References: <1538536430-6555-1-git-send-email-srirrama@codeaurora.org>
To:     Sriram R <srirrama@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Sriram R <srirrama@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181013171621.EB26460BF7@smtp.codeaurora.org>
Date:   Sat, 13 Oct 2018 17:16:21 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sriram R <srirrama@codeaurora.org> wrote:

> While using 'ath10k_mac_get_rate_hw_value()' to obtain the hw value
> from the passed bitrate, there is a chance of out of bound array access
> when wrong bitrate is passed. This is fixed by comparing the bitrates
> within the correct size of the ath10k_rates array.
> 
> Fixes commit f279294e9ee2 ("ath10k: add support for configuring management
> packet rate"). Also correction made to some indents used in the above commit.
> 
> Signed-off-by: Sriram R <srirrama@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

34e141eea7dd ath10k: fix possible out of bound access of ath10k_rates array

-- 
https://patchwork.kernel.org/patch/10624225/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

