Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:48037 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952AbbG2Gda (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2015 02:33:30 -0400
From: Stephan Mueller <smueller@chronox.de>
To: Sandy Harris <sandyinchina@gmail.com>
Cc: Oleksij Rempel <linux@rempel-privat.de>,
	"Pan, Miaoqing" <miaoqing@qti.qualcomm.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, linux-crypto@vger.kernel.org,
	nhorman@tuxdriver.com
Subject: Re: [PATCH 2/2] ath9k: export HW random number generator
Date: Wed, 29 Jul 2015 08:33:24 +0200
Message-ID: <2021681.UA65q8VJfQ@tauon.atsec.com> (sfid-20150729_083334_328216_78A57DE7)
In-Reply-To: <CACXcFmnUcf66+X967JQL9mGrpa6ZYOqz99oK6JV8nFzABn=NZA@mail.gmail.com>
References: <1436946847-10909-1-git-send-email-miaoqing@qca.qualcomm.com> <3945775.m5HblJPgiO@tauon.atsec.com> <CACXcFmnUcf66+X967JQL9mGrpa6ZYOqz99oK6JV8nFzABn=NZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Dienstag, 28. Juli 2015, 13:41:57 schrieb Sandy Harris:

Hi Sandy,
>
>> However, the hwrandom framework does not provide any conditioning logic.
>
>At first sight, this sounds like a blunder to me, but I have not
>looked at hwrandom at all. Is there a rationale?

I think hwrandom is solely a framework to hook up RNG devices to user space. 
There is no massaging of data coming from the HW RNGs. Usually those HW RNGs 
all have their own conditioner and there is no need to do a conditioning 
again.
>
>For example, not building conditioning into that driver would make
>perfect sense if the output were just being fed into the random(4)
>which does plenty of mixing. The only problem then would be to make
>sure of giving random(4) reasonable entropy estimates.

hwrandom *may* be used to feed into the entropy pools. But there is no 
technical guarantee for that. Furthermore, I have seen use cases where the 
output of hwrandom is used for other purposes.

Ciao
Stephan
