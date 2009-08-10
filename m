Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:31786 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754545AbZHJBmn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Aug 2009 21:42:43 -0400
Subject: Re: [PATCH] cfg80211: Set WEP ciphers
From: Zhu Yi <yi.zhu@intel.com>
To: Dan Williams <dcbw@redhat.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1249680982.26088.48.camel@localhost.localdomain>
References: <20090806190439.GA22647@sortiz.org>
	 <1249680982.26088.48.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 10 Aug 2009 09:42:38 +0800
Message-Id: <1249868558.3967.32.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2009-08-08 at 05:36 +0800, Dan Williams wrote:
> If you're talking about static WEP, then the ciphers are determined by
> the WEP keys that have been set with iwconfig, and you determine
> WEP40/WEP104 based on the length of the current WEP TX index.

Exactly. But we need to pass this cipher info to the connect API anyway.
With cfg80211 key rework [1], driver's add_key callback won't be called
until it is associated. If driver needs the cipher info for association,
passing it to the connect API is the only choice.

Thanks,
-yi

1. http://marc.info/?l=linux-wireless&m=124705584228953&w=2

