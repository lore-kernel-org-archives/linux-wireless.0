Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:23372 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753470Ab0CBIJP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 03:09:15 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 02 Mar 2010 00:09:15 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19340.52259.880731.243673@gargle.gargle.HOWL>
Date: Tue, 2 Mar 2010 13:58:19 +0530
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/7] ath9k: Remove common module
In-Reply-To: <43e72e891003012359jfb59df8t4c386a427b3c99a1@mail.gmail.com>
References: <19339.35506.86567.739868@gargle.gargle.HOWL>
	<43e72e891003011524m4d14bb2ai550f5e07e5a11aa4@mail.gmail.com>
	<19340.37231.983326.296054@gargle.gargle.HOWL>
	<43e72e891003012338q7da06ac0o7ff6ed6398626dcb@mail.gmail.com>
	<19340.51272.987517.174933@gargle.gargle.HOWL>
	<43e72e891003012359jfb59df8t4c386a427b3c99a1@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> So you still don't like a common module approach? I guess I can wait
> to see your patch.

I don't know, Luis.
It seems a bit cleaner to me, just ath.ko, ath9k_hw.ko and ath9k.ko

But I don't really care, anyway - maybe we can just dump this series and
use ath9k_common.ko as such.

I'll send patches removing lib.c from ath9k_htc.

> Year I hear you, so there are two things I think we can do in the long
> run to bring in mac80211 helpers together. The first one is to remove
> the ath9k wiphy. The second is to use a threaded ISR and change our
> bottom halves to use a workqueue instead of a tasklet so we can also
> sleep during our work. I think these two things should enable us to
> start sharing some callbacks. But ath9k virtual wiphy seems to provide
> some functionality we don't yet have in mac80211/cfg80211 centrally
> but we could work on that.

My vote is to keep the drivers separate.

Sujith
