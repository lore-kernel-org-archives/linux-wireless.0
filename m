Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45781 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752901AbbC3JPl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2015 05:15:41 -0400
Message-ID: <1427706933.26117.25.camel@sipsolutions.net> (sfid-20150330_111544_377709_50B69919)
Subject: Re: [PATCH] cfg80211: Stop calling crda if it is not responsive
From: Johannes Berg <johannes@sipsolutions.net>
To: Ilan Peer <ilan.peer@intel.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@suse.com
Date: Mon, 30 Mar 2015 11:15:33 +0200
In-Reply-To: <1427609931-6113-1-git-send-email-ilan.peer@intel.com> (sfid-20150329_081902_084943_B4703242)
References: <1427609931-6113-1-git-send-email-ilan.peer@intel.com>
	 (sfid-20150329_081902_084943_B4703242)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-03-29 at 09:18 +0300, Ilan Peer wrote:

> @@ -3113,6 +3128,7 @@ int __init regulatory_init(void)
>  	spin_lock_init(&reg_pending_beacons_lock);
>  	spin_lock_init(&reg_indoor_lock);
>  
> +	reg_crda_timeouts = 0;

Also, this is not necessary as BSS in the kernel is 0-initialized.

johannes

