Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56667 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754996AbcCCPry (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 10:47:54 -0500
Message-ID: <1457020070.2044.30.camel@sipsolutions.net> (sfid-20160303_164757_071016_472D961E)
Subject: Re: [PATCH] mac80211: synchronize driver rx queues before removing
 a station
From: Johannes Berg <johannes@sipsolutions.net>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org, Sara Sharon <sara.sharon@intel.com>
Date: Thu, 03 Mar 2016 16:47:50 +0100
In-Reply-To: <1456955174-5623-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1456955174-5623-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-03-02 at 23:46 +0200, Emmanuel Grumbach wrote:
> From: Sara Sharon <sara.sharon@intel.com>
> 
> Some devices, like iwlwifi, have RSS queues. This may cause a
> situation where a disassociation is handled in control path and
> results in station removal while there are prior RX frames
> that were still not processed in other queues. When they will
> be processed the station will be gone, and the frames will be
> dropped.
> Add a synchronization interface to avoid that. When driver returns
> from the synchronization mac80211 may remove the station.
> 
Applied.

johannes
