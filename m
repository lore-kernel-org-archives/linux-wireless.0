Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58757 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753313AbbAFK7Y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 05:59:24 -0500
Message-ID: <1420541961.1966.20.camel@sipsolutions.net> (sfid-20150106_115927_695691_459EB811)
Subject: Re: [PATCH v2 2/2] cfg80211: Schedule timeout for all CRDA calls
From: Johannes Berg <johannes@sipsolutions.net>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@suse.com
Date: Tue, 06 Jan 2015 11:59:21 +0100
In-Reply-To: <1420519942-16109-2-git-send-email-ilan.peer@intel.com> (sfid-20150106_115607_476225_0D1289F9)
References: <1420519942-16109-1-git-send-email-ilan.peer@intel.com>
	 <1420519942-16109-2-git-send-email-ilan.peer@intel.com>
	 (sfid-20150106_115607_476225_0D1289F9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-01-05 at 23:52 -0500, Ilan Peer wrote:
> Timeout was scheduled only in case CRDA was called due to user hints,
> but was not scheduled for other cases. This can result in regulatory
> hint processing getting stuck in case that there is no CRDA configured.

I can understand this part.

> Change this by scheduling a timeout every time CRDA is called. In
> addition, in restore_regulatory_settings() all pending requests are
> restored (and not only the user ones).

Care to explain why, and why this should be in the same patch?

johannes

