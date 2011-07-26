Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37408 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab1GZSbY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 14:31:24 -0400
Received: by ewy4 with SMTP id 4so654188ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jul 2011 11:31:23 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: problem on ACS
Date: Tue, 26 Jul 2011 20:31:10 +0200
Cc: MingAnn Ng <devil_eddie01@hotmail.com>,
	wireless testing <linux-wireless@vger.kernel.org>
References: <COL114-W9CEFD4E7F3803005186F98A4F0@phx.gbl> <COL114-W76260EA23039CA8000DB88A320@phx.gbl> <CAB=NE6Wcn3-GwqPJQDXOT0JCNnZgCs1E7HecWrXpc8LS+XRyDA@mail.gmail.com>
In-Reply-To: <CAB=NE6Wcn3-GwqPJQDXOT0JCNnZgCs1E7HecWrXpc8LS+XRyDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201107262031.11394.chunkeey@googlemail.com> (sfid-20110726_203128_120868_579FF71B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, July 26, 2011 08:21:21 PM Luis R. Rodriguez wrote:
> On Mon, Jul 25, 2011 at 7:46 PM, MingAnn Ng <devil_eddie01@hotmail.com> wrote:
> > Hi Luis,
> >
> > this is what I'd got after applying logarithm identities patch that you
> > provide:
> >
> > 2412 MHz: -175.357726
> > 2417 MHz: -inf
> > 2422 MHz: -inf
> > 2427 MHz: -inf
> > 2432 MHz: -inf
> > 2437 MHz: -inf
> > 2442 MHz: -inf
> > 2447 MHz: -inf
> > 2452 MHz: -inf
> > 2457 MHz: -inf
> > 2462 MHz: -inf
> > 2467 MHz: -inf
> > 2472 MHz: -inf
> > 5180 MHz: -187.707255
> > 5200 MHz: -186.721397
> > 5220 MHz: -186.067982
> > 5240 MHz: -186.584516
> > 5260 MHz: -186.872511
> > 5280 MHz: -184.567340
> > 5300 MHz: -185.224387
> > 5320 MHz: -185.794143
> > 5500 MHz: -189.525424
> > 5520 MHz: -189.417120
> > 5540 MHz: -189.705191
> > 5560 MHz: -189.639734
> > 5580 MHz: -190.396324
> > 5600 MHz: -189.503429
> > 5620 MHz: -189.685961
> > 5640 MHz: -189.421184
> > 5660 MHz: -189.814113
> > 5680 MHz: -190.737770
> > 5700 MHz: -190.546318
> > Ideal freq: 2417 MHz
> 
> Hm, as for the new values -- they look very different from what you
> had gotten before so the math went wrong somewhere.. gotta revise that
> a bit more carefully.

well, take a close look at the patch.

> -       factor *= (base_to_power(2, survey->noise - min_noise));
> +		 factor += survey->noise + min_noise;

In the original version, you substracted the min band noise from the
channel. Whereas now you add them together.
 
> > The result is almost the same as the version before applying the patch. the
> > -inf still fall on those channel. and those channel are indeed very busy in
> > my lab. Is there any other solution which I can try to get a better result
> > out of it?
> >
> > I haven't try on the latest patch for hostapd which you uploaded. Is the acs
> > application work along with hostapd to calculate the interference level?
> 
> No, the ACS implementation on hostapd simply uses the internal code
> from hostapd so its much easier to write, the acs.git code is
> completely independent so adding anything there is just a bit harder,
> for example adding a scan prior to the ACS work. Please do try the
> hostapd patches to see if you get a good channel, and enable debugging
> to see the values you get. We do want to avoid the -inf stuff
> completely. Getting that means our data type is not sufficient for our
> data. The difficult aspect of this code is that the values range from
> fractional values to extremely large values..
well, if you do a [active] scan. channel_time_tx + channel_time_busy will
definetly not be "zero". Maybe we can get away by adding some threshold
cuts-offs. At least this would fix the -inf.

+       factor = log2(max(1, survey->channel_time_busy - survey->channel_time_tx));
+       factor -= log2(max(1, survey->channel_time - survey->channel_time_tx));

[However, we could also ignore channel surveys with result in a -inf]

Regards,
	Chr
