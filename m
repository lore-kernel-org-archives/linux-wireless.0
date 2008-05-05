Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:7450 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679AbYEEIyi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2008 04:54:38 -0400
Subject: Re: [PATCH 20/25] iwlwifi : Set monitor mode for 4965
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>
In-Reply-To: <1209976096.3655.19.camel@johannes.berg>
References: <1209954172-3092-1-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-2-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-3-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-4-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-5-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-6-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-7-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-8-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-9-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-10-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-11-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-12-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-13-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-14-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-15-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-16-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-17-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-18-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-19-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-20-git-send-email-yi.zhu@intel.com>
	 <1209954172-3092-21-git-send-email-yi.zhu@intel.com>
	 (sfid-20080505_044417_821018_3824BECA)  <1209971503.3655.0.camel@johannes.berg>
	 <1209974740.2827.124.camel@debian.sh.intel.com>
	 <1209976096.3655.19.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 05 May 2008 16:53:18 +0800
Message-Id: <1209977598.2827.134.camel@debian.sh.intel.com> (sfid-20080505_105359_547082_B48AABEA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-05-05 at 10:28 +0200, Johannes Berg wrote:

> but I still don't think you should treat monitors as a "mode" but
> rather as a reason to pass more frames up.

The thing is the firmware treats it as a different mode. For 4965, we
explicitly setup the "sniffer" type to the firmware so that it operates
differently with other modes. Some drivers (i.e ipw2200) have separated
firmware images for bss, ibss and monitor modes.

> > > In the case of the latter, that is
> > > a good thing, in the case of the former that isn't.
> > 
> > Could you elaborate?
> 
> You're precluding doing any kind of useful monitor operation when the
> card is actually up&running, which is quite useful for debugging.
> 
> By the second condition, you're short-cutting the RX path so that when
> a monitor is enabled any other type of interface won't operation
> properly, as far as I can tell.

Yup. I don't think we can support STA mode while at the same time
receive frames to the other hosts.

Thanks,
-yi

