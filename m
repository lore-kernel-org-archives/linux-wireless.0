Return-Path: <SRS0=TNca=MO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABA66C43143
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 04:54:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B26C20684
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Oct 2018 04:54:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="l1usE4f7";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="X16TcwOK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5B26C20684
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbeJBLgN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Oct 2018 07:36:13 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:35712 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbeJBLgN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Oct 2018 07:36:13 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 50E3F60C1D; Tue,  2 Oct 2018 04:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538456096;
        bh=EZid4/EUyCrXZOCz8UyucXaszbOzpZfPYZ+dP4oDZ2A=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=l1usE4f7nROpLQCZsxXw2i6USf3bNjATo8BJ5qkmO8Q9pSPGW+DhoL95g63U+nsVP
         wcj4VsRhb2aPLyi6eGEMY7XWEPZ3T1yRoCIFq+YxEbe3jq0LmgFG1osbYYLDcdBoZv
         7AW4CKfKRg4MurmouJVGDVV1q0WqcVXEWInuL/CI=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6053260A98;
        Tue,  2 Oct 2018 04:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538456096;
        bh=EZid4/EUyCrXZOCz8UyucXaszbOzpZfPYZ+dP4oDZ2A=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=X16TcwOKjA+8PaFnTdJ9PN0GiNLKIRMI02eAAxZm6yzQeQv/xc6GHloz6ClM5tmuL
         blG2gbBmNuQVNOCTT5sv9ZuWjCCLrGZMz9beV7828ga9dt353UfRdl3ZV3jKI89DdG
         h6CSDe1J1D8d5ks9hcIzJrEOLZgEMghO5p8InGfE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6053260A98
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath9k: add back support for using active monitor
 interfaces for tx99
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20180922164905.46751-1-nbd@nbd.name>
References: <20180922164905.46751-1-nbd@nbd.name>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181002045456.50E3F60C1D@smtp.codeaurora.org>
Date:   Tue,  2 Oct 2018 04:54:56 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> wrote:

> Various documented examples on how to set up tx99 with ath9k rely
> on setting up a regular monitor interface for setting the channel.
> My previous patch "ath9k: fix tx99 with monitor mode interface" made
> it possible to set it up this way again. However, it was removing support
> for using an active monitor interface, which is required for controlling
> the bitrate as well, since the bitrate is not passed down with a regular
> monitor interface.
> 
> This patch partially reverts the previous one, but keeps support for using
> a regular monitor interface to keep documented steps working in cases
> where the bitrate does not matter
> 
> Fixes: d9c52fd17cb48 ("ath9k: fix tx99 with monitor mode interface")
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

6df0580be8bc ath9k: add back support for using active monitor interfaces for tx99

-- 
https://patchwork.kernel.org/patch/10612069/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

