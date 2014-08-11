Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:56373 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831AbaHKO5K (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2014 10:57:10 -0400
Message-ID: <1407769025.9844.0.camel@jlt4.sipsolutions.net> (sfid-20140811_165714_246062_B5EBBABA)
Subject: Re: [PATCH] cfg80211: remove @gfp parameter from cfg80211_rx_mgmt()
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 11 Aug 2014 16:57:05 +0200
In-Reply-To: <1407752997-12382-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1407752997-12382-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-08-11 at 03:29 -0700, Vladimir Kondratiev wrote:
> In the cfg80211_rx_mgmt(), parameter @gfp was used for the memory allocation.
> But, memory get allocated under spin_lock_bh(), this implies atomic context.
> So, one can't use GFP_KERNEL, only variants with no __GFP_WAIT. Actually, in all
> occurrences GFP_ATOMIC is used (wil6210 use GFP_KERNEL by mistake),
> and it should be this way or warning triggered in the memory allocation code.
> 
> Remove @gfp parameter as no actual choice exist, and use hard coded
> GFP_ATOMIC for memory allocation.

Applied, thanks.

johannes

