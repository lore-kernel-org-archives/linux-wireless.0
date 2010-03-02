Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33782 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab0CBHi0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 02:38:26 -0500
Received: by pva4 with SMTP id 4so796206pva.19
        for <linux-wireless@vger.kernel.org>; Mon, 01 Mar 2010 23:38:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <19340.37231.983326.296054@gargle.gargle.HOWL>
References: <19339.35506.86567.739868@gargle.gargle.HOWL> <43e72e891003011524m4d14bb2ai550f5e07e5a11aa4@mail.gmail.com>
	<19340.37231.983326.296054@gargle.gargle.HOWL>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 1 Mar 2010 23:38:06 -0800
Message-ID: <43e72e891003012338q7da06ac0o7ff6ed6398626dcb@mail.gmail.com>
Subject: Re: [PATCH 4/7] ath9k: Remove common module
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 1, 2010 at 8:17 PM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> Luis R. Rodriguez wrote:
>> Interesting approach, instead of having two modules you linked lib.o
>> twice to two separate modules, ath9k.ko and ath9k_htc.ko. While this
>> does reduce module proliferation is there any advantage to that over
>> the approach of stuffing these into one common module shared between
>> both?
>>
>> The benefit of doing it as a module is if both are built-in you reduce
>> the final kernel size. On my box with debugging this is 256 KB.
>
> The built-in case would be mostly useful in embedded systems (SoC etc ..).
> And it is likely to be either ath9k or ath9k_htc. I don't think that
> both family of chipsets can exist simultaneously.

ChromeOs builds everything as built-in so in that case you will have
both eventually enabled.

> And since the code that is shared is very minimal (a few general routines and crypto),
> it felt reasonable to just stuff into a common library.

Although it may be a few common helpers it could grow to share common
mac80211 helpers. After all, there are a few calls which could simply
be shared.

  Luis
