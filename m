Return-Path: <SRS0=qpxp=O4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AB11C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 13:25:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0760420989
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 13:25:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="nftAkf5l";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KL5sVoJd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729272AbeLSNZo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Dec 2018 08:25:44 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:33432 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbeLSNZn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Dec 2018 08:25:43 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 4286761B98; Wed, 19 Dec 2018 13:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545225943;
        bh=tqTWUxtFmUHYX0p29Gz4xrmZ9LNhxLPiyifJOyGuopU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=nftAkf5l6Ni/lF/69sBHitOrApVO1MJYyxB7DDYC3wZ8ssjKeVuHaIVIAe3JidCcT
         RdzYkXQ2XUc3Bg3VJgHjRQs4Nt/LT1yWs38DOg3LFzOS9ACZrDtwKAty+fFsark4NC
         AhctfcUV4N/yHMw42GqbTVl3/mrhAp9+TmpPxI6c=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B6351619AF;
        Wed, 19 Dec 2018 13:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545225941;
        bh=tqTWUxtFmUHYX0p29Gz4xrmZ9LNhxLPiyifJOyGuopU=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=KL5sVoJdKIlxuPlMmDsI7qSN+8a87/T/hZsu5Iej3a182wfxmy74D8/TG/p7C7eB0
         bhJYztsJZPY/TCvlVbc2DepaD/P5RWlJPianxBZjP9hRnSC4i1s5t3SeHkWPf4SQfw
         u6jei1kqqPsZ5ndoFp0gfjuPDugUDSlpZq8naCU0=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B6351619AF
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Kan Yan <kyan@google.com>, make-wifi-fast@lists.bufferbloat.net
Subject: Re: [PATCH v5 6/6] ath10k: reporting estimated tx airtime for fairness
References: <1545181331-5288-1-git-send-email-rmanohar@codeaurora.org>
        <1545181331-5288-7-git-send-email-rmanohar@codeaurora.org>
Date:   Wed, 19 Dec 2018 15:25:37 +0200
In-Reply-To: <1545181331-5288-7-git-send-email-rmanohar@codeaurora.org>
        (Rajkumar Manoharan's message of "Tue, 18 Dec 2018 17:02:11 -0800")
Message-ID: <87k1k5veb2.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> From: Kan Yan <kyan@google.com>
>
> Transmit airtime will be estimated from last tx rate used.
> Firmware report tx rate by peer stats. Airtime is computed
> on tx path and the same will be reported to mac80211 upon
> tx completion.
>
> This change is based on Kan's orginal commit in Chromium tree
> ("CHROMIUM: ath10k: Implementing airtime fairness based TX scheduler")
> ref: https://chromium-review.googlesource.com/588190
>
> Signed-off-by: Kan Yan <kyan@google.com>
> [rmanohar@codeaurora.org: ported only the airtime computation]
> Signed-off-by: Rajkumar Manoharan <rmanohar@codeaurora.org>

Same as with patch 5, let me know the tested hardware and firmware so I
can add it to the commit log.

-- 
Kalle Valo
