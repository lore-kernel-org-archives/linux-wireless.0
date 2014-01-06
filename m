Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43298 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754993AbaAFQkJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 11:40:09 -0500
Message-ID: <1389026403.5891.36.camel@jlt4.sipsolutions.net> (sfid-20140106_174106_598099_5F7D567D)
Subject: Re: [PATCH 2/2 V3] nl80211/cfg80211: Enable station PMF requirement
 to be specified to driver with AP SME
From: Johannes Berg <johannes@sipsolutions.net>
To: clanctot@codeaurora.org
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Mon, 06 Jan 2014 17:40:03 +0100
In-Reply-To: <508ee22698c0bc2a2387a23158c97e8d.squirrel@www.codeaurora.org>
References: <508ee22698c0bc2a2387a23158c97e8d.squirrel@www.codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-01-03 at 21:30 +0000, clanctot@codeaurora.org wrote:

> >> +	} else
> >> +		params.mfp = NL80211_MFP_NO;
> > Code style.

> For the issue of code style, I am not sure what you mean here.  I copied
> this code from the nl80211_connect routine, which has similar processing
> for a “use MFP” parameter.  I tried to make the code I added be consistent
> with this existing code.
> 
> If you explain what needs to be changed to improve the code style, I will
> make the changes.

All branches should (now) have braces if one of them requires it.

> Regarding your question about a feature flag, there is already a  flag
> that indicates that the driver implements the AP SME:
>      * @WIPHY_FLAG_HAVE_AP_SME: device integrates AP SME
> Is this the type of flag you were referring to?

Yes, but it seems to me that you need a flag in the nl80211 API
indicating that the AP SME supports PMF in this way.

johannes

