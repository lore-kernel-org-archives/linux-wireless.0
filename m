Return-Path: <SRS0=qpxp=O4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13267C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 13:24:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D18B420989
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 13:24:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WCNJR/e6";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WCNJR/e6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728707AbeLSNYm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Dec 2018 08:24:42 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:60650 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728638AbeLSNYm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Dec 2018 08:24:42 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DE30C61AF9; Wed, 19 Dec 2018 13:24:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545225881;
        bh=yiIN4fur8lbH+uHQqh2udCBdjKxcORWwHVEUYTrKIpI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=WCNJR/e6EGHAZoGk4e6/KcLgLx4GmCs+MLDwJhHy/0ln62/D5VX3LMNVl7y9wGjOc
         qp0dbJy4BJKY6/AVdV3F97yotYzx6R8dbcuyQiuK5vxAagVgMicfsc5fDvMQ8V7qxQ
         I5d89yVZBhxCN8+rR2QWciwopp6OVWwq8TiPmbOQ=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CC7CA61AF9;
        Wed, 19 Dec 2018 13:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545225881;
        bh=yiIN4fur8lbH+uHQqh2udCBdjKxcORWwHVEUYTrKIpI=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=WCNJR/e6EGHAZoGk4e6/KcLgLx4GmCs+MLDwJhHy/0ln62/D5VX3LMNVl7y9wGjOc
         qp0dbJy4BJKY6/AVdV3F97yotYzx6R8dbcuyQiuK5vxAagVgMicfsc5fDvMQ8V7qxQ
         I5d89yVZBhxCN8+rR2QWciwopp6OVWwq8TiPmbOQ=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org CC7CA61AF9
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        make-wifi-fast@lists.bufferbloat.net,
        Toke =?utf-8?Q?H=C3=B8iland-J?= =?utf-8?Q?=C3=B8rgensen?= 
        <toke@toke.dk>
Subject: Re: [PATCH v5 5/6] ath10k: migrate to mac80211 txq scheduling
References: <1545181331-5288-1-git-send-email-rmanohar@codeaurora.org>
        <1545181331-5288-6-git-send-email-rmanohar@codeaurora.org>
Date:   Wed, 19 Dec 2018 15:24:37 +0200
In-Reply-To: <1545181331-5288-6-git-send-email-rmanohar@codeaurora.org>
        (Rajkumar Manoharan's message of "Tue, 18 Dec 2018 17:02:10 -0800")
Message-ID: <87o99hvecq.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
>
> ath10k maintains common txqs list for all stations. This txq
> management can be removed by migrating to mac80211 txq APIs
> and let mac80211 handle txqs reordering based on reported airtime.
> By doing this, txq fairness maintained in ath10k i.e processing
> N frames per txq is removed. By adapting to mac80211 APIs,
> ath10k will support mac80211 based airtime fairness algorithm.
>
> Tested-by: Venkateswara Naralasetty <vnaralas@codeaurora.org>
> Co-developed-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
> Signed-off-by: Rajkumar Manoharan <rmanohar@codeaurora.org>

Please always add hardware and firmware versions used for testing. But I
can add that, so no need to resend because of this. Just let me know
what to add.

--=20
Kalle Valo
