Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:59037 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab1J2MB7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Oct 2011 08:01:59 -0400
Received: by ggnb1 with SMTP id b1so4446205ggn.19
        for <linux-wireless@vger.kernel.org>; Sat, 29 Oct 2011 05:01:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <877h3pb5pp.fsf@purkki.adurom.net>
References: <20111021142322.229128720@sipsolutions.net>
	<1319743973.32221.4.camel@jlt3.sipsolutions.net>
	<400C43189542CE41BC0A5B252FC90136BC0E3753AA@SJEXCHCCR02.corp.ad.broadcom.com>
	<1319788880.3914.4.camel@jlt3.sipsolutions.net>
	<400C43189542CE41BC0A5B252FC90136BC0E37541B@SJEXCHCCR02.corp.ad.broadcom.com>
	<CAGXE3d9NiHgmE_ABc_red7MeNnhUGG+fOgbL19B9U3e9Fx9Vxw@mail.gmail.com>
	<877h3pb5pp.fsf@purkki.adurom.net>
Date: Sat, 29 Oct 2011 14:01:57 +0200
Message-ID: <CAGXE3d8dx7UgkBuQihURVxHBOBcs0N1iMTHFVEFBq317RfJ=_A@mail.gmail.com> (sfid-20111029_140208_849132_B091E7CF)
Subject: Re: [RFC v2 13/12] cfg80211/mac80211: allow management TX to not wait
 for ACK
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Arend Van Spriel <arend@broadcom.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 28, 2011 at 3:34 PM, Kalle Valo <kvalo@adurom.com> wrote:
> Helmut Schaa <helmut.schaa@googlemail.com> writes:
>
>> The reason is the following: if you're running a mac80211 AP with multiple
>> bssids, hostapd will answer to broadcast probe requests sent by STAs with
>> one probe response per bssid (unicast of course). And since some clients
>> stay only for a short amount of time on the scan-channel (a few ms) under
>> some circumstances the probe responses aren't sent out yet before the
>> scanning STA leaves the channel and thus retried till the maximum retry
>> limit is reached. And these retries consume quite a lot of airtime. And to
>> avoid this we just don't want to retry the probe responses in that case.
>
> This is all good. But doesn't it also mean that this change increases
> probability that the client doesn't receive the probe response, for
> example due to interference where retransmission would help, and hence
> the AP isn't included in the client's scan results?

Correct. The probability to find the AP during a scan is lower then with
retries. However, some commercial APs (Aruba for example) do exactly this
and in some cases I noticed (on a mac80211 AP with 8 BSSIDs) one
scanning client took around 50ms of airtime :)

Also in a multi BSS scenario the probability of finding the second, third etc.
BSSID gets lower if probe responses are retried.

I've got a patch for hostapd to implement the don't-wait-for-ack behavior
only for broadcast probe responses that contain the wildcard ssid. But maybe
it makes sense to make this a configuration option? So it is up to the user
to decide about the behavior.

Helmut
