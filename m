Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hub022-nj-5.exch022.serverdata.net ([206.225.164.188]:46419
	"EHLO HUB022-nj-5.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751821Ab2KSMSO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 07:18:14 -0500
Message-ID: <50AA237F.4090102@posedge.com> (sfid-20121119_131821_937996_138D751F)
Date: Mon, 19 Nov 2012 17:48:07 +0530
From: Mahesh Palivela <maheshp@posedge.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [RFC v2 4/8] nl80211/cfg80211: support VHT channel configuration
References: <1352492254-29399-1-git-send-email-johannes@sipsolutions.net> <1352492254-29399-5-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1352492254-29399-5-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/10/2012 01:47 AM, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> +bool cfg80211_chan_def_valid(const struct cfg80211_chan_def *chandef)
> +{
> +	u32 control_freq;
> +
> +	if (!chandef->chan)
> +		return false;
> +
> +	control_freq = chandef->chan->center_freq;
> +
> +	switch (chandef->width) {
> +	case NL80211_CHAN_WIDTH_20:
> +	case NL80211_CHAN_WIDTH_20_NOHT:
> +		if (chandef->center_freq1 != control_freq)
> +			return false;
> +		if (chandef->center_freq2)
> +			return false;
> +		break;
> +	case NL80211_CHAN_WIDTH_40:
> +		if (chandef->center_freq1 != control_freq + 10 &&
> +		    chandef->center_freq1 != control_freq - 10)
> +			return false;
> +		if (chandef->center_freq2)
> +			return false;
> +		break;
> +	case NL80211_CHAN_WIDTH_80P80:
> +		if (chandef->center_freq1 != control_freq + 30 &&
> +		    chandef->center_freq1 != control_freq + 10 &&
> +		    chandef->center_freq1 != control_freq - 10 &&
> +		    chandef->center_freq1 != control_freq - 30)
> +			return false;
> +		if (!chandef->center_freq2)
> +			return false;
> +		break;
> +	case NL80211_CHAN_WIDTH_80:
> +		if (chandef->center_freq1 != control_freq + 30 &&
> +		    chandef->center_freq1 != control_freq + 10 &&
> +		    chandef->center_freq1 != control_freq - 10 &&
> +		    chandef->center_freq1 != control_freq - 30)
> +			return false;
> +		if (chandef->center_freq2)
> +			return false;
> +		break;
> +	case NL80211_CHAN_WIDTH_160:
> +		if (chandef->center_freq1 != control_freq + 70 &&
> +		    chandef->center_freq1 != control_freq + 50 &&
> +		    chandef->center_freq1 != control_freq + 30 &&
> +		    chandef->center_freq1 != control_freq + 10 &&
> +		    chandef->center_freq1 != control_freq - 10 &&
> +		    chandef->center_freq1 != control_freq - 30 &&
> +		    chandef->center_freq1 != control_freq - 50 &&
> +		    chandef->center_freq1 != control_freq - 70)
> +			return false;

Should we create a macro instead of +70 to -70 to take care of all 3 
cases 80, 80p80 and 160?

> +		if (chandef->center_freq2)


