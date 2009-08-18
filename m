Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:64332 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753889AbZHRBeD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 21:34:03 -0400
Subject: Re: [PATCH] cfg80211: report userspace SME connected event properly
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1250504534.15103.0.camel@johannes.local>
References: <1250504534.15103.0.camel@johannes.local>
Content-Type: text/plain
Date: Tue, 18 Aug 2009 09:34:03 +0800
Message-Id: <1250559243.9651.41.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-08-17 at 18:22 +0800, Johannes Berg wrote:
> Instead of hacking the event reporting into the
> __cfg80211_connect_result() function which is also
> invoked by others, set up things correctly and then
> invoke that function, so that it can do more sanity
> checking.
> 
> Also, it is currently not possible to get a ROAMED
> event from the userspace SME anyway since we send
> out a DISCONNECTED event when it disassociates and
> then a new CONNECTED event on the next association.
> 
> Thanks to Zhu Yi for pointing out that the code is
> somewhat convoluted and doesn't warn when it should.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

This makes it clear cfg80211_connect_result() shouldn't be called in !
CFG80211_SME_CONNECTING state. Thanks!

-yi

