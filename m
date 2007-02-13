Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.229]:22914 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030571AbXBMATQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Feb 2007 19:19:16 -0500
Received: by nz-out-0506.google.com with SMTP id s1so1798910nze
        for <linux-wireless@vger.kernel.org>; Mon, 12 Feb 2007 16:19:15 -0800 (PST)
Message-ID: <1ba2fa240702121619x259f546dga2bebefbe24bf1d3@mail.gmail.com>
Date: Tue, 13 Feb 2007 02:19:15 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: d80211: current TKIP hwcrypto implementation seems to be broken
Cc: "Jouni Malinen" <jkm@devicescape.com>, "Jiri Benc" <jbenc@suse.cz>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200702130110.02658.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <200702041344.19117.mb@bu3sch.de> <200702130023.53271.mb@bu3sch.de>
	 <1ba2fa240702121554v4e5b55b3t4582241f6347b355@mail.gmail.com>
	 <200702130110.02658.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/13/07, Michael Buesch <mb@bu3sch.de> wrote:
> On Tuesday 13 February 2007 00:54, Tomas Winkler wrote:
> > On 2/13/07, Michael Buesch <mb@bu3sch.de> wrote:
> > > On Tuesday 13 February 2007 00:15, Tomas Winkler wrote:
> > > > I fetching this from my "dusty" memory so I hope I'm right about it.
> > > > TKIP phase1 one can be precomputed in advance. There's no runtime
> > >
> > > Phase1 key changes on iv32 wrap.
> >
> > That's correct, this depends on packet sequence counter,  but you can
> > compute next TKIP phase1 even before iv32 wrap has occurred. You can
> > compute 100 of them in advance.
>
> Actually it should be "iv32 changes" instead of "iv32 wraps". Typo.
> But my point still remains. I see no point in precomputing it.
>
> > > > dependency after key exchange.
> > > > Cached keys can be provided by supplicant. Usually u want to keep 2 or
> > > > 3 cached TKIP phase1 for smooth decryption. As in QoS sequence
> > >
> > > Hardware (bcm43xx at least) can only have one key at a time.
> > > There's no point in caching, as phase1 key calculation is cheap
> > > and can be done on-the-run. The expensive part it uploading it to HW.
> >
> > True, but when there is a packet from past with tkip phase1 that
> > doesn't match currently configured phase1 tkip you might be able to
> > decrypt it, of course f hardware doesn't scramble it with wrong key.
>
> HW doesn't scramble it. So when d80211 receives the packet it can
> _then_ generate the key. There's no point in precomputing it.

For past packets you've already computed it so why do  it again? So
you keep 2 phas1 keys one old and one current. When sequence numbers
advance sufficiently you discard the old one and compute the new one
in a spare time. Something like double buffer.

> > > > counters are kept per AC, you might get into gentle state of receiving
> > > > packets for the old key. If  you hold more then one  phase1 you might
> > > > be able decrypt the packets that doesn't match current phase1 in
> > > > software.
> > >
> > > You can generate the new key then. There is no point in wasting memory
> > > by precomputation of the keys.
> >
> > These few bytes doesn't hurt you even if you're running on a cell phone.
>
> But they don't gain you anything too, IMO.
> So better not waste the memory and not have the extra complexity in code.
>
I didn't measured performance but I thought  it can be precomputed by
the supplicant rather then by kernel code.    I might be wrong.
> --
> Greetings Michael.
>
