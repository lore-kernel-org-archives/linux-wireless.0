Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:20578 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495Ab0CBD6r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Mar 2010 22:58:47 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 01 Mar 2010 19:58:47 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19340.37231.983326.296054@gargle.gargle.HOWL>
Date: Tue, 2 Mar 2010 09:47:51 +0530
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 4/7] ath9k: Remove common module
In-Reply-To: <43e72e891003011524m4d14bb2ai550f5e07e5a11aa4@mail.gmail.com>
References: <19339.35506.86567.739868@gargle.gargle.HOWL>
	<43e72e891003011524m4d14bb2ai550f5e07e5a11aa4@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> Interesting approach, instead of having two modules you linked lib.o
> twice to two separate modules, ath9k.ko and ath9k_htc.ko. While this
> does reduce module proliferation is there any advantage to that over
> the approach of stuffing these into one common module shared between
> both?
> 
> The benefit of doing it as a module is if both are built-in you reduce
> the final kernel size. On my box with debugging this is 256 KB.

The built-in case would be mostly useful in embedded systems (SoC etc ..).
And it is likely to be either ath9k or ath9k_htc. I don't think that
both family of chipsets can exist simultaneously.

And since the code that is shared is very minimal (a few general routines and crypto),
it felt reasonable to just stuff into a common library.

Sujith
