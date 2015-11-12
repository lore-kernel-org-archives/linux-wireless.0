Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54886 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753668AbbKLVk1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2015 16:40:27 -0500
Message-ID: <1447364413.2131.5.camel@sipsolutions.net> (sfid-20151112_224033_417377_94801D76)
Subject: Re: [PATCH v2] cfg80211: add VHT support for Mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Oh <poh@codeaurora.org>, Peter Oh <poh@qca.qualcomm.com>,
	ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Date: Thu, 12 Nov 2015 22:40:13 +0100
In-Reply-To: <564505A6.9030001@codeaurora.org>
References: <ab294ba62856f00c06dde10b1bf57f5f341a7198.1447351137.git.poh@qca.qualcomm.com>
	 <1447358605.2131.3.camel@sipsolutions.net>
	 <564505A6.9030001@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-11-12 at 13:33 -0800, Peter Oh wrote:
> 
> At this moment Mesh Point is not able to be brought up by userspace
> such 
> as wap_supplicant at VHT data rates because there is no
> events/NL80211 
> defined that userspace can check out if drivers can support Mesh
> Point 
> (802.11s) at VHT data rates or not, hence only HT data rates can be
> used 
> for
> Mesh Point by userspace now.
> This patch is introducing NL80211 event to cover the issue.

No... this patch doesn't introduce an nl80211 event. It introduces a
feature flag, but I'm arguing it's useless.

Look - what's the difference that userspace would do based on this
flag? Clearly, setting the flag in the driver has no effect on kernel
code whatsoever, so your "is not able to be brought up" makes no sense.

Perhaps it'll become clearer once you post the wpa_supplicant code, but
you should still coherently explain in the commit message why this is
necessary. So far, I don't see it, since no kernel code ever depends on
this flag.

johannes
