Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3667C43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 14:06:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B544213A2
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 14:06:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="T+3XrUsS";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HCpG/tFe"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5B544213A2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729405AbeJAUoL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 16:44:11 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:34412 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728979AbeJAUoK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 16:44:10 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 42D8060128; Mon,  1 Oct 2018 14:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538402772;
        bh=KuCCZ0wsqJIj7cE3gAMJU7hz/c6uvuYIkE9duMxbxE0=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=T+3XrUsSu4ToPqRVpe711Djdn76nARsNX0IcZV6B7+ixES/ssyywb17GIpqkndsl6
         B6kMjoe8W6WuMKmEqgUQUZu59zlJ/lPsdhgZFzq3KujjJnj+lWKv9uJwJcuqKVaFz7
         LO7rU6M0dryBDW41NbAxqAx5f6xtwlvbg63Rk7tI=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 35AF060128;
        Mon,  1 Oct 2018 14:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538402771;
        bh=KuCCZ0wsqJIj7cE3gAMJU7hz/c6uvuYIkE9duMxbxE0=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=HCpG/tFe3kdssMa8NSFZwcjRCrJnyB4JAfn4Ku3ZklAjZmrkCZYZKl3SsM3Q5B8rK
         bKsMaoHOXQsZiOYeV5nQBTdsMEqqu8MZegeFZJWzs1+kdPXIhipRmbI+Mz0ytl9TEu
         x3Acz0jlDYANlBTZp+l7+rMqzif2v1PYc9rGmrfU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 35AF060128
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath9k: add reset for airtime station debugfs
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180906035323.GA11337@nems_nctu_lu>
References: <20180906035323.GA11337@nems_nctu_lu>
To:     Louie Lu <git@louie.lu>
Cc:     ath9k-devel@qca.qualcomm.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        toke@toke.dk
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181001140612.42D8060128@smtp.codeaurora.org>
Date:   Mon,  1 Oct 2018 14:06:12 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Louie Lu <git@louie.lu> wrote:

> Let user can reset station airtime status by debugfs, it will
> reset all airtime deficit to ATH_AIRTIME_QUANTUM and reset rx/tx
> airtime accumulate to 0.
> 
> Signed-off-by: Louie Lu <git@louie.lu>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

3fa8d2186550 ath9k: add reset for airtime station debugfs

-- 
https://patchwork.kernel.org/patch/10589835/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

