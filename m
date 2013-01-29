Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www19.servergod.com ([64.89.16.20]:62062 "EHLO
	www19.servergod.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab3A2Vuw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jan 2013 16:50:52 -0500
Message-ID: <5108442D.9080104@opentechinstitute.org> (sfid-20130129_225055_942208_86D79931)
Date: Tue, 29 Jan 2013 16:50:37 -0500
From: Will Hawkins <hawkinsw@opentechinstitute.org>
MIME-Version: 1.0
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Antonio Quartulli <antonio@open-mesh.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCHv3 2/2] mac80211: in AD-HOC mode wait for the AUTH response
References: <1355146824-25012-1-git-send-email-antonio@open-mesh.com>   <1355146824-25012-2-git-send-email-antonio@open-mesh.com>   <1356706268.9922.23.camel@jlt4.sipsolutions.net>   <20130102063255.GA27676@open-mesh.com> <50E400A7.5060100@lri.fr>   <20130107114048.GH27589@ritirata.org> <50EACA95.8040004@lri.fr>  <1359151524.4655.37.camel@jlt4.sipsolutions.net> <5103C774.4080403@lri.fr> <1359459469.8108.11.camel@jlt4.sipsolutions.net> <5107D5D5.3070601@lri.fr>
In-Reply-To: <5107D5D5.3070601@lri.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 01/29/2013 08:59 AM, Nicolas Cavallari wrote:
> On 29/01/2013 12:37, Johannes Berg wrote:
>> On Sat, 2013-01-26 at 13:09 +0100, Nicolas Cavallari wrote:
>>> (and my take on this, is that we should just handle open system
>>> authentication and reboot detection in userspace (i have code for that),
>>> and revert the kernel to the old state where it would just answers an
>>> open system authentication request if userspace is not handling it)
>>
>> I think that would make sense. However, to really implement that it
>> seems that wpa_s should be able to control the in-kernel station
>> "authenticated" state, not just "authorized" state?
> 
> Theoritically, yes. However, i don't remember that the "authenticated" state actually
> changes anything in IBSS mode. In fact, with the current code, all stations have the
> "authenticated" state, whatever the specified parameters and even when the kernel
> initiates an open system authentication.

I agree with this statement. From my reading of the code, it seems that
IBSS nodes are always authenticated. Which is fine, as long as I am not
missing something! :-)

> 
>>
>> What's the status we have today in the kernel, without the patches, and
>> what would that "revert" mean?
> 
> Right now, all IBSS stations have the "authenticated" flag.
> 
> If userspace is subscribed to auth frames, userspace have to handle everything, else, if
> userspace is not subscribing to auth frames:
> - When detecting a new station, the kernel sends an open system auth request, as part of
> node reboot detection.
> - When the kernel receives an open system authentication request, it destroys the station
> and recreates it as part of node reboot detection. If all goes well, it answers it.
> - wpasupplicant uses the NEW_STA and DEL_STA events to maintain a list of stations. It
> starts RSN handshakes on NEW_STA, and destroy its state on DEL_STA. Eventually, if
> handshakes succeeds, wpasupp authorize the stations with SET_STA (i think). much older
> wpasupplicant do not support authorizing stations, so the kernel always authorize stations
> (but all their unencrypted frames will be dropped until wpasupp configures a PTK after a
> successful handshake).
> 
> The revert is just my personal taste, but in the case where userspace does not subscribe
> to auth frames, i would just make the kernel answer an open system authentication request
> if it receives one, and not send any open system auth by itself. That would mean no reboot
> detection unless userspace does it. wpasupplicant would maybe need a way to reset the
> kernel's sta_info if not already possible.
> 
> 
>> What changes could we make today to solve this in a way that's
>> compatible with today's wpa_supplicant (and maybe Will's SAE
>> implementation, though maybe he wouldn't mind small changes too much)?
> 
> Will's SAE will not be affected by any of this, as it's done in userspace by subscribing
> to auth frames. If Will need node reboot detection, he has to do it himself.

Totally agreed! This will not change my code at all. However, having a
"new authenticated station" message (to parallel a message like
NL80211_CMD_NEW_PEER_CANDIDATE from the 802.11s world) would be great
too. That's how I interpreted the IBSS_STA event to work.

The ultimate goal for me is to eventually incorporate SAE support for
IBSS into wpa_s. In other words, I'm following this discussion very
closely and I appreciate everyone's work.

> 
> If we want a working node reboot detection with the current wpasupplicant, we need, in
> IBSS mode, to only make the kernel send NEW_STA when a station is authenticated. There's
> not much choice here.
> 
> If it's acceptable to not have node reboot detection with current wpasupplicant, we could
> make a future wpasupplicant add a flag saying it supports the new IBSS_STA event, and the
> kernel would only do reboot detection in this case.
> 
