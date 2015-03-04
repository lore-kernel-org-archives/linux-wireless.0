Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59952 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759208AbbCDJey (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2015 04:34:54 -0500
Message-ID: <1425461691.1810.5.camel@sipsolutions.net> (sfid-20150304_103459_330965_6C119033)
Subject: Re: [PATCH 06/16] mac80211: tell drivers the user TX power
 restriction
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Avri Altman <avri.altman@intel.com>
Date: Wed, 04 Mar 2015 10:34:51 +0100
In-Reply-To: <1425193815-17785-7-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_081046_434588_D9AF83D5)
References: <1425193815-17785-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1425193815-17785-7-git-send-email-emmanuel.grumbach@intel.com>
	 (sfid-20150301_081046_434588_D9AF83D5)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-03-01 at 09:10 +0200, Emmanuel Grumbach wrote:
> From: Avri Altman <avri.altman@intel.com>
> 
> Allow drivers to obtain the user's TX power restrictions in
> order to be able to  apply it properly on (for example)
> hardware scanning which operations on a set of channels,
> in which case mac80211 cannot properly apply the per-channel
> regulatory limits, and the currently exposed txpower value,
> which is the minimum  of the user setting, channel regulatory
> and possible 11h AP reduction isn't  appropriate to use
> since scanning is done on many channels.
> 
> Note that drivers need to be careful when using this value
> and must ensure that  regulatory is maintained, i.e. the
> new value cannot be used as-is.

Actually, given that it looks like this conflicts with other things
we're doing, we're probably going to find another approach. I'll drop
this for now from my tree.

johannes

