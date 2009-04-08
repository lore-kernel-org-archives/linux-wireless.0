Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:38687 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936AbZDHXhA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Apr 2009 19:37:00 -0400
Received: by fg-out-1718.google.com with SMTP id 16so619131fgg.17
        for <linux-wireless@vger.kernel.org>; Wed, 08 Apr 2009 16:36:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49DCE741.7080406@lwfinger.net>
References: <200904081530.51962.eugene.sobol@promwad.com>
	 <49DCE741.7080406@lwfinger.net>
Date: Thu, 9 Apr 2009 00:36:58 +0100
Message-ID: <3ace41890904081636g76f0057cv9a9b5a788489d9a3@mail.gmail.com> (sfid-20090409_013703_856510_358FFEF2)
Subject: Re: rtl8187 diversity
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	"eugene.sobol" <eugene.sobol@promwad.com>
Cc: linux-wireless@vger.kernel.org, ivan.kuten@promwad.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First of all, thanks a lot for posting the patch.

The use of compat-wireless-old is presumably for older kernel
side-by-side comparison on an older kernel?
In any case, starting from somewhere is better than not-starting :-).

>> However while testing, the switching between antennas doesn't give any
>> download speed improvements.
>> May be we missed some point.

You are confusing throughput with signal quality - unless the
improvement with signal quality is dramatic enough to affect the
rate-controlling mechanism (to bump the driver up to a higher rate),
it probably will just result in more "steady" download (i.e. with less
fluctuations), and you probably need to be moving around a bit to
notice this.

> I don't like the idea of having the antenna diversity as a compile-time option.
> That works OK for a single user, but it fails when distros are considered. They
> would have to have it on for all cases even though very few users would need it.
> Does the EEPROM for your device have special encoding that indicates the
> presence of multiple antennas? You should be able to compile the antenna
> diversity code unconditionally and use such a special EEPROM value.
> Alternatively, the USB ID's (13d1:abe6) could be used to select its execution.

I agree this should not be a compile-time option; it should either
auto-detect -

- is based on USB vid/pid's reliable? enumeration of the number of antennas
(presumably there is a way of asking the device itself how many
antennas it is attached to)
and the code simply cycles/alternates between all antennas; this might
actually punnish the
majority of the single-antenna users -

or a run-time configurable option, i.e. via iwconfig/iwpriv/iw . It
might be as simple as
making the antenna switching no-op in the case of single antenna; but
whatever needs to be done between single and multiple antennas should
be require a module recompile.

On the patch itself - I suggest to separate the procfs related stuff
as a separate patch, or even removing it(?) it is probably only useful
for devel? and hard coding "#define VAL_ARRAY_SIZE 10"?
