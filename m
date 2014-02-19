Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:47318 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921AbaBSQYS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 11:24:18 -0500
Received: by mail-pa0-f47.google.com with SMTP id kp14so597350pab.34
        for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 08:24:18 -0800 (PST)
Date: Wed, 19 Feb 2014 08:24:13 -0800
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v4 3/5] cfg80211: Enable GO operation on additional
 channels
Message-ID: <20140219162410.GK14296@garbanzo.do-not-panic.com> (sfid-20140219_172422_367572_C2421136)
References: <1392824377-18254-1-git-send-email-ilan.peer@intel.com>
 <1392824377-18254-4-git-send-email-ilan.peer@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1392824377-18254-4-git-send-email-ilan.peer@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 19, 2014 at 05:39:35PM +0200, Ilan Peer wrote:
> Allow GO operation on a channel marked with IEEE80211_CHAN_GO_CONCURRENT
> iff there is an active station interface that is associated to
> an AP operating on the same channel in the 2 GHz band or the same UNII band
> (in the 5 GHz band). This relaxation is not allowed if the channel is
> marked with IEEE80211_CHAN_RADAR.
> 
> Note that this is a permissive approach to the FCC definitions,
> that require a clear assessment that the device operating the AP is
> an authorized master, i.e., with radar detection and DFS capabilities.

Come to think of it, do we want to make this an FCC specific thing
only? If so then the dfs_region could be checked prior to enablement.
If the premise is that we'd trust to be associated to a non-GO type
AP, that is a real AP, then we could likely consider a requirement
that this real AP would be using a country IE as well. Please consider
this.

Looks good otherwise.

  Luis
