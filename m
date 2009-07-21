Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:29709 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753061AbZGUBWQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jul 2009 21:22:16 -0400
Subject: Re: [PATCH 3/5] iwmc3200wifi: use cfg80211_connect_result to send
 req/resp IE
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1248086241.14765.1.camel@johannes.local>
References: <1248061667-8614-1-git-send-email-yi.zhu@intel.com>
	 <1248061667-8614-2-git-send-email-yi.zhu@intel.com>
	 <1248061667-8614-3-git-send-email-yi.zhu@intel.com>
	 <1248061667-8614-4-git-send-email-yi.zhu@intel.com>
	 <1248086241.14765.1.camel@johannes.local>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 09:22:14 +0800
Message-Id: <1248139334.3747.22.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-07-20 at 18:37 +0800, Johannes Berg wrote:
> On Mon, 2009-07-20 at 11:47 +0800, Zhu Yi wrote:
> > cfg80211_connect_result() let us specify associate request and
> > response IEs as parameters after we are connected. We use this
> > capability instead of doing it ourselves with WEXT.
> 
> I think with this, you can now remove
> 
>         select WIRELESS_EXT
> 
> from your Kconfig.

Um, not yet. I need to assign the netdev->wireless_handlers to
&iwm_iw_handler_def. The former is ifdef-ed CONFIG_WIRELESS_EXT in
struct net_device. I think this can be done until cdg80211 provides a
generic iw_handler.

Thanks,
-yi

