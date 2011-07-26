Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:54303 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306Ab1GZSVl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 14:21:41 -0400
Received: by yia27 with SMTP id 27so453516yia.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jul 2011 11:21:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <COL114-W76260EA23039CA8000DB88A320@phx.gbl>
References: <COL114-W9CEFD4E7F3803005186F98A4F0@phx.gbl> <CAB=NE6WoKhvR7AVcwaGkijkph+UAts9h-=L4oPwhE=b6gW8eDg@mail.gmail.com>
 <CAB=NE6X=ykO6fX1+vrYyjHt0V1z8hN7HY3p7cEaeXw13z2aKnA@mail.gmail.com>
 <201107260213.16509.chunkeey@googlemail.com> <CAB=NE6UYwvDZm49vaXZGQy93Ga2jO8-e5wb1YbojxPATmiK0hw@mail.gmail.com>
 <COL114-W76260EA23039CA8000DB88A320@phx.gbl>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 26 Jul 2011 11:21:21 -0700
Message-ID: <CAB=NE6Wcn3-GwqPJQDXOT0JCNnZgCs1E7HecWrXpc8LS+XRyDA@mail.gmail.com> (sfid-20110726_202145_712388_83773024)
Subject: Re: problem on ACS
To: MingAnn Ng <devil_eddie01@hotmail.com>
Cc: chunkeey@googlemail.com,
	wireless testing <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 25, 2011 at 7:46 PM, MingAnn Ng <devil_eddie01@hotmail.com> wrote:
> Hi Luis,
>
> this is what I'd got after applying logarithm identities patch that you
> provide:
>
> 2412 MHz: -175.357726
> 2417 MHz: -inf
> 2422 MHz: -inf
> 2427 MHz: -inf
> 2432 MHz: -inf
> 2437 MHz: -inf
> 2442 MHz: -inf
> 2447 MHz: -inf
> 2452 MHz: -inf
> 2457 MHz: -inf
> 2462 MHz: -inf
> 2467 MHz: -inf
> 2472 MHz: -inf
> 5180 MHz: -187.707255
> 5200 MHz: -186.721397
> 5220 MHz: -186.067982
> 5240 MHz: -186.584516
> 5260 MHz: -186.872511
> 5280 MHz: -184.567340
> 5300 MHz: -185.224387
> 5320 MHz: -185.794143
> 5500 MHz: -189.525424
> 5520 MHz: -189.417120
> 5540 MHz: -189.705191
> 5560 MHz: -189.639734
> 5580 MHz: -190.396324
> 5600 MHz: -189.503429
> 5620 MHz: -189.685961
> 5640 MHz: -189.421184
> 5660 MHz: -189.814113
> 5680 MHz: -190.737770
> 5700 MHz: -190.546318
> Ideal freq: 2417 MHz

Hm, as for the new values -- they look very different from what you
had gotten before so the math went wrong somewhere.. gotta revise that
a bit more carefully.

> The result is almost the same as the version before applying the patch. the
> -inf still fall on those channel. and those channel are indeed very busy in
> my lab. Is there any other solution which I can try to get a better result
> out of it?
>
> I haven't try on the latest patch for hostapd which you uploaded. Is the acs
> application work along with hostapd to calculate the interference level?

No, the ACS implementation on hostapd simply uses the internal code
from hostapd so its much easier to write, the acs.git code is
completely independent so adding anything there is just a bit harder,
for example adding a scan prior to the ACS work. Please do try the
hostapd patches to see if you get a good channel, and enable debugging
to see the values you get. We do want to avoid the -inf stuff
completely. Getting that means our data type is not sufficient for our
data. The difficult aspect of this code is that the values range from
fractional values to extremely large values..

  Luis
