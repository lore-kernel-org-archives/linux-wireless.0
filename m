Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:54684 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758402Ab3K0XQE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Nov 2013 18:16:04 -0500
Message-ID: <0db5ff864c71203a67854092705eca0f.squirrel@www.codeaurora.org> (sfid-20131128_001609_331437_D7353FD6)
In-Reply-To: <1380194160.14806.3.camel@jlt4.sipsolutions.net>
References: <1379446296-22236-1-git-send-email-clanctot@codeaurora.org>
    <1379446296-22236-3-git-send-email-clanctot@codeaurora.org>
    <1380194160.14806.3.camel@jlt4.sipsolutions.net>
Date: Wed, 27 Nov 2013 23:16:03 -0000
Subject: Re: [PATCH 2/2] nl80211/cfg80211: PMF Requirement communicated to
 driver with AP SME
From: clanctot@codeaurora.org
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: "Chet Lanctot" <clanctot@codeaurora.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Tue, 2013-09-17 at 12:31 -0700, Chet Lanctot wrote:
>> Needed for drivers that have AP SME integrated.  Whether PMF (Protected
>> Management Frames, 802.11w) should be used for station connections
>> is communicated from upper layer software through nl80211/cfg80211.
>
> This is a bit unclear, what's expected of the driver?
>

Johannes,

Thank you for your feedback.

I will expand the commit text to make it clearer that is expected of the
driver.

>
>> +	if (info->attrs[NL80211_ATTR_USE_MFP]) {
>> +		params.mfp = nla_get_u32(info->attrs[NL80211_ATTR_USE_MFP]);
>> +		if (params.mfp != NL80211_MFP_REQUIRED &&
>> +		    params.mfp != NL80211_MFP_OPTIONAL &&
>> +		    params.mfp != NL80211_MFP_NO)
>> +			return -EINVAL;
>> +	} else
>> +		params.mfp = NL80211_MFP_NO;
>> +
>
> checkpatch.
>
> johannes
>
>


