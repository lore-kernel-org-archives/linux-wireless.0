Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:49008 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757367AbXIFCUW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2007 22:20:22 -0400
Message-ID: <46DF63E2.4020806@lwfinger.net>
Date: Wed, 05 Sep 2007 21:20:18 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Ian Schram <ischram@telenet.be>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, "Zhu, Yi" <yi.zhu@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH V2] Add iwlwifi wireless drivers
References: <1188192012.13078.177.camel@debian.sh.intel.com>	 <20070831205524.GA11128@tuxdriver.com>	 <1188872746.13078.411.camel@debian.sh.intel.com> <1188915229.9942.29.camel@johannes.berg> <46DF5894.70909@telenet.be>
In-Reply-To: <46DF5894.70909@telenet.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ian Schram wrote:
> 
> Johannes Berg wrote:
>> On Tue, 2007-09-04 at 10:25 +0800, Zhu Yi wrote:
>>
>>> Since they are device specific rate scale algorithm, I don't think they
>>> will help to increase performance for other devices.
>> What exactly is device specific?
>>
> 
> I thought I'd try and answer this question to the best of my ability, since it
> has been asked before. And even though it's open source and now has been submitted
> to this list, leaving this unanswered feels like a creepy way of potential time bombs
> and frustration. That said I'm probably not the best person to do it.
> 
> 
> iwl3945-rs:
> 
> - the device can retry at different rates, and hence is able to deduct
> from the total number of retries a packet needed at which rates it failed/
> succeeded
> 
> - tables of expected tpt (throughput?) which are used in the the throughput
> calculation are probably not very universal?
> there aren't identical for 3945 and 4965.
> 
> -some synchronization of the station list with the device ucode happens here
> 
> 
> addidtionally in iwl4965-rs:
> 
> - there is additionally the use of the "link quality" command which for example gets issued when
> there isn't enough of other throughput data available.
> 
> 
> 
> Might be other things that I have missed, and
> parts of the algorithm might be tested/fine tuned for the intended devices.
> 
> 
> So that's that. Some questionable implementation details, but it does use
> device specific logic/capabilities in order to decide which rate to use.
> Now what do we do?

For the first time since this thread started, I think I begin to understand. What is wanted is not a 
new/exotic rate algorithm as much as a way to override the algorithm that mac80211 is using and 
specify the rate you want. If this is correct, such a change would be easy. Such an override would 
be valid only for a STA, and the logic is already there to lock the STA rate in the WEXT interface 
(see routine ieee80211_ioctl_siwrate in net/mac80211/ieee80211_ioctl.c). There are two quantities 
that index the rates in the mode->rates array, sdata->bss->max_ratectrl_rateidx, and 
sdata->bss->force_unicast_rateidx. They are interpreted using the following logic:

if (ratectl_rateidx == -1)
     any legal rate is allowed
else
     the maximum rate is that specified in ratectl_index

if (unicast_rateidx == -1)
     allow any rate up to the maximum above
else
     perform unicast operations at the specified rate

The resulting call will need to supply a net_device and a rate. After verifying that the STA exists, 
it should find the rate in the rate tables and set the two above quantities to the index of that 
rate, just as ieee80211_ioctl_siwrate does.

Certainly, as long as one allows a WEXT entry to set a fixed rate and I would strenuously object if 
someone tried to remove it, a driver should be allowed to do so as well.

Larry


