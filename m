Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:54337 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbaACVax (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jan 2014 16:30:53 -0500
Message-ID: <508ee22698c0bc2a2387a23158c97e8d.squirrel@www.codeaurora.org> (sfid-20140103_223055_890975_21B76D1A)
Date: Fri, 3 Jan 2014 21:30:52 -0000
Subject: Re: [PATCH 2/2 V3] nl80211/cfg80211: Enable station PMF requirement
 to be specified to driver with AP SME
From: clanctot@codeaurora.org
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: "Chet Lanctot" <clanctot@codeaurora.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

Thanks for your comments regarding these changes.  See my responses below.

-	Chet

> On Tue, 2013-12-10 at 14:11 -0800, Chet Lanctot wrote:
>> +	if (info->attrs[NL80211_ATTR_USE_MFP]) {
>> +		params.mfp = nla_get_u32(info->attrs[NL80211_ATTR_USE_MFP]); +		if
(params.mfp != NL80211_MFP_REQUIRED &&
>> +		    params.mfp != NL80211_MFP_OPTIONAL &&
>> +		    params.mfp != NL80211_MFP_NO)
>> +			return -EINVAL;
>> +	} else
>> +		params.mfp = NL80211_MFP_NO;
> Code style.
> Wouldn't a feature flag be needed?
> johannes

For the issue of code style, I am not sure what you mean here.  I copied
this code from the nl80211_connect routine, which has similar processing
for a “use MFP” parameter.  I tried to make the code I added be consistent
with this existing code.

If you explain what needs to be changed to improve the code style, I will
make the changes.

Regarding your question about a feature flag, there is already a  flag
that indicates that the driver implements the AP SME:
     * @WIPHY_FLAG_HAVE_AP_SME: device integrates AP SME
Is this the type of flag you were referring to?

I am ready to respond to any follow-on comments you have for this section
of code.





