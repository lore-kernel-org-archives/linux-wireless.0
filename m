Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:36191 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751493AbXCWSBs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Mar 2007 14:01:48 -0400
Date: Fri, 23 Mar 2007 18:36:52 +0100
From: Jiri Benc <jbenc@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, Michael Buesch <mb@bu3sch.de>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Prevent unregistering of unregistered hw
Message-ID: <20070323183652.1f472f7e@griffin.suse.cz>
In-Reply-To: <1174559874.3944.83.camel@johannes.berg>
References: <200703091614.04526.IvDoorn@gmail.com>
	<200703091646.05292.mb@bu3sch.de>
	<200703091730.06796.IvDoorn@gmail.com>
	<1174559874.3944.83.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 22 Mar 2007 11:37:54 +0100, Johannes Berg wrote:
> I disagree. In fact, I'd prefer putting
>  BUG_ON(local->reg_state != IEEE80211_DEV_REGISTERED)
> into ieee80211_unregister_hw.

There's a WARN_ON in uregister_netdevice when the device wasn't
previously registered, so I'd agree with Johannes.

 Jiri

-- 
Jiri Benc
SUSE Labs
