Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f179.google.com ([209.85.222.179]:42723 "EHLO
	mail-pz0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab0CBIAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 03:00:08 -0500
Received: by pzk9 with SMTP id 9so2651647pzk.25
        for <linux-wireless@vger.kernel.org>; Tue, 02 Mar 2010 00:00:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <19340.51272.987517.174933@gargle.gargle.HOWL>
References: <19339.35506.86567.739868@gargle.gargle.HOWL> <43e72e891003011524m4d14bb2ai550f5e07e5a11aa4@mail.gmail.com>
	<19340.37231.983326.296054@gargle.gargle.HOWL> <43e72e891003012338q7da06ac0o7ff6ed6398626dcb@mail.gmail.com>
	<19340.51272.987517.174933@gargle.gargle.HOWL>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 1 Mar 2010 23:59:48 -0800
Message-ID: <43e72e891003012359jfb59df8t4c386a427b3c99a1@mail.gmail.com>
Subject: Re: [PATCH 4/7] ath9k: Remove common module
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 2, 2010 at 12:11 AM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> Luis R. Rodriguez wrote:
>> ChromeOs builds everything as built-in so in that case you will have
>> both eventually enabled.
>
> Right, in this case a small fix is needed.
> I'll send a patch to link in the library only once.

So you still don't like a common module approach? I guess I can wait
to see your patch.

>> Although it may be a few common helpers it could grow to share common
>> mac80211 helpers. After all, there are a few calls which could simply
>> be shared.
>
> I wanted to do this too, have a single mac80211 layer - but eventually,
> there were just too many differences between the callbacks.

Year I hear you, so there are two things I think we can do in the long
run to bring in mac80211 helpers together. The first one is to remove
the ath9k wiphy. The second is to use a threaded ISR and change our
bottom halves to use a workqueue instead of a tasklet so we can also
sleep during our work. I think these two things should enable us to
start sharing some callbacks. But ath9k virtual wiphy seems to provide
some functionality we don't yet have in mac80211/cfg80211 centrally
but we could work on that.

  Luis
