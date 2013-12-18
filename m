Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:34272 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab3LRJUA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Dec 2013 04:20:00 -0500
Received: by mail-we0-f181.google.com with SMTP id x55so7337825wes.12
        for <linux-wireless@vger.kernel.org>; Wed, 18 Dec 2013 01:19:59 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 18 Dec 2013 10:19:59 +0100
Message-ID: <CADnKcVie-gqXMNS-c+ObtFrwuN3RYJVaPsnPc9=DuPxBKiPaaA@mail.gmail.com> (sfid-20131218_102008_561675_2A1727E0)
Subject: Re: [PATCH v5] cfg80211: fix dfs channel state after stopping AP
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 December 2013 15:44, Simon Wunderlich <sw@simonwunderlich.de> wrote:
> Sorry for answering after so many revisions, but ... why do you think this is
> required? Many APs first do a CAC on all available channels, but then pick one
> channel and use that, while being able to switch to another channel
> immediately.
>
> WIth this patch (if I understand that correctly), this is not possible
> anymore. Why do you think it is required? I can not find this requirement in
> ETSI, at least.
>
> To quote from ETSI 301.893:
>
> Once the RLAN has started operations on an Available Channel, then that
> channel becomes an Operating Channel. During normal operation, the master
> device shall monitor all Operating Channels (In-Service Monitoring) to ensure
> that there is no radar operating within these channel(s). If no radar was
> detected on an Operating Channel but the RLAN stops operating on that channel,
> then the channel becomes an Available Channel.
>
> I think this patch is wrong and should not be applied.
>
> Thanks,
>     Simon

I also have doubts when reading this specification:

ETSI 301.893 v1.7.0:

"A master device shall only start operations on Available Channels. At
installation (or reinstallation) of the equipment, the RLAN is assumed
to have no Available Channels within the band 5 250 MHz to 5 350 MHz
and/or 5 470 MHz to 5 725 MHz. In such a case, before starting
operations on one or more of these channels, the master device shall
perform either a Channel Availability Check or an Off-Channel CAC to
ensure that there are no radars operating on any selected channel. If
no radar has been detected, the channel(s) becomes an Available
Channel(s) and remains as such until a radar signal is detected during
the In-Service Monitoring. The Channel Availability Check or the
Off-Channel CAC may be performed over a wider bandwidth such that all
channels within the tested bandwidth become Available Channels."

First thing: how to interpret words installation and reinstallation?
If we include stating hostapd in installation process then we should
have no available channels when starting hostapd.

Second thing: How to interpret this sentence: "If no radar has been
detected, the channel(s) becomes an Available Channel(s) and remains
as such until a radar signal is detected during the In-Service
Monitoring."
As I understand this sentence channel can be available as long as
radar detection works, so called In-Service Monitoring. When in
service monitoring is off then channel can not be available. Of course
this is my interpretation. So if there are APs than can monitor one
channel after switch to new channel then I agree that both channels
can be available. In hostapd when last AP interface is stopped then it
is no longer monitoring current channel, so starting AP after some
time can not happened without CAC. Simple case: we have our AP on
mobile device, it was stopped in one place where was no radars and
after moving to new place we start AP again. But this new place is in
radar range. So we should start beaconig or start CAC first?


Marek
