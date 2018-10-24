Return-Path: <SRS0=AjP+=NE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1811FC004D3
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 08:33:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B92BF2075D
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 08:33:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OAFDFYjE";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OAFDFYjE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B92BF2075D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727338AbeJXRAo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Oct 2018 13:00:44 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:35036 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727224AbeJXRAn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Oct 2018 13:00:43 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id F075C60C64; Wed, 24 Oct 2018 08:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540370014;
        bh=2bTfVyVAK2E/b4vbtTdDA7sOBBViOyWmcgz75gPKjxI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=OAFDFYjE6cAPsEyDlPuSMzKcSncDoyBhoTjk6VhmkhsYLswu2SOMrdSHS8frPzLRy
         qlUH0MYNG15nNQvMSR04yRbTVSLAjwkpNTyXYqmEBoRgsXE0yRnlnlxBQ9HPjcu0xw
         eddsA9UPl8axiUhmzEwSFkmoSmakmnLg8qvkdguQ=
Received: from x230.qca.qualcomm.com (87-93-79-96.bb.dnainternet.fi [87.93.79.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 11F0460364;
        Wed, 24 Oct 2018 08:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540370014;
        bh=2bTfVyVAK2E/b4vbtTdDA7sOBBViOyWmcgz75gPKjxI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=OAFDFYjE6cAPsEyDlPuSMzKcSncDoyBhoTjk6VhmkhsYLswu2SOMrdSHS8frPzLRy
         qlUH0MYNG15nNQvMSR04yRbTVSLAjwkpNTyXYqmEBoRgsXE0yRnlnlxBQ9HPjcu0xw
         eddsA9UPl8axiUhmzEwSFkmoSmakmnLg8qvkdguQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 11F0460364
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: Re: [PATCH 5/6] ath10k: migrate to mac80211 txq scheduling
References: <1540033534-11211-1-git-send-email-rmanohar@codeaurora.org>
        <1540033534-11211-6-git-send-email-rmanohar@codeaurora.org>
Date:   Wed, 24 Oct 2018 11:33:30 +0300
In-Reply-To: <1540033534-11211-6-git-send-email-rmanohar@codeaurora.org>
        (Rajkumar Manoharan's message of "Sat, 20 Oct 2018 04:05:33 -0700")
Message-ID: <87a7n3u4kl.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> ath10k maintains common txqs list for all stations. This txq
> management can be removed by migrating to mac80211 txq APIs
> and let mac80211 handle txqs reordering based on reported airtime.
> By doing this, txq fairness maintained in ath10k i.e processing
> N frames per txq is removed. By adapting to mac80211 APIs,
> ath10k will support mac80211 based airtime fairness algorithm.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
> Signed-off-by: Rajkumar Manoharan <rmanohar@codeaurora.org>

Is Toke the original author? Then you should add "From:" tag to mark
that. And you might want to use Co-developed-by to mark yourself as
co-developer.

--=20
Kalle Valo
