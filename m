Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3693 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751587Ab2E0MRR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 May 2012 08:17:17 -0400
Message-ID: <4FC21B3F.6090903@broadcom.com> (sfid-20120527_141753_393207_65E544E7)
Date: Sun, 27 May 2012 14:17:03 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH 4/8] brcm80211: smac: inform mac80211 of the X2
 regulatory domain
References: <1334607462-5387-1-git-send-email-seth.forshee@canonical.com>
 <1334607462-5387-5-git-send-email-seth.forshee@canonical.com>
 <4FC008AB.4080107@broadcom.com> <20120526171800.GC11759@ubuntu-mba>
In-Reply-To: <20120526171800.GC11759@ubuntu-mba>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/26/2012 07:18 PM, Seth Forshee wrote:
> On Sat, May 26, 2012 at 12:33:15AM +0200, Arend van Spriel wrote:
>>> +#define BRCM_2GHZ_2412_2462	REG_RULE(2412-10, 2462+10, 40, 0, 19, 0)
>>> +#define BRCM_2GHZ_2467_2472	REG_RULE(2467-10, 2472+10, 20, 0, 19, \
>>> +					 NL80211_RRF_PASSIVE_SCAN | \
>>> +					 NL80211_RRF_NO_IBSS)
>>> +#define BRCM_2GHZ_2484		REG_RULE(2484-10, 2484+10, 40, 0, 19, \
>>> +					 NL80211_RRF_PASSIVE_SCAN | \
>>> +					 NL80211_RRF_NO_OFDM)
>>> +
>>
>> If channels 12 and 13 are 20MHz only, shouldn't channel 14 above
>> (2484MHz) be 20MHz as well?
> 
> Heh, good point. I'm trying to remember why I made 12 and 13 20MHz only
> though; maybe that's a mistake. Is there any reason why they couldn't
> all be 40MHz?

Not sure either. A number of countries have this rule so maybe it is
regulatory requirement.

>>
>> You can avoid this code if you/we do not add the channels to
>> wiphy->bands[IEEE80211_BAND_5GHZ]. The driver does not support DFS so we
>> better stay away from these channels, which was your original issue to
>> start this work if I recall correct :-( Sorry.
> 
> This is what originally got me looking at the brcmsmac regulatory
> support, so it would be disappointing if at the end these channels still
> aren't usable.

Hence me saying sorry.

> My understanding of DFS is pretty rudamentary. Could you explain what
> support is needed? I do see that mac80211 doesn't really support power
> measurement requests, but if we can at least stop transmission when
> radar is present couldn't we still operate on the channels?

The hardware would need to signal the driver that a radar has been detected.

> Luis, any insight you can offer on the subject would be appreciated.
> 
>>
>> can this be moved in brcms_c_channel_mgr_attach()?
> 
> Not without rearranging the initialization, as brcms_c_regd_init() must
> be called after wiphy->bands has been set up. I don't see any reason why
> setting up the bands couldn't be moved to before channel_mgr_attach()
> though, and in that case regd_init() could be moved into
> channel_mgr_attach().

Please do. I prefer to keep regd_init() local to channel.c.

Gr. AvS

