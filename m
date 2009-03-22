Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.171]:17151 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984AbZCVUsi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 16:48:38 -0400
Received: by wf-out-1314.google.com with SMTP id 29so2481342wff.4
        for <linux-wireless@vger.kernel.org>; Sun, 22 Mar 2009 13:48:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1237712542.5100.766.camel@johannes.local>
References: <1237712542.5100.766.camel@johannes.local>
Date: Sun, 22 Mar 2009 13:48:21 -0700
Message-ID: <43e72e890903221348q3db85b30k7975d996c5269c28@mail.gmail.com> (sfid-20090322_214844_394435_6B646151)
Subject: Re: [RFC] regulatory information interpretation rules
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Green <Michael.Green@atheros.com>,
	Jouni Malinen <j@w1.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	David Quan <David.Quan@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 22, 2009 at 2:02 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Ok, so I'm thinking about the interpretation rules for the regulatory
> information. I even dreamt about this tonight, unfortunately...
>
> Long mail ahead, sorry, but I felt it was best to include some
> background information and examples.
>
> To recap, our information for each country currently consists of
> multiple sub-band rules as follows:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(MIN - MAX @ MAXBW), (MAXAG, TXPWR), FLAGS
>
> Where:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0MIN =C2=A0 =C2=A0 lower band edge
> =C2=A0 =C2=A0 =C2=A0 =C2=A0MAX =C2=A0 =C2=A0 upper band edge
> =C2=A0 =C2=A0 =C2=A0 =C2=A0MAXBW =C2=A0 maximum usable bandwidth
> =C2=A0 =C2=A0 =C2=A0 =C2=A0MAXAG =C2=A0 maximum permitted antenna gai=
n
> =C2=A0 =C2=A0 =C2=A0 =C2=A0TXPWR =C2=A0 maximum transmit power
> =C2=A0 =C2=A0 =C2=A0 =C2=A0FLAGS =C2=A0 special restriction flags:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0- NO_OFDM =C2=A0=
 =C2=A0 =C2=A0 no OFDM use permitted
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0- NO_CCK =C2=A0=
 =C2=A0 =C2=A0 =C2=A0no CCK use permitted
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0- INDOOR =C2=A0=
 =C2=A0 =C2=A0 =C2=A0indoor use only
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0- OUTDOOR =C2=A0=
 =C2=A0 =C2=A0 outdoor use only
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0- DFS =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 DFS required
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0- PTP_ONLY =C2=
=A0 =C2=A0 =C2=A0PTP only
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0- PTMP_ONLY =C2=
=A0 =C2=A0 PTMP only
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0- PASSIVE_SCAN=
 =C2=A0passive scan
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0- NO_IBSS =C2=A0=
 =C2=A0 =C2=A0 no IBSS (should be applied to mesh also)
>
> The flags should be fairly self-explanatory.
>
> The maximum antenna gain is a little useless because there's no way t=
o
> enforce this by changing antennas, nor are antenna gain values always
> known to the host software -- and in any case it seems a little
> restrictive to disable the wireless entirely if the AG is higher. Nee=
ds
> thought on what to do with this -- maybe keep for informational purpo=
ses
> only.
>
> The maximum usable bandwidth specifies how much of the (sub)band you =
are
> allowed to use at once, at least that was my current interpretation -=
- I
> now think we should document the interpretation rules and slightly
> change it from what I've been thinking. This is relevant for example =
for
> HT40, apparently not all countries permit using 40 MHz of the ISM
> spectrum by a single transmitter.
>
> For a simple interpretation case, let me give an example:
> country ZW:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(2402.000 - 2482.000 @ 40.000), (N/A, 20.0=
0)
>
> This means that you can use channels 1 through 13 with 20 MHz bandwid=
th,
> or HT40+ on channels 1 through 11, or HT40- on channels 3 through 13,=
 or
> anything with a lower bandwidth, of course. Theoretically you would b=
e
> allowed to use a 10 MHz channel on 2407 MHz, but that isn't possible =
in
> 802.11 implementations. [1]
>
>
> More complex rules exist for 5 GHz, though. Take this example:
> country DK:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(2402.000 - 2482.000 @ 40.000), (N/A, 20.0=
0)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(5170.000 - 5250.000 @ 40.000), (N/A, 20.0=
0)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(5250.000 - 5330.000 @ 40.000), (N/A, 20.0=
0), DFS
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(5490.000 - 5710.000 @ 40.000), (N/A, 27.0=
0), DFS
>
> Here, we have a DFS requirement on anything above 5250 MHz. This does
> not, however, preclude using HT40- on channel 52 (5260 MHz) [2], but
> would require DFS for that combination. Similar things can happen for
> transmit power.
>
> Interesting things happen where you have overlaps, like Japan's 2.4 G=
Hz
> band:
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(2402.000 - 2472.000 @ 40.000), (N/A, 20.0=
0)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(2457.000 - 2482.000 @ 20.000), (N/A, 20.0=
0)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(2474.000 - 2494.000 @ 20.000), (N/A, 20.0=
0), NO-OFDM
>
> Luis says this is meant to specify:
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Channels 1-11 allow 40 width channels, so =
HT40 is allowed.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Channels 12, 13 only allow 20 MHz width ch=
annels, so HT40 is
> =C2=A0 =C2=A0 =C2=A0 =C2=A0disallowed.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Channel 14 only allows non-OFDM.
>
> But how can we arrive at that interpretation? I would argue that we n=
eed
> to change the interpretation rules in a way that lets us remove overl=
ap
> and specify what is really required. This means more dynamic flags
> calculations, but we can live with that. To this end, let me propose
> that the rules for 2.4 GHz Japan be rewritten to (where I have marked
> changes with *):
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0( 2402.000 - *2452.000 @ 40.000), (N/A, 20=
=2E00)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(*2452.000 - =C2=A02482.000 @ 20.000), (N/=
A, 20.00)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0(*2482.000 - =C2=A02494.000 @ 20.000), (N/=
A, 20.00), NO-OFDM
>
> Now how should you interpret this? I'll propose the following
> interpretation rules (and show how you arrive at the required
> interpretation from above):
>
> =C2=A01) MIN values are really something like MIN+, i.e. approaching =
the MIN
> =C2=A0 =C2=A0from above, that means that the value "2452 MHz" falls i=
nto the
> =C2=A0 =C2=A0first of the ranges, not the second [3]

I rather be more exact. Can you elaborate a little more on this?

> =C2=A02) The entire band a channel occupies needs to be covered by (a=
ny
> =C2=A0 =C2=A0number of) contiguous rules.
>
> =C2=A03) The MAXBW value specifies what maximum bandwidth a channel c=
an use
> =C2=A0 =C2=A0which has its center frequency (!) falling into the give=
n range.
>
> =C2=A04) The FLAGS specify restrictions that any channel _overlapping=
_ the
> =C2=A0 =C2=A0given range has to operate under.
>
> That is all. Now let me show how to interpret this.
>
> "Channels 1-11 allow 40 width channels, so HT40 is allowed."
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Channel 11 has center frequency 2462, but =
when used with HT40
> =C2=A0 =C2=A0 =C2=A0 =C2=A0the center of the used bandwidth falls to =
2452 or 2472.

> =C2=A0 =C2=A0 =C2=A0 =C2=A02452 falls into the first range, so can us=
e 40 MHz,

Hm, so the two modified rules that we should look at for a channel
who's center freq is 2452 MHz are:

        ( 2402.000 - *2452.000 @ 40.000), (N/A, 20.00)
        (*2452.000 -  2482.000 @ 20.000), (N/A, 20.00)

I cannot clearly see how a 40 MHz width channel would be allowed here
if its center of freq is 2452 MHz given the interpretation rules
above. It would seem to me the two regulatory rules would be required
to make that determination since the start freq and end freq of the
HT40 channel would only fit when considering both rules. Why would we
determine we can use 40 MHz on this HT40 channel? What if the allowed
bandwidth for the second rule was 10 MHz instead of 20 MHz?

>        2472 falls into
> =C2=A0 =C2=A0 =C2=A0 =C2=A0the second range so cannot use 40 MHz, so =
only HT40- is
> =C2=A0 =C2=A0 =C2=A0 =C2=A0permitted.
>
> "Channels 12, 13 only allow 20 MHz width channels, so HT40 is disallo=
wed."
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Channels 12/13 have center frequencies 246=
7/2472 respectively,
> =C2=A0 =C2=A0 =C2=A0 =C2=A0with HT40 falling to center frequencies 24=
57, 2477, 2462, 2482.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0None of those fall into a range where 40 M=
Hz bandwidth is
> =C2=A0 =C2=A0 =C2=A0 =C2=A0allowed, but 2467/2472 fall into the secon=
d range so can be used
> =C2=A0 =C2=A0 =C2=A0 =C2=A0with 20 MHz (e.g. HT20), the 20 MHz channe=
l 13 covers 2462-2482
> =C2=A0 =C2=A0 =C2=A0 =C2=A0MHz so it is not subject to the NO_OFDM re=
striction.
>
> "Channel 14 only allows non-OFDM."
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Channel 14's center frequency is 2484, so =
it clearly falls into
> =C2=A0 =C2=A0 =C2=A0 =C2=A0the third range, its HT40 use would be 247=
4 or 2494 MHz none of
> =C2=A0 =C2=A0 =C2=A0 =C2=A0which are permitted to use 40 MHz, and any=
thing with 2494 center
> =C2=A0 =C2=A0 =C2=A0 =C2=A0frequency would not be covered by a permit=
ted range anyway.
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Channel 14 (as a regular 20 MHz channel) c=
overs 2474-2494 so
> =C2=A0 =C2=A0 =C2=A0 =C2=A0overlaps with the third range and as such =
is subject to the
> =C2=A0 =C2=A0 =C2=A0 =C2=A0NO_OFDM restriction.
>
>
> Note that currently, due to our regulatory rules, this interpretation
> doesn't actually require changes in any regulatory domain but Japan (=
JP)
> and North Korea (KP) because no other domain has overlaps, and all th=
e
> other examples are like Denmark -- which doesn't apply to us (cf. [2]=
).
>
> Comments?

The overlapping suggestions make sense.

Apart from creating a clarification on how we would deal with
overlapping regulatory rules this also clarifies the way we should
logically think of channels in terms of regulatory for our
infrastructure. 802.11 HT40 channels are now viewed as a singular
channel with its own center of frequency and the question that is
asked is:

"is this HT40 channel allowed?"

The notion of the two channels involved required to make use of HT40
work is ignored and while this works it should be considered for
implementation. For example we want to allow a channel change to occur
as quickly as possible so if the above regulatory questions can be
saved into flag form to avoid a direct regulatory rule lookup during
channel change I think it would be great. How would we cache the
answer to the HT40 question on the channel?

The same HT40 question could be made but instead of looking at the
HT40 channel as an individual channel we'd be trying to answer this by
looking at the two channels involved to make the HT40 channel happen.
We'd know if HT40 is allowed by the allowed bandwidth in the given
regulatory domain, we'd still have to find out whether or not HT40- or
HT40+ is allowed but to answer this we first need to know on which
channels HT40 is allowed and which channels are disabled. The
assumption is if a channel is allowed then the channel can use 20 MHz.
=46or example to find out whether or not HT40- is allowed we'd first
check if the control channel (aka primary channel):

  o exists
  o allowed
  o allows HT40

We'd then check if the same for the extension channel (aka secondary
channel) exists. If both of these channel checks check out OK then
HT40- can be marked as allowed on the primary channel. The answer then
becomes cached for later lookups upon channel change.

How would we go about this with the proposed changes on considering
HT40- upon a channel change?

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
