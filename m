Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:54323 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754894AbZCXMwT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 08:52:19 -0400
Received: by fg-out-1718.google.com with SMTP id e12so668101fga.17
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2009 05:52:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200903241205.06417.helmut.schaa@gmail.com>
References: <20090320215705.GE8120@tesla>
	 <200903241115.29868.helmut.schaa@gmail.com>
	 <200903241136.03991.hs4233@mail.mn-solutions.de>
	 <200903241205.06417.helmut.schaa@gmail.com>
Date: Tue, 24 Mar 2009 13:52:15 +0100
Message-ID: <32d5c55a0903240552p69856b4v99f2d7f9e5ad08eb@mail.gmail.com> (sfid-20090324_135222_561141_DA2CA50F)
Subject: Re: Google Summer of Code 2009 -- Linux wireless roaming project
From: Mats Karlsson <mats.o.karlsson@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Im not a developer but I have a degree in automation and I think that
some of that knowledge could be used here.

I would propose that PID is considered as the formula for deciding
when to switch from one AP to another.

This formula is widely used in automation processes and an quite good
explanation can be found here
http://en.wikipedia.org/wiki/PID_controller


Regards
Mats

On Tue, Mar 24, 2009 at 12:05 PM, Helmut Schaa
<helmut.schaa@googlemail.com> wrote:
> Am Dienstag, 24. M=E4rz 2009 schrieb Holger Schurig:
>> > Hmm, quick example: AP1 - STA - AP2
>> >
>> > We cannot consider the signal strength as constant as it
>> > varies over time even when neither the STA nor the AP are
>> > moving. Assume a threshold value of t=3D40. Furthermore, the
>> > signal strength of AP1 and AP2 might alter between 35-50 which
>> > means we have an average signal strength of 42,5 > t.
>> > Nevertheless that would result in ping-pongs between AP1 and
>> > AP2 because the signal might drop below t on both APs, while
>> > it would be better to stick to one AP as the signal is already
>> > quite bad (but still good enough to do some communication).
>>
>> Yeah, but if the client is moving, you have to live with that,
>> more or less.
>>
>> And if the client is not moving (and roaming is a loadable kernel
>> module), then simply don't load it :-)
>
> Ah, ok. I was more referring to an ordinary laptop user who sits at h=
is
> desk and once in a while starts moving (for example to a conference r=
oom).
> While he sits at his desk the optimal solution shouldn't trigger a sc=
an as
> the chance that a better AP pops up is relatively low. Once he starts
> moving scanning is desired.
>
>> My ad-hoc approach that I already implemented (for non-mac80211)
>> shows a quite number of scannings. But that is ok for my
>> use-case (e.g. telnet connection via WLAN). "Connection lost" is
>> way worse than one scanning/reassociation too much, especially
>> if the scanning/association is done intelligently.
>>
>> So for now I wouldn't optimize here, but make non-sucking roaming
>> possible in the first place. We can build upon this anyway.
>
> Fine with me. But too aggressive scanning might lead to unstable or
> intermittent connections, especially when WPA-EAP without PMKSA-cachi=
ng
> is used where roaming from one AP to another can take up to several
> seconds ;)
>
> And additionally if the connection is idle, repeated scanning will
> increase the power consumption which is not desired on battery driven
> devices.
>
> Helmut
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wirel=
ess" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
