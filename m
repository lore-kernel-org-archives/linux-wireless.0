Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www17.your-server.de ([213.133.104.17]:43760 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab0HFPym (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Aug 2010 11:54:42 -0400
From: Thomas Meyer <thomas@m3y3r.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 2.6.36] iwlwifi: fix locking assertions
Date: Fri, 6 Aug 2010 17:12:44 +0200
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	"Wey-Yi W Guy" <wey-yi.w.guy@intel.com>,
	"Zhao, Shanyu" <shanyu.zhao@intel.com>
References: <1281104273.3853.504.camel@jlt3.sipsolutions.net>
In-Reply-To: <1281104273.3853.504.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201008061712.44561.thomas@m3y3r.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 06 August 2010 16:17:53 Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> spin_is_locked() can return zero on some (UP?)

Yes, this is an UP config.

> configurations because locks don't exist, and
> that causes an endless amount of warnings. Use
> lockdep_assert_held() instead, which has two
> advantages:
>  1) it verifies the current task is holding
>     the lock or mutex
>  2) it compiles away completely when lockdep
>     is not enabled
> 

After applying your patch the warnings in the kernel log are gone.

Thanks for the quick fix.

kind regards
thomas

