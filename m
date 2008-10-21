Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:23867 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbYJUEIZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Oct 2008 00:08:25 -0400
Subject: Re: [PATCH v3] mac80211/drivers: rewrite the rate control API
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <1224486587.18024.25.camel@johannes.berg>
References: <1223996147.10113.33.camel@johannes.berg>
	 (sfid-20081014_165703_092655_BE6BA58D) <1224052607.3027.20.camel@johannes.berg>
	 <1224484940.24677.169.camel@debian.sh.intel.com>
	 <1224485319.18024.9.camel@johannes.berg>
	 <1224486368.24677.184.camel@debian.sh.intel.com>
	 <1224486587.18024.25.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 21 Oct 2008 12:07:52 +0800
Message-Id: <1224562072.24677.277.camel@debian.sh.intel.com> (sfid-20081021_060829_317747_7E3F9FB7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-10-20 at 01:09 -0600, Johannes Berg wrote:
> It would be good to actually report as accurate as possible (up to
> MAX_RATES) the retries the firmware will have done. We're going to
> export that information to userland in radiotap too.

The max retry rates number for iwl4965 is 16. See iwl-commands.h for
more details:

a) Use the initial rate for only one entry.
b) For each following entry, reduce the rate to next lower available
   rate, until reaching the lowest available rate.
c) When reducing rate, also switch antenna selection.
d) Once lowest available rate is reached, repeat this rate until
   rate table is filled (16 entries), switching antenna each entry.

Thanks,
-yi

