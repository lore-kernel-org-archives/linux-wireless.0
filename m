Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59752 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074AbaATK3h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 05:29:37 -0500
Message-ID: <1390213774.4335.3.camel@jlt4.sipsolutions.net> (sfid-20140120_112940_829640_B7C349F3)
Subject: Re: [PATCH] cfg80211: fix few minor issues in reg_process_hint()
From: Johannes Berg <johannes@sipsolutions.net>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 20 Jan 2014 11:29:34 +0100
In-Reply-To: <1389705443-23410-1-git-send-email-ilan.peer@intel.com> (sfid-20140114_141537_791569_4F9CE0C3)
References: <1389705443-23410-1-git-send-email-ilan.peer@intel.com>
	 (sfid-20140114_141537_791569_4F9CE0C3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-01-14 at 15:17 +0200, Ilan Peer wrote:
> Fix the following issues in reg_process_hint():
> 
> 1. Add verification that wiphy is valid before processing
>    NL80211_REGDOMAIN_SET_BY_COUNTRY_IE.
> 2. Free the request in case of invalid initiator.
> 3. Remove WARN_ON check on reg_request->alpha2 as it is not a
>    pointer.

Applied.

It's not clear to me that we don't leak anywhere else, and that the
wiphy_update_regulatory() call can't be a use-after-free?

johannes

