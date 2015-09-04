Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48508 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752963AbbIDM0C (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Sep 2015 08:26:02 -0400
Message-ID: <1441369560.1971.2.camel@sipsolutions.net> (sfid-20150904_142606_753115_A232E9AF)
Subject: Re: [PATCH] mac80211: protect non-HT BSS when HT TDLS traffic exists
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Avri Altman <avri.altman@intel.com>
Date: Fri, 04 Sep 2015 14:26:00 +0200
In-Reply-To: <1439905927-24620-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1439905927-24620-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-08-18 at 16:52 +0300, Emmanuel Grumbach wrote:
> From: Avri Altman <avri.altman@intel.com>
> 
> HT TDLS traffic should be protected in a non-HT BSS to avoid
> collisions. Therefore, when TDLS peers join/leave, check if
> protection is (now) needed and set the ht_operation_mode of
> the virtual interface according to the HT capabilities of the
> TDLS peer(s).
> 
> This works because a non-HT BSS connection never sets (or
> otherwise uses) the ht_operation_mode; it just means that
> drivers must be aware that this field applies to all HT
> traffic for this virtual interface, not just the traffic
> within the BSS. Document that.
> 
Applied.

johannes
