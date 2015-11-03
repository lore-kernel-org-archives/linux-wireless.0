Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55458 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752561AbbKCJm3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2015 04:42:29 -0500
Message-ID: <1446543746.29010.9.camel@sipsolutions.net> (sfid-20151103_104822_118643_0FAA7EEA)
Subject: Re: [PATCH 01/10] mac80211: don't reconfigure sched scan in case of
 wowlan
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
	Eliad Peller <eliadx.peller@intel.com>
Date: Tue, 03 Nov 2015 10:42:26 +0100
In-Reply-To: <1445763582-11421-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1445763582-11421-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-10-25 at 10:59 +0200, Emmanuel Grumbach wrote:
> From: Eliad Peller <eliad@wizery.com>
> 
> Scheduled scan has to be reconfigured only if wowlan wasn't
> configured, since otherwise it should continue to run (with
> the 'any' trigger) or be aborted.
> 
> The current code will end up asking the driver to start a new
> scheduled scan without stopping the previous one, and leaking
> some memory (from the previous request.)
> 
> Fix this by doing the abort/restart under the proper conditions.
> 
Applied.

johannes
