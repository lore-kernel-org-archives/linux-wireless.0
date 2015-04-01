Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57370 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741AbbDAIvR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Apr 2015 04:51:17 -0400
Message-ID: <1427878274.3428.2.camel@sipsolutions.net> (sfid-20150401_105121_833610_516D9922)
Subject: Re: [PATCH v2] cfg80211: Stop calling crda if it is not responsive
From: Johannes Berg <johannes@sipsolutions.net>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@suse.com
Date: Wed, 01 Apr 2015 10:51:14 +0200
In-Reply-To: <1427717749-27225-1-git-send-email-ilan.peer@intel.com> (sfid-20150330_141354_463006_F82C75ED)
References: <1427717749-27225-1-git-send-email-ilan.peer@intel.com>
	 (sfid-20150330_141354_463006_F82C75ED)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-03-30 at 15:15 +0300, Ilan Peer wrote:
> Patch eeca9fce1d71a4955855ceb0c3b13c1eb9db27c1 (cfg80211: Schedule
> timeout for all CRDA call) introduced a regression, where in case
> that crda is not installed (or not configured properly etc.), the
> regulatory core will needlessly continue to call it, polluting the
> log with the following log:
> 
> "cfg80211: Calling CRDA to update world regulatory domain"
> 
> Fix this by limiting the number of continuous CRDA request failures.

Applied, but I put the condition in a place before printing more
messages, and changed the messages back to the original ones.

johannes

