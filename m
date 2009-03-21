Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:51482 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbZCULni convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Mar 2009 07:43:38 -0400
Received: by fxm2 with SMTP id 2so1194556fxm.37
        for <linux-wireless@vger.kernel.org>; Sat, 21 Mar 2009 04:43:35 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: Google Summer of Code 2009 -- Linux wireless roaming project
Date: Sat, 21 Mar 2009 12:43:24 +0100
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	Holger Schurig <hs4233@mail.mn-solutions.de>,
	Mircea Gherzan <mgherzan@gmail.com>
References: <20090320215705.GE8120@tesla>
In-Reply-To: <20090320215705.GE8120@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200903211243.25380.helmut.schaa@gmail.com> (sfid-20090321_124342_062747_44C08527)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Freitag, 20. M=C3=A4rz 2009 schrieb Luis R. Rodriguez:
> We need to extend this now and since things are shifting towards nl80=
211
> (the MLME SAP stuff) I think we may need to rethink this a bit. Ideas=
,
> wishlists for how to improve our roaming with the help of GSoC studen=
ts
> would be appreciated.

Ok, here are some considerations regarding roaming:

Basically roaming can be divided into 3 steps:
1) detect if it is time to roam
2) scan for better APs
3) associate with the new AP

Step 1 is the most difficult one here, 2 only needs some tweaking and 3
should work as it is currently.

So, how can we detect if it is beneficial to roam?

a) Just check the signal strength if it drops below a certain threshold
   and start a scan if that happens

Advantages:
- Easy to implement

Disadvantages:=20
- The signal strength values on different cards are not comparable. So =
the
  threshold value has to be different for all cards.
- Ping-pong effect if you sit between two APs both are in range but wit=
h a
  signal strength around the threshold.
- Unnecessary scanning if the signal strength is below the threshold bu=
t no
  better AP is in range will further reduce the connection quality and
  increase power consumption.

b) Number of consecutivley missed beacons below threshold

Advantages:
- Also easy to implement
- Comparable value on all cards

Disadvantages:
- e.g. 10 consecutively missed beacons means that the connection is alr=
eady
  quite bad but we need around 1 second (beacon interval=3D100ms) to de=
tect
  that =3D> Handoff delay is strictly greater than 1 second (+scan and
  association)
- Using smaller values might result in a similar ping-pong effect as
  described above
- Unnecessary scanning if the number of missed beacons drops below the
  threshold every once and then but no better AP is in range will furth=
er
  reduce the connection quality and increase power consumption.

c) Only scan for new APs if the environment changes (e.g. we are moving=
 or
   the AP is moving etc.)

This could for example be done by computing the sample variance of the =
signal
strength (maybe measured over the last second) which will change signif=
icant
if the client or the AP is moving (see [1] for details).

If the client device has a GPS it would be beneficial to only scan for =
better
APs if the client is moving.

Advantages:
- Number of unnecessary scans is lower than for a) and b)

Disadvantages:
- Needs some more theoretical research on how to automatically find the
  threshold values for the signal strength variance.
- Complex implementation

I already did some research on c) and it looks very promising but the t=
opic
is quite complex and needs more theoretical research first.



Now, some considerations regarding the implementation:

Independently of which trigger is used to start the roaming process I w=
ould
suggest the following:

Scanning for new APs should not be started from within the driver or
mac80211. Instead wpa_supplicant should care about that. Why? Just beca=
use
the supplicant might have more information (maybe provided by NM) about=
 the
used network. For example a typical multi-AP network won't use all chan=
nels
from within the bg-band due to signal interferences. Instead, all APs w=
ill be
located on non-overlapping channels. Let's say 1,6 and 11. Hence, if th=
e
supplicant tiggers a scan it will just leave all channels !=3D 1,6,11 o=
ut of
the scan request and the scan will take a shorter amount of time, which
in turn speeds up the handoff delay.

However, that infrastructure is not there yet but something like the fo=
llowing
would be worth considering: extend wpa_supplicant's network blocks to a=
llow
the specification of preferred channels ("channels=3D1,6,11"). This val=
ue could
be provided by NM which gathered that information either from the user =
or
through monitoring. If the client was already connected to several APs =
in the
same ESS it would just pass these channels to wpa_supplicant. Of course=
 if no
AP is found on the preferred channels a full scan might have to run.



Ok, regarding the second part "scanning":

In order to lower the negative influence a scan has to the ongoing traf=
fic
the software scan implementation would have to be reworked. The scan sh=
ould
simply switch back to the operating channel every once in a while to al=
low
queued packets to be delivered (in both directions).

Phew! I'm pretty sure I've missed several ideas/considerations here but=
 that
has to suffice for now.

Helmut

[1] http://www.informatik.uni-mannheim.de/pi4/publications/King2008c.pd=
f=20
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
