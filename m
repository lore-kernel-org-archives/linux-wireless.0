Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:35168 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab0CBIWA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 03:22:00 -0500
Received: by pwj8 with SMTP id 8so2254552pwj.19
        for <linux-wireless@vger.kernel.org>; Tue, 02 Mar 2010 00:21:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <19340.52259.880731.243673@gargle.gargle.HOWL>
References: <19339.35506.86567.739868@gargle.gargle.HOWL> <43e72e891003011524m4d14bb2ai550f5e07e5a11aa4@mail.gmail.com>
	<19340.37231.983326.296054@gargle.gargle.HOWL> <43e72e891003012338q7da06ac0o7ff6ed6398626dcb@mail.gmail.com>
	<19340.51272.987517.174933@gargle.gargle.HOWL> <43e72e891003012359jfb59df8t4c386a427b3c99a1@mail.gmail.com>
	<19340.52259.880731.243673@gargle.gargle.HOWL>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 2 Mar 2010 00:21:39 -0800
Message-ID: <43e72e891003020021l49191ceaye56c204e74a3c004@mail.gmail.com>
Subject: Re: [PATCH 4/7] ath9k: Remove common module
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 2, 2010 at 12:28 AM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> Luis R. Rodriguez wrote:
>> So you still don't like a common module approach? I guess I can wait
>> to see your patch.
>
> I don't know, Luis.
> It seems a bit cleaner to me, just ath.ko, ath9k_hw.ko and ath9k.ko

Well I agree, if some common code exists though it should just go into
a module, and if its real small to some inline helpers but from the
looks of it that is not the case.

> But I don't really care, anyway - maybe we can just dump this series and
> use ath9k_common.ko as such.
>
> I'll send patches removing lib.c from ath9k_htc.

Well so my goal with ath9k_common was to use it as a place holder was
we don't have common mac80211 helpers between both ath9k and ath9k_htc
but with an end goal that we try to merge as much as is possible. I
only got to completing basic legacy RX support on ath9k_htc so did
only get that far to see the extend to what things can be shared as
far as mac80211 callbacks are concerned.

>> Year I hear you, so there are two things I think we can do in the long
>> run to bring in mac80211 helpers together. The first one is to remove
>> the ath9k wiphy. The second is to use a threaded ISR and change our
>> bottom halves to use a workqueue instead of a tasklet so we can also
>> sleep during our work. I think these two things should enable us to
>> start sharing some callbacks. But ath9k virtual wiphy seems to provide
>> some functionality we don't yet have in mac80211/cfg80211 centrally
>> but we could work on that.
>
> My vote is to keep the drivers separate.

You would be more familiar with the commonality between ath9k and
ath9k_htc at this point. Even though the two drivers are separate
right now, say we did remove the ath9k virtual wiphy, is there a set
of mac80211 callbacks we can start sharing?

My motivation for sharing more callbacks comes from the eventual goal
to support multiple virtual interfaces on the same radio each on a
separate channel. The complexity of the drivers increase so it seems
there is value in trying to reach more common ground.

  Luis
