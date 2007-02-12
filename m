Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.231]:60364 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030469AbXBLXPZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Feb 2007 18:15:25 -0500
Received: by nz-out-0506.google.com with SMTP id s1so1784363nze
        for <linux-wireless@vger.kernel.org>; Mon, 12 Feb 2007 15:15:25 -0800 (PST)
Message-ID: <1ba2fa240702121515p7edd3682j87070b564cb08897@mail.gmail.com>
Date: Tue, 13 Feb 2007 01:15:25 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: d80211: current TKIP hwcrypto implementation seems to be broken
Cc: "Jouni Malinen" <jkm@devicescape.com>, "Jiri Benc" <jbenc@suse.cz>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200702122239.31778.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <200702041344.19117.mb@bu3sch.de>
	 <20070212183020.GA16597@instant802.com>
	 <200702122239.31778.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I fetching this from my "dusty" memory so I hope I'm right about it.
TKIP phase1 one can be precomputed in advance. There's no runtime
dependency after key exchange.
Cached keys can be provided by supplicant. Usually u want to keep 2 or
3 cached TKIP phase1 for smooth decryption. As in QoS sequence
counters are kept per AC, you might get into gentle state of receiving
packets for the old key. If  you hold more then one  phase1 you might
be able decrypt the packets that doesn't match current phase1 in
software.


On 2/12/07, Michael Buesch <mb@bu3sch.de> wrote:
> On Monday 12 February 2007 19:30, Jouni Malinen wrote:
> > On Sun, Feb 04, 2007 at 01:44:18PM +0100, Michael Buesch wrote:
> >
> > > We need the phase1 for bcm43xx. We need to upload it to
> > > card memory and we need to pass it on every TX on the DMA.
> >
> > > So, currently we receive the phase1 key on the first
> > > encrypted TX. That's too late, as we already receive encrypted
> > > packets before that. bcm43xx needs the phase1 key (and the iv32)
> > > on RX. It uses the one uploaded into the card memory. But it
> > > is not uploaded, yet, as we did not TX any encrypted packet.
> >
> > How exactly is this supposed to work for RX?
>
> I misunderstood it, so my explaination was not 100% correct.
>
> It works the following way: We need the phase1 for TX and for RX.
> The key for TX is passed along with the TX frame. We can take the
> key from the tx_control (I'd still like to get rid of the
> array in the tx_control, though. Working on it...)
> For RX we have the phase1 uploaded to some device memory.
>
> What happens on RX when the iv32 wraps. Well, it simply won't decrypt
> the frame. What we must do then is upload a new key as fast as possible.
> The undecrypted frame can be either decrypted in SW (which I think d80211
> can do. At least with minor additional changes), or we drop it.
>
> I started to implement an API to calculate the phase1 key on demand.
> It doesn't quite work, yet and I'm stuck in more important work
> that should be done before the d80211 merge, so it will take some time
> until I can continue debugging the stuff.
>
> --
> Greetings Michael.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
