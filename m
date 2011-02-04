Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:52287 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab1BDLHZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Feb 2011 06:07:25 -0500
Received: by pxi15 with SMTP id 15so384870pxi.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 Feb 2011 03:07:24 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19787.56808.340852.289586@gargle.gargle.HOWL>
Date: Fri, 4 Feb 2011 16:37:20 +0530
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] ath9k: Drain txq before sending a nullfunc frame.
In-Reply-To: <AANLkTimfONC20SyM=OA9Fykkt91ZsU19XEBiC7uDnVY8@mail.gmail.com>
References: <1296800640-6381-1-git-send-email-vnatarajan@atheros.com>
	<19787.47298.50879.401166@gargle.gargle.HOWL>
	<AANLkTim_7Xup048eGxz2HWj0AqRS_+jvC1LqgCdU9ZOh@mail.gmail.com>
	<19787.54182.293274.705139@gargle.gargle.HOWL>
	<AANLkTimfONC20SyM=OA9Fykkt91ZsU19XEBiC7uDnVY8@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan wrote:
> This is true for retry_tx set as false(for ath_draintxq) but if the
> retry is set, I suppose the frame will be in the hw queue till all the
> hw retries(20) and sw retries(10) (200 retries in total)are over. This
> will take a lot of time for completion if the channel is busy.

Time for completion ? We are _draining_ the pending frames, they are never
sent out ...

> I am thinking of calling ath_drain_all_txq() in flush() and the only
> query is should the retry_tx be set.

Not sure.

Sujith
