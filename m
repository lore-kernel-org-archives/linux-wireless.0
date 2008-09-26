Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:12207 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbYIZF2s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 01:28:48 -0400
Subject: Re: [PATCH] iwl3945: added channel sysfs entry
From: Zhu Yi <yi.zhu@intel.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	Dan Williams <dcbw@redhat.com>
In-Reply-To: <43e72e890809252113h624a8d91jd859935ae5afed10@mail.gmail.com>
References: <1222235866-19805-1-git-send-email-yi.zhu@intel.com>
	 <1222245882.18015.62.camel@johannes.berg>
	 <1222328058.2510.470.camel@debian.sh.intel.com>
	 <1222334592.10563.59.camel@johannes.berg>
	 <1222401242.2510.519.camel@debian.sh.intel.com>
	 <43e72e890809252113h624a8d91jd859935ae5afed10@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 26 Sep 2008 13:28:04 +0800
Message-Id: <1222406884.2510.534.camel@debian.sh.intel.com> (sfid-20080926_072852_683588_EA7F9E41)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-09-25 at 21:13 -0700, Luis R. Rodriguez wrote:
> CONFIG_WIRELESS_OLD_REGULATORY is a temporary solution, the right
> solution for you is to build the regulatory domain with the provided
> API as discussed at OLS. Additionally distributions can start picking
> up iw and crda. I can also see NetworkManager asking the kernel to set
> the regulatory domain just as with iw, based on the user's defined
> country somewhere.

You brought it up. And I also want to discuss it. We do want to support
it. But the 3945/4965/5000 hardwares doesn't have the alpha2 information
in their EEPROMs (btw, 2100/2200 does support that). Instead, they have
a band/channel table including freq, tx power, etc in the EEPROM. So a
simple regulatory_hint() API doesn't work. We need a way to export the
channel details to CRDA.

Thanks,
-yi

