Return-Path: <SRS0=2ErG=MR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5830AC65BA7
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:19:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 185532064D
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Oct 2018 08:19:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="A1HoBydv";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cnr2ko0T"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 185532064D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbeJEPRV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Oct 2018 11:17:21 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:50168 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727236AbeJEPRV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Oct 2018 11:17:21 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D3428607DC; Fri,  5 Oct 2018 08:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538727583;
        bh=sGbpPFc2DizseqU4zgrGg0rJ1N8MfvAxbHjqcKnfRC0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=A1HoBydvYBWVID8C5JrGNvPg+GWd7Pg/GPax/mSLDilv5ZZTbyg/0NDIzBhiW1ZC9
         FoGux7e9Flt3MbAzceyFsbVrzjeFtHEvqm4Fz8JkTw9OLMpNw73NW9164nb0N+sg54
         gPYSe3TZlPWjCXdDwROQh8VX8xKrtvfNDrcXoKRs=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1565F601A0;
        Fri,  5 Oct 2018 08:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538727582;
        bh=sGbpPFc2DizseqU4zgrGg0rJ1N8MfvAxbHjqcKnfRC0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=cnr2ko0TjMOtx9XTLT4N9hPavVhdWEiTgLevyxAXR9W8wYAWe23faZ+zlg/cWsYNE
         63AQHhV48vVl4MSx8zFR4gOQRz6Z7AOOKOYm39BaDSHzSM8ekyDiCMMLgbu3N1qPxe
         T8ocV6jk1XqVutKG0nmZOXkALiDVYv/KhzONOQPY=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1565F601A0
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com>
Cc:     "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko OS <igor.mitsyanko.os@quantenna.com>
Subject: Re: [PATCH 00/13] qtnfmac: fixes and cleanups for STA mode
References: <20181002092542.18966-1-sergey.matyukevich.os@quantenna.com>
Date:   Fri, 05 Oct 2018 11:19:39 +0300
In-Reply-To: <20181002092542.18966-1-sergey.matyukevich.os@quantenna.com>
        (Sergey Matyukevich's message of "Tue, 2 Oct 2018 09:25:54 +0000")
Message-ID: <87mursrejo.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sergey Matyukevich OS <sergey.matyukevich.os@quantenna.com> writes:

> Hello Kalle and all, 
>
> Here is the next  patch set with fixes and cleanups for qtnfmac driver.
> This set mostly consists of multiple fixes and improvements for STA
> mode. The major changes include the following items:
> - fixes for 'iw' output: rates for enabled SGI, 'dump station'
> - expose more scan features to host: scan flush and dwell time
> - inform host wireless core when OBSS is not supported by firmware
> - command processing cleanup: unify and get rid of 'unlikely' macros

The string "OS" is again in the from field. Can you fix that and resend, please?

-- 
Kalle Valo
