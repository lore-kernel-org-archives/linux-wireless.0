Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4558 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755220Ab3FEOOQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 10:14:16 -0400
Message-ID: <51AF47AF.9060802@broadcom.com> (sfid-20130605_161420_752342_FD021ABC)
Date: Wed, 5 Jun 2013 16:14:07 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Antonio Quartulli" <antonio@open-mesh.com>
cc: "Antonio Quartulli" <ordex@autistici.org>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"brcm80211-dev-list@broadcom.com" <brcm80211-dev-list@broadcom.com>
Subject: Re: [PATCHv2 3/4] brcm80211: make mgmt_tx in brcmfmac accept a
 NULL channel
References: <1370433187-1337-1-git-send-email-ordex@autistici.org>
 <1370433187-1337-3-git-send-email-ordex@autistici.org>
 <51AF42DC.3000001@broadcom.com> <20130605135757.GF2349@open-mesh.com>
In-Reply-To: <20130605135757.GF2349@open-mesh.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/05/2013 03:57 PM, Antonio Quartulli wrote:
> On Wed, Jun 05, 2013 at 06:53:32AM -0700, Arend van Spriel wrote:
>
> [...]
>
>>> +		freq = cfg->channel;
>>> +		if (chan)
>>> +			freq = chan->center_freq;
>>> +		chan_nr = ieee80211_frequency_to_channel(freq);
>>
>> Could you get rid of 'freq' variable and use
>> ieee80211_frequency_to_channel() on cfg->channel or chan->center_freq.
>>
>
> I tried that, but the line indented below the if would be longer than 80 chars
> and breaking it is quite ugly.
>
>> Another thing is that cfg->channel can be zero resulting in chan_nr
>> being zero. I had a quick look whether the device firmware can handle
>> this. I suspect not, but I will need to ask to be sure.
>>
>
> ok. But when cfg->channel is zero, where is the current freq stored?

It is not. The rf on the device is set to a certain channel so it can be 
retrieved from the device:

brcmf_fil_cmd_int_get(vif->ifp, BRCMF_C_GET_CHANNEL, &freq);

The vif pointer can be obtained using container_of() on the wdev. That 
is done in mgmt_tx() already some lines above. May you should move 
determining the vif pointer and do it unconditional.

Regards,
Arend


