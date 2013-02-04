Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.u-psud.fr ([129.175.33.41]:59939 "EHLO smtp1.u-psud.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654Ab3BDRPa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2013 12:15:30 -0500
Message-ID: <510FECB0.1040201@lri.fr> (sfid-20130204_181538_602692_37DDF2A4)
Date: Mon, 04 Feb 2013 18:15:28 +0100
From: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] {cfg,nl}80211: tx_mgmt: use current bss channel if omitted.
References: <510A7D40.2030206@lri.fr>  <1359738683-13499-1-git-send-email-cavallar@lri.fr> <1359993855.17993.5.camel@jlt4.sipsolutions.net>
In-Reply-To: <1359993855.17993.5.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/02/2013 17:04, Johannes Berg wrote:
> On Fri, 2013-02-01 at 18:11 +0100, Nicolas Cavallari wrote:
>> Allow not specifying the channel when transmitting a management frame.
>> This allows user space code to not track the current channel.  This is
>> especially useful in IBSS mode, because userspace is not informed when
>> the channel changes because of a merge and requesting the current
>> channel before using it can introduce races.
> 
> 
>> @@ -836,10 +837,23 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
>>  			err = -EOPNOTSUPP;
>>  			break;
>>  		}
>> +		if (!err && chan == NULL) {
>> +			cfg80211_get_chan_state(wdev, &chan, &chan_mode);
> 
> I'm not sure this is the best way of handling it. Is there a reason to
> not pass NULL through to the driver(s) (and audit them) instead? This
> channel access could be racy for channel changes still, etc.

I couldn't understand how tracing would work with NULL arguments, and while most of the
drivers totally ignore the channel argument or does not read it when offchan is false, the
ath6kl driver actually uses the given channel and ignores the offchannel argument.
