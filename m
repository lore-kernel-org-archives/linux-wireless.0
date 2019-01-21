Return-Path: <SRS0=xI28=P5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 658B0C282DB
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 09:49:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 332612085A
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 09:49:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="LI1xPvFF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbfAUJtj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Jan 2019 04:49:39 -0500
Received: from mail.toke.dk ([52.28.52.200]:47967 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726133AbfAUJtj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Jan 2019 04:49:39 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1548064176; bh=D78vt3K1LU07/WD0SrmIuhX8OnAXHpmGIc3IQoAxtIg=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=LI1xPvFFc8Lv3idYE5V90veRwsw6Qu6flKayMzJrI0cgjy2tr4I38udJg2HeJnVHH
         opG7nC2+q3p4UfoA/ou9XlkVDVInCyblQgFgQ8el2Nk1Y7xfHaKpbAoUIGYNT8ihmn
         6XfIGWNdFIyuKL4IRScvMz2hnQ9+MV6zRigZuZ7QbQoywoXc5l56FgTseEPw91dON7
         EbqIlCmJWgO54dyNU9ZTpD99tN46hwL0crWctKOcdySCtvDBoAx8vQ6qQUKKQOmLrB
         JZcoNiQAyju8VTqf06+TiqPz2jhBKO1F9q+h7aLnjB6wuTnHzCQM8QjxbMNu20DRc3
         FF7vlj2PhqFjg==
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc:     make-wifi-fast@lists.bufferbloat.net, Kan Yan <kyan@google.com>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>
Subject: Re: [PATCH v4 6/6] ath10k: reporting estimated tx airtime for fairness
In-Reply-To: <1545172374-1072-7-git-send-email-rmanohar@codeaurora.org>
References: <1545172374-1072-1-git-send-email-rmanohar@codeaurora.org> <1545172374-1072-7-git-send-email-rmanohar@codeaurora.org>
Date:   Mon, 21 Jan 2019 10:49:35 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <8736pmmjbk.fsf@toke.dk>
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

FYI, it seems that this last patch in the series no longer applies
cleanly on top of mac80211-next. May need a refresh.

The mac80211 parts were merged into mac80211-next (thanks, Johannes!); I
guess the driver updates are waiting for drivers-next to catch up to
that?

Patches 4 and 5 in the series are fine...

-Toke
