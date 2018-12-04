Return-Path: <SRS0=aqaD=ON=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D458C04EB8
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Dec 2018 06:37:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 632DD20834
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Dec 2018 06:37:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="A44iM7yW";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IC4MyIz9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 632DD20834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbeLDGhk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 4 Dec 2018 01:37:40 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:40216 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbeLDGhj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Dec 2018 01:37:39 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 19DCF60312; Tue,  4 Dec 2018 06:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543905459;
        bh=+OhuQiKyuWU4jFJMt88RjkM4v9r+fvPvcC6KiVoNN2k=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=A44iM7yWRl8ERtmnxM3579WF8AGfgaIz4k/ovk4ddw8+7eLOtT4xV2+Oq3aOMWBRn
         4d+0TWqtpAaeoKC4y1hAl86H+o0BwFrzJyBrSXNYeMN/Czy6m3I32pdtL4NQDip70/
         euQlr2xrveVKg9l7fZ6EMa9aLnpDiJxWcHECygBM=
Received: from x230.qca.qualcomm.com (unknown [83.145.195.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 1A2E4601D1;
        Tue,  4 Dec 2018 06:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543905458;
        bh=+OhuQiKyuWU4jFJMt88RjkM4v9r+fvPvcC6KiVoNN2k=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=IC4MyIz9Zrf1RNkT16cq+JGNTheLr1A6HlFO60Iz7desuygRo1r+ZMgj9A2ZnIwH+
         PV4wmLBA85uRekB6cIloyXUJQj4UM4JHMJgupSc0sXj27cCKaCEUmzYRA/TUbcVlLy
         l4D8LYCFCRmpxd8FkS6QqBcRkQiS6LlThpRZqZ5Y=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 1A2E4601D1
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Brian Norris <briannorris@chromium.org>
Cc:     Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] mwifiex: debugfs: correct histogram spacing, formatting
References: <20181130225303.143409-1-briannorris@chromium.org>
        <eef7598bb282218d4700986b15cf9f83a5e7edb5.camel@perches.com>
        <20181203222654.GA155572@google.com>
Date:   Tue, 04 Dec 2018 08:37:30 +0200
In-Reply-To: <20181203222654.GA155572@google.com> (Brian Norris's message of
        "Mon, 3 Dec 2018 14:26:55 -0800")
Message-ID: <87k1kper11.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Brian Norris <briannorris@chromium.org> writes:

> Here's a v2 that combines both sets of strings in that way. I'm not
> resending the other patches, since they were only related in concept
> (since I was referring to debugfs for implementing the nl80211 stuff),
> but have no real dependency.
>
> @Kalle: I can resend the others as a new series if that helps.

Yeah, it does. Trying to pick patches from different places in patchwork
is just too much of a hassle for me. So please do resend the whole
series.

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#resubmit_the_whole_patchset

-- 
Kalle Valo
