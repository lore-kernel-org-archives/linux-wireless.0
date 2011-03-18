Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37156 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab1CRSEJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 14:04:09 -0400
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [RTF] iwmc3200wifi: fix device registration ordering for cfg80211
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Date: Fri, 18 Mar 2011 20:03:59 +0200
From: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Intel Linux Wireless <ilw@linux.intel.com>, <gregkh@suse.de>,
	<linux-wireless@vger.kernel.org>, <vmehta@atheros.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	<devel@linuxdriverproject.org>, <naveen.singh@atheros.com>,
	<stable@kernel.org>
In-Reply-To: <AANLkTimHyHuTnHfTddsbtiBL1CdxjJDtoJ7gnuVhxbNQ@mail.gmail.com>
References: <1300417820-19029-1-git-send-email-lrodriguez@atheros.com>
 <AANLkTi=58JJNoYG7232ykiOnAK2TX18ROxrfYQir3Wwe@mail.gmail.com>
 <20110318135058.GE5103@tuxdriver.com>
 <AANLkTi=jnL3EO3CDw8KEePnA7+xQZ9JBBDHcPCGsDKD9@mail.gmail.com>
 <AANLkTimHyHuTnHfTddsbtiBL1CdxjJDtoJ7gnuVhxbNQ@mail.gmail.com>
Message-ID: <a86de09887dbbf9a5e6d1d1018521a5d@secure.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 On Fri, 18 Mar 2011 10:41:53 -0700, Luis R. Rodriguez wrote:
>> On Fri, Mar 18, 2011 at 6:50 AM, John W. Linville
>>> Does anyone even have this hardware?

 I don't think it even exists any more.

> So similarly here we can likely hit a case where we hit the double
> wiphy_unregister() twice and I think we'd oops. My preference is to
> make wiphy_unregister() re-entrant and let us detect when the device
> already was unregistered. Johannes?

 I don't like that, it encourages sloppy driver writing. Seriously,
 why is it so hard to properly write the code?

 You can fail during init, or you can properly deregister, and that's
 about it, no?

 johannes

