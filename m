Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47683 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab2K2MS1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2012 07:18:27 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Te34U-0006Ki-G8
	for linux-wireless@vger.kernel.org; Thu, 29 Nov 2012 13:18:26 +0100
Message-ID: <1354191531.9557.3.camel@jlt4.sipsolutions.net> (sfid-20121129_131830_987906_42A77BDC)
Subject: Re: [RFC] cfg80211: fix BSS struct IE access races
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 29 Nov 2012 13:18:51 +0100
In-Reply-To: <1354148804-26678-1-git-send-email-johannes@sipsolutions.net> (sfid-20121129_012627_328755_CFFDFE23)
References: <1354148804-26678-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20121129_012627_328755_CFFDFE23)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-11-29 at 01:26 +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> When a BSS struct is updated, the IEs are currently
> overwritten or freed. This can lead to races if some
> other CPU is accessing the BSS struct and using the
> IEs concurrently.
> 
> Fix this by always allocating the IEs in a new struct
> that holds the data and length and protecting access
> to this new struct with RCU.

Eliad pointed out to me that the mac80211 code will call
kmalloc(GFP_KERNEL) inside the rcu critical section, which isn't
allowed. So instead of changing that to GFP_ATOMIC or something, I just
posted two patches to remove the allocation :-)

johannes

