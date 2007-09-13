Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:2645 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752022AbXIMIFK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Sep 2007 04:05:10 -0400
Subject: Re: [PATCH V4 wireless-dev#pending-upstream] Add iwlwifi wireless   drivers
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"John W.Linville" <linville@tuxdriver.com>
In-Reply-To: <1189626304.6161.55.camel@johannes.berg>
References: <1189582835.24707.118.camel@debian.sh.intel.com>
	 <1189626304.6161.55.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 13 Sep 2007 15:58:08 +0800
Message-Id: <1189670288.18944.20.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2007-09-12 at 21:45 +0200, Johannes Berg wrote:
> Did you change those to subsys_initcall? I can't check right now
> (offline), but it's required for proper operation when built-in, or
> you need to rely on link order to have the rate control initialised
> earlier than the drivers. 

No, this won't happen because the current iwlwifi driver can only be
compiled as module. This was mainly caused by the split of the 3945 and
4965 code base (both of them define some same functions). We plan to
abstract a core layer for all the iwlwifi based drivers, so the problem
will be solved well. But that is targeted on .25.

Thanks,
-yi
