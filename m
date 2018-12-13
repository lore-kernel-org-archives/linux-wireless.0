Return-Path: <SRS0=opxv=OW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE70AC65BAE
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 14:04:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A072620849
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 14:04:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PmRX9BEk";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PmRX9BEk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A072620849
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728530AbeLMOE0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Dec 2018 09:04:26 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:51792 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728195AbeLMOE0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Dec 2018 09:04:26 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 998696071B; Thu, 13 Dec 2018 14:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544709865;
        bh=DMBSBe+XX7evyU8W+x+z3BC8LuBHpi0TFzpxFfiXQdg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=PmRX9BEkChVtTSlcYAtW5idjsiByxdY+YHgLlO+mh/cI3K+jeRZBxH//PoFtPV3XH
         U99av2g3Omat/iIlZJErmdRS/oB9qrGZCnHGgxfYBMpzLIa+/uONSjKcGpx+qbo6o5
         XFs4ORUwmucCwXP0TstgpLufFqZlXl6P5kvFy0A4=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 712AB602FA;
        Thu, 13 Dec 2018 14:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544709865;
        bh=DMBSBe+XX7evyU8W+x+z3BC8LuBHpi0TFzpxFfiXQdg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=PmRX9BEkChVtTSlcYAtW5idjsiByxdY+YHgLlO+mh/cI3K+jeRZBxH//PoFtPV3XH
         U99av2g3Omat/iIlZJErmdRS/oB9qrGZCnHGgxfYBMpzLIa+/uONSjKcGpx+qbo6o5
         XFs4ORUwmucCwXP0TstgpLufFqZlXl6P5kvFy0A4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 712AB602FA
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull request: mt76 2018-11-30
References: <b65d2a36-4cf4-1536-fd0f-f3bcbaf000fc@nbd.name>
Date:   Thu, 13 Dec 2018 16:04:21 +0200
In-Reply-To: <b65d2a36-4cf4-1536-fd0f-f3bcbaf000fc@nbd.name> (Felix Fietkau's
        message of "Fri, 30 Nov 2018 12:34:25 +0100")
Message-ID: <87sgz1y13u.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> Hi Kalle,
>
> here's my first pull request for 4.21
>
> - Felix
>
> The following changes since commit b72c51a58e6d63ef673ac96b8ab5bc98799c5f7b:
>
>   brcmfmac: Fix out of bounds memory access during fw load (2018-11-29 17:33:10 +0200)
>
> are available in the Git repository at:
>
>   https://github.com/nbd168/wireless tags/mt76-for-kvalo-2018-11-30
>
> for you to fetch changes up to e28487ea84a9c081c6d8d7da319427f7fcc32ff5:
>
>   mt76: replace sta_add/remove ops with common sta_state function (2018-11-30 12:30:37 +0100)
>
> ----------------------------------------------------------------
> first batch of mt76 patches for 4.21
>
> * use the same firmware for mt76x2e and mt76x2u
> * mt76x2 fixes
> * mt76x0 fixes
> * mt76x0e survey support
> * more unification between mt76x2 and mt76x0
> * mt76x0e AP mode support
> * mt76x0e DFS support
> * rework and fix tx status handling for mt76x0 and mt76x2
>
> ----------------------------------------------------------------

Pulled, thanks.

-- 
Kalle Valo
