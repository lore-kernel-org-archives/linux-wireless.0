Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56408 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089AbcCCPHE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2016 10:07:04 -0500
Message-ID: <1457017621.2044.17.camel@sipsolutions.net> (sfid-20160303_160717_834455_9D34B9E6)
Subject: Re: [PATCH v2 2/2] mac80211: minstrel_ht: set A-MSDU tx limits
 based on selected max_prob_rate
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Cc: egrumbach@gmail.com
Date: Thu, 03 Mar 2016 16:07:01 +0100
In-Reply-To: <56D85246.8070306@openwrt.org>
References: <1456306140-78485-1-git-send-email-nbd@openwrt.org>
	 <1456306140-78485-2-git-send-email-nbd@openwrt.org>
	 <1457016949.2044.12.camel@sipsolutions.net> <56D85246.8070306@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-03-03 at 16:03 +0100, Felix Fietkau wrote:
> 
> > This isn't *quite* right, since you have to take an 802.11 header
> > (vs.
> > an ethernet header) into account, I think?
> It's only a rough approximation anyway to prevent very large A-MSDUs
> from being created with low rates.
> 

Right, but it seemed like the intent was to allow two full-MTU sized
frames to be combined, which this doesn't.

johannes
