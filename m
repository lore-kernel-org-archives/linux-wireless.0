Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49951 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802Ab1FBWgW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jun 2011 18:36:22 -0400
Received: by iyb14 with SMTP id 14so983613iyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Jun 2011 15:36:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=fT-Hdio9ArZKFMZCPX0LGLjGB=A@mail.gmail.com>
References: <BANLkTi=-MDn9eAsRsoXtAetDOZehkMEhJw@mail.gmail.com>
 <201105241627.49201.helmut.schaa@googlemail.com> <BANLkTikcEsKYo=c=ZmzJRbmfgjmrFmx9bg@mail.gmail.com>
 <BANLkTin4MvdbqugTjtXvmjz5N8_TyTY7OA@mail.gmail.com> <BANLkTi=xfv_0C1mVAtO=w5JqyXLvh=vtAQ@mail.gmail.com>
 <BANLkTimMXbZE=vY95C0b2H3hx=4XWdU2Qg@mail.gmail.com> <BANLkTi=rS_kDhB8oKBLsz2Mk2nvRJMu5mg@mail.gmail.com>
 <4DDD5691.2040205@openwrt.org> <BANLkTi=1uj52P208p--5NU=Ow4rDndMkAw@mail.gmail.com>
 <BANLkTimRiU9Pv1B1=VC3XuREbmnpLk3S7w@mail.gmail.com> <4DDE2F5B.3020804@openwrt.org>
 <BANLkTimuaOoV0uvyzs9PbeK_k6vwOG=+YA@mail.gmail.com> <4DDEEEEC.6010800@openwrt.org>
 <BANLkTi=fT-Hdio9ArZKFMZCPX0LGLjGB=A@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 2 Jun 2011 15:36:02 -0700
Message-ID: <BANLkTikhihyTqg+yR8MnR1cp5wJ35sybNA@mail.gmail.com> (sfid-20110603_003626_258482_EEFB3FE1)
Subject: Re: Initial automatic channel selection implementation
To: Felix Fietkau <nbd@openwrt.org>,
	Matt Smith <smithm@qca.qualcomm.com>,
	Sundar Sankaran <sunsanka@qca.qualcomm.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	hostap@lists.shmoo.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 26, 2011 at 5:59 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
>  What I'd like to do is to affect the ratio to nullify it if the noise
>  is very low on the channel. Given that noise is logarithmic we'd have
>  to use a logarithmic function as well. Working on that now.

OK I've figured a way to plug the noise into this, I designed the
following function we can use as a factor:

1.1^(x+110)

Wolfram|Alpha boring details of this function:

http://bit.ly/mJNXE9

x,y results of different noise values in dBm, using apcalc:

mcgrof@tux ~ $ calc
C-style arbitrary precision calculator (version 2.12.3.3)
Calc is open software. For license details type:  help copyright
[Type "exit" to exit, or "help" for help.]

; define f(x) = 1.1^(x+110)
f(x) defined

; f(-130)
	~0.14864362802414368640
; f(-120)
	~0.38554328942953174736
; f(-119)
	~0.42409761837248492210
; f(-118)
	~0.46650738020973341431
; f(-117)
	~0.51315811823070675574
; f(-116)
	~0.56447393005377743132
; f(-115)
	~0.62092132305915517445
; f(-114)
	~0.68301345536507069189
; f(-113)
	~0.75131480090157776108
; f(-112)
	~0.82644628099173553719
; f(-111)
	~0.90909090909090909091
; f(-110)
	1
; f(-109)
	1.1
; f(-108)
	1.21
; f(-107)
	1.331

So then, we'd use a frequency for initiating beaconing (AP, Mesh, P2P)
which uses the lowest value from the following computation:

(busy time - tx time) / (active time - tx time) * 1.1^(noise + 110)

The 1.1 factor can be modified more accurately to represent the
exponential factor of how noise should affect interference decisions,
the 110 value here can be modified for any other arbitrary value we
find as representative of a regular noise value from a simple AP on
the frequency we are observing, my assumption here was -110 dBm.

If I don't hear yells I'll implement this algorithm, but first I want
to add APIs to let us query for survey data for specific frequencies,
the current stuff assumes the dump data will be useful within the time
period we get it, but the way I'm thinking of doing it is to do each
frequency analysis atomically -- change channel / do offchannel
operation on a frequency, and then get the survey data for that
frequency and compute the above. Then choose the frequency with the
lowest value. This would allow us to do work without regards to any
possible stale data. We could also later add a history of these values
and compute an average and keep picking the best one. Anyway, that's
that. Let me know what you think.

  Luis
