Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51454C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 17:06:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F58B20815
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 17:06:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="d/za9dbY";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cvgqwllC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733254AbeLTRGZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 12:06:25 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:35462 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729720AbeLTRGZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 12:06:25 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5414060736; Thu, 20 Dec 2018 17:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545325584;
        bh=AQEcJwlr/QaIQBqRGIUSWmGAUeg+dv/7ihL+7P7qs0M=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=d/za9dbYGRYsG2OMil00JEUQM3VXBog/ID85yYpFpoOS5/Oh1hL39bjrbJynvEQBt
         DWb+tg027wxeZ/Tgd9CV+1PsKfALFOtgS9+GBA+gUlW74trjRpwzLlFJZn94T66eDe
         Z0rGOetGo2WxJKJ7vB3UnB8TBX0tpZUeGMO9oGF0=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 08F046014B;
        Thu, 20 Dec 2018 17:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545325584;
        bh=AQEcJwlr/QaIQBqRGIUSWmGAUeg+dv/7ihL+7P7qs0M=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=cvgqwllCiC0qVRIB2v8OL9lpeVcb43OhknGzH5AkcIW0cGHj00Mr5QnvmU9mOJU5y
         Uxgl1l0s/7pfDw6fiTxJZ4SsaxVnzeduUUj+RbPEGYUk1dmb/fcoGOzWvCk2UV94gL
         mE2PFCgmlY50DWvEw0lK1UHZkYQw6I3fb9y3Jvs8=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 08F046014B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: Move non-fatal warn logs to dbg level
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181129042522.11767-1-govinds@codeaurora.org>
References: <20181129042522.11767-1-govinds@codeaurora.org>
To:     Govind Singh <govinds@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181220170624.5414060736@smtp.codeaurora.org>
Date:   Thu, 20 Dec 2018 17:06:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Govind Singh <govinds@codeaurora.org> wrote:

> During driver load below warn logs are printed in the console.
> Since driver may not implement all wmi events sent by fw and
> all of them are non-fatal, move this log to debug level to
> remove un-necessary warn message on console.
> 
> [  361.887230] ath10k_snoc a000000.wifi: Unknown eventid: 16393
> [  361.907037] ath10k_snoc a000000.wifi: Unknown eventid: 237569
> 
> Signed-off-by: Govind Singh <govinds@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

bd085be6ba95 ath10k: move non-fatal warn logs to dbg level

-- 
https://patchwork.kernel.org/patch/10703901/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

