Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60496 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981AbbIWJRN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2015 05:17:13 -0400
Message-ID: <1442999830.1889.5.camel@sipsolutions.net> (sfid-20150923_111717_167545_7C2FDF28)
Subject: Re: [PATCH] mac80211: don't tear down aggregation on suspend in
 case of wowlan->any
From: Johannes Berg <johannes@sipsolutions.net>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org,
	Eliad Peller <eliadx.peller@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 23 Sep 2015 11:17:10 +0200
In-Reply-To: <1442839826-26242-1-git-send-email-luca@coelho.fi>
References: <1442839826-26242-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-09-21 at 15:50 +0300, Luca Coelho wrote:
> From: Eliad Peller <eliadx.peller@intel.com>
> 
> in case of "any" wowlan trigger, there is no reason to tear down
> aggregations, as we want the device to continue working normally.
> 
> Similarly, there's no reason to tear down aggregations on resume,
> as they should have been torn down on suspend if needed.
> 
> However, since the reconfiguration flow is shared with HW restart,
> tear down aggregations on reconfiguration only when we are not 
> resuming.
> 
> To keep things working after non-wowlan suspend, keep clearing the
> WLAN_STA_BLOCK_BA flag.
> 
Applied.

johannes
