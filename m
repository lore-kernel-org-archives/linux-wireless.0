Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52929 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab1CRSGU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 14:06:20 -0400
Received: by iyb26 with SMTP id 26so4242075iyb.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 11:06:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a86de09887dbbf9a5e6d1d1018521a5d@secure.sipsolutions.net>
References: <1300417820-19029-1-git-send-email-lrodriguez@atheros.com>
 <AANLkTi=58JJNoYG7232ykiOnAK2TX18ROxrfYQir3Wwe@mail.gmail.com>
 <20110318135058.GE5103@tuxdriver.com> <AANLkTi=jnL3EO3CDw8KEePnA7+xQZ9JBBDHcPCGsDKD9@mail.gmail.com>
 <AANLkTimHyHuTnHfTddsbtiBL1CdxjJDtoJ7gnuVhxbNQ@mail.gmail.com> <a86de09887dbbf9a5e6d1d1018521a5d@secure.sipsolutions.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 18 Mar 2011 11:05:59 -0700
Message-ID: <AANLkTi=d=vkSmEuTSLz-z7Qw=pN1ATrR7abK_XG2EdVa@mail.gmail.com>
Subject: Re: [RTF] iwmc3200wifi: fix device registration ordering for cfg80211
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Intel Linux Wireless <ilw@linux.intel.com>, gregkh@suse.de,
	linux-wireless@vger.kernel.org, vmehta@atheros.com,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	devel@linuxdriverproject.org, naveen.singh@atheros.com,
	stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 18, 2011 at 11:03 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 18 Mar 2011 10:41:53 -0700, Luis R. Rodriguez wrote:
>>>
>>> On Fri, Mar 18, 2011 at 6:50 AM, John W. Linville
>>>>
>>>> Does anyone even have this hardware?
>
> I don't think it even exists any more.

Can the driver be removed?

>> So similarly here we can likely hit a case where we hit the double
>> wiphy_unregister() twice and I think we'd oops. My preference is to
>> make wiphy_unregister() re-entrant and let us detect when the device
>> already was unregistered. Johannes?
>
> I don't like that, it encourages sloppy driver writing. Seriously,
> why is it so hard to properly write the code?
>
> You can fail during init, or you can properly deregister, and that's
> about it, no?

That's fine too.

  Luis
