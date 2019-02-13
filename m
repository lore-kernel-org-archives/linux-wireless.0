Return-Path: <SRS0=xkZe=QU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF452C282C2
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 11:05:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4456222B2
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 11:05:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Fxx1WfKf";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OeeMFkIt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387925AbfBMLFG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Feb 2019 06:05:06 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:51514 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbfBMLFG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Feb 2019 06:05:06 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 41B186095F; Wed, 13 Feb 2019 11:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550055905;
        bh=Z9Mt+k0czYkoBiXgRejUHFWTNSUM4VL67OMATzyihgI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Fxx1WfKfTGVvZrfl8Nv7nsH1Qg5mJtdBNHMB9A8n9nNqBnJeZ2cCHFcGfFyXXeTn+
         yUqfzb63TKasEsgtf+2TulhiAMWJKMU50rj1ICqZDwth/Ld6KmE6VLIe6fSfFfaBd7
         fKg98pJ/qh3o7SDE0TQL2gjncVwDPxGq/1tjuelA=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B05A960740;
        Wed, 13 Feb 2019 11:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1550055904;
        bh=Z9Mt+k0czYkoBiXgRejUHFWTNSUM4VL67OMATzyihgI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=OeeMFkItEAf+9KIAmHQNOM9Mnol8ez7Mg/RYT6oPyKKGJ8rh3mQ+smUWeIU8yrJKh
         Tr1Malg7yZy9bnEbVhPlCDbl5Z5pzsKuIKRxVcuWbuHnnbk6rnNW5yoQs0qEPSrbAF
         aWeXtT8SSvoeYmWIq0s3Lh+M0I6rMQ+w2AS82hVg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B05A960740
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH v3 09/12] ath: Basic Extended Key ID support (COMPAT+NATIVE)
References: <20190210210620.31181-1-alexander@wetzel-home.de>
        <20190210210620.31181-10-alexander@wetzel-home.de>
Date:   Wed, 13 Feb 2019 13:05:00 +0200
In-Reply-To: <20190210210620.31181-10-alexander@wetzel-home.de> (Alexander
        Wetzel's message of "Sun, 10 Feb 2019 22:06:17 +0100")
Message-ID: <87r2ccq78j.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Alexander Wetzel <alexander@wetzel-home.de> writes:

> Extend the shared ath key cache code to support Extended Key ID.
>
> The key cache code has to accept unicast keys to use key idx 1 and allow
> drivers to enable/disable hardware Rx decryption for a key independent
> from Tx.
>
> Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
> ---
>
> I know this is the wrong audience to discuss ath drivers.

I think this is the right forum. Do note that somewhere in this patch
(in the cover letter) you mentioned "all ath drivers" but AFAICS this
patch only changes functionality for ath5k, ath9k and ath9k_htc. All the
rest like wil6210, ath6kl and ath10k are unaffected.

-- 
Kalle Valo
