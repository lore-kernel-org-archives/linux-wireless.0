Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:55351 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab3A3Lvr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 06:51:47 -0500
Message-ID: <5109094C.8050703@neratec.com> (sfid-20130130_125150_774691_A5C3BA93)
Date: Wed, 30 Jan 2013 12:51:40 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
CC: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	victorg@ti.com, linville@tuxdriver.com, kgiori@qca.qualcomm.com,
	adrian@freebsd.org, j@w1.fi, coelho@ti.com, igalc@ti.com,
	nbd@nbd.name, mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv7 1/3] nl80211/cfg80211: add radar detection command/event
References: <1359462120-22898-1-git-send-email-siwu@hrz.tu-chemnitz.de> <1359462120-22898-2-git-send-email-siwu@hrz.tu-chemnitz.de> <5107D345.7010101@neratec.com> <20130129143652.GA23425@pandem0nium>
In-Reply-To: <20130129143652.GA23425@pandem0nium>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/29/2013 03:36 PM, Simon Wunderlich wrote:
> Hey Zefir,
> 
> On Tue, Jan 29, 2013 at 02:48:53PM +0100, Zefir Kurtisi wrote:
>> On 01/29/2013 01:21 PM, Simon Wunderlich wrote:
>>> From: Victor Goldenshtein <victorg@ti.com>
>>>
>>> [...]
>>>  
>>>  /**
>>> + * enum ieee80211_dfs_state - DFS states for channels
>>> + *
>>> + * Channel states used by the DFS code.
>>> + *
>>> + * @IEEE80211_DFS_USABLE: The channel can be used, but channel availability
>>> + *	check (CAC) must be performed before using it for AP or IBSS.
>>> + * @IEEE80211_DFS_UNAVAILABLE: A radar has been detected on this channel, it
>>> + *	is therefore marked as not available.
>>> + * @IEEE80211_DFS_AVAILABLE: The channel has been CAC checked and is available.
>>> + */
>>> +
>>> +enum ieee80211_dfs_state {
>>> +	IEEE80211_DFS_USABLE,
>>> +	IEEE80211_DFS_UNAVAILABLE,
>>> +	IEEE80211_DFS_AVAILABLE,
>>> +};
>>> +
>> Not sure if IEEE80211_DFS_UNKNOWN is not missing here, i.e. whether a channel that
>> never passed a CAC (or the CAC has been aborted) is always USABLE. Once I realized
>> why ETSI defined an UNKNOWN state, but forgot meanwhile - so maybe only relevant
>> for managed operation (like an UNKNOWN state can be overridden by external
>> information, whereas e.g. UNAVAILABLE can't).
> 
> I've seen the UNKNOWN state in your last mail and your last slides, but didn't see
> a purpose for it. If you can remember what we need it for, please tell me. :) We could
> reject changes for an UNAVAILABLE channel from outside access if this is required.

Double checked it and realized that ETSI removed that state between v1.5 and v1.7.
Before, it enabled the frequency manager to differentiate between untouched
channels and channels that passed a NOP (which is the only way to become USABLE).

>>
>> Furthermore, is there a reason to define an additional wireless_dev.cac_started
>> flag vs. adding a IEEE80211_DFS_CAC state?
> 
> We have discussed that we want to move cac-information from channel into wdev, so I
> just did that.
> 
Sorry, did not follow that discussion fully (due to my inability to follow).
Having a dedicated CAC state would provide a convenient way to directly retrieve
the state transition info, but I understand it makes no sense to have it redundant.

> The idea was that a CAC can always be started, and state transition is only performed
> after a succesful CAC. This simplifies the state machine and some corner cases. A
> channel stays USABLE through the CAC, and is only changed to AVAILABLE after CAC is
> completed. We also don't forbid checking the same channel on different WiFi modules,
> if any of them completes the channel is changed to AVAILABLE.
>
Really, a CAC is done whenever you switch to a DFS channel? I'd expect that
switching from an operating channel and back does not require a CAC (that's the
sole purpose of the AVAILABLE state and a centralized state handler).

> The same goes for the OPERATING state (defined in ETSI at least) - I don't have this
> as dfs state, because it is just the same as AVAILABLE plus the information that
> we currently use it, and that we know in the driver. Adding the state would just
> add management overhead with no practical gain, IMHO.
> 
Would there be a benefit of an OPERATING state on systems with multiple wiphys?

> Cheers,
> 	Simon
> 

