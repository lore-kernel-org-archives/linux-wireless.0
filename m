Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2.u-psud.fr ([129.175.33.42]:60865 "EHLO smtp2.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921Ab3AaOSm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 09:18:42 -0500
Message-ID: <510A7D40.2030206@lri.fr> (sfid-20130131_151846_433823_A0AE8549)
Date: Thu, 31 Jan 2013 15:18:40 +0100
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Antonio Quartulli <antonio@open-mesh.com>,
	linux-wireless@vger.kernel.org,
	Will Hawkins <hawkinsw@opentechinstitute.org>
Subject: Re: [PATCHv3 2/2] mac80211: in AD-HOC mode wait for the AUTH response
References: <1355146824-25012-1-git-send-email-antonio@open-mesh.com>    <1355146824-25012-2-git-send-email-antonio@open-mesh.com>    <1356706268.9922.23.camel@jlt4.sipsolutions.net>    <20130102063255.GA27676@open-mesh.com> <50E400A7.5060100@lri.fr>    <20130107114048.GH27589@ritirata.org> <50EACA95.8040004@lri.fr>   <1359151524.4655.37.camel@jlt4.sipsolutions.net> <5103C774.4080403@lri.fr>  <1359459469.8108.11.camel@jlt4.sipsolutions.net> <5107D5D5.3070601@lri.fr> <1359639241.8415.17.camel@jlt4.sipsolutions.net>
In-Reply-To: <1359639241.8415.17.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31/01/2013 14:34, Johannes Berg wrote:
> That seems reasonable. Actually there's no reason for wpa_s to "reset
> the [...] sta_info", all it really has to do is set it to unauthorized
> if it detects it was rebooted, and then start key negotiation again, I
> think?

I'm not sure why Antonio resetted the sta_info. Not resetting it when a node reboot is
detected from userspace works for me anyway.

>> If we want a working node reboot detection with the current wpasupplicant, we need, in
>> IBSS mode, to only make the kernel send NEW_STA when a station is authenticated. There's
>> not much choice here.
>>
>> If it's acceptable to not have node reboot detection with current wpasupplicant, we could
>> make a future wpasupplicant add a flag saying it supports the new IBSS_STA event, and the
>> kernel would only do reboot detection in this case.
> 
> I think that's acceptable, but if it requires a wpa_s change anyway we
> could just implement reboot detection there instead of adding all these
> new events etc.? I.e. rather than having a new supplicant say "OK I will
> listen to the right event when handling reboot detection", it could just
> use the existing infrastructure and implement it itself?

Well i already have wpa_supplicant patches for that. Might just need to clean that up a
bit so it's at least configurable.

But now i'm reminded that transmitting management frames from userspace requires a
frequency. For wpasupp to be race-free during ibss merges, we should have a way to
transmit management frames to the current bss without specifying a frequency...

(Will once said he uses fixed-channel, so he is not affected)
