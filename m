Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38E9AEB64D8
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Jun 2023 12:05:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232654AbjFTMFg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 20 Jun 2023 08:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230451AbjFTMF3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Jun 2023 08:05:29 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596BB1709
        for <linux-wireless@vger.kernel.org>; Tue, 20 Jun 2023 05:05:26 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1687262723; bh=7b2cfT4q4kUSUpHOVSXR2A8k+9G4TngwBe2H5LXpB0w=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=PLQ4NS5EdnNExMH7NbfFqheRYeAdEc+sLBuT3E7EK7ztPW7ubILitPNco5c+9GHav
         lTvsH66wl4lkZayDd+Id/SIy9ojrtMHF9B5qZgpT0zb/JktPR09VJ5iHNI+l8wsaxd
         010+0PSt5VMLH+q6w2s9WH80gUXE/eX9qJQDTJ5bZGwhp4sYUSJpuMwSB0bZpUJgub
         iz/HhQDM6ZqXyUnHboSJFrLE+psTuqqhPkPCr0zcC2Y70yaJMvkYWXYag3WwkUdAyn
         FteCqb0PAwQlOcdhM5pbR1dgnIlOF8g8H+909XcfqCyszbTuuEZvFbb4n05T+SkCFx
         dxlovadKiqezQ==
To:     Dmitry Antipov <dmantipov@yandex.ru>
Cc:     Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org,
        Dmitry Antipov <dmantipov@yandex.ru>
Subject: Re: [PATCH 1/2] [v2] wifi: ath9k: avoid using uninitialized array
In-Reply-To: <20230620080855.396851-1-dmantipov@yandex.ru>
References: <20230620080855.396851-1-dmantipov@yandex.ru>
Date:   Tue, 20 Jun 2023 14:05:22 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87a5wue3ul.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dmitry Antipov <dmantipov@yandex.ru> writes:

> In 'ath_tx_count_frames()', 'ba' array may be used uninitialized, so
> add 'memset()' call similar to one used in 'ath_tx_complete_aggr()'.
>
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
