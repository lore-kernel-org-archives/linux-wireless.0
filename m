Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59657 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757074Ab1CRRmN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 13:42:13 -0400
Received: by iwn34 with SMTP id 34so4217338iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 10:42:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=jnL3EO3CDw8KEePnA7+xQZ9JBBDHcPCGsDKD9@mail.gmail.com>
References: <1300417820-19029-1-git-send-email-lrodriguez@atheros.com>
 <AANLkTi=58JJNoYG7232ykiOnAK2TX18ROxrfYQir3Wwe@mail.gmail.com>
 <20110318135058.GE5103@tuxdriver.com> <AANLkTi=jnL3EO3CDw8KEePnA7+xQZ9JBBDHcPCGsDKD9@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 18 Mar 2011 10:41:53 -0700
Message-ID: <AANLkTimHyHuTnHfTddsbtiBL1CdxjJDtoJ7gnuVhxbNQ@mail.gmail.com>
Subject: Re: [RTF] iwmc3200wifi: fix device registration ordering for cfg80211
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Intel Linux Wireless <ilw@linux.intel.com>, gregkh@suse.de,
	linux-wireless@vger.kernel.org, vmehta@atheros.com,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	devel@linuxdriverproject.org, naveen.singh@atheros.com,
	stable@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Fri, Mar 18, 2011 at 6:50 AM, John W. Linville
>> Does anyone even have this hardware?

So similarly here we can likely hit a case where we hit the double
wiphy_unregister() twice and I think we'd oops. My preference is to
make wiphy_unregister() re-entrant and let us detect when the device
already was unregistered. Johannes?

  Luis
