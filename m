Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:44085 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754178AbXDRSbv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2007 14:31:51 -0400
Date: Wed, 18 Apr 2007 20:31:51 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: rx racing against removing interfaces?
Message-ID: <20070418203151.30f32933@griffin.suse.cz>
In-Reply-To: <1174950322.25887.59.camel@johannes.berg>
References: <1174950322.25887.59.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 27 Mar 2007 01:05:22 +0200, Johannes Berg wrote:
> Isn't there a race there when you remove interfaces and at the same time
> __ieee80211_rx is running? I don't see anything that should stop that,
> and if it happens we'll probably blow up pretty spectacularly with
> accesses to a freed netdev, or even sending it frames...

Yes, there is a race.

- sta_info should be holding a reference to a net_device in its dev
  field (sta_info_add).
- walking through the local->sub_if_list in __ieee80211_rx should
  happen under a lock
- while invoking rx handlers in the list_for_each_entry loop (they
  shouldn't be called under the lock above - hm, another thing that
  makes locking in mac80211 hard) we should hold a reference to the
  appropriate net_device

 Jiri

-- 
Jiri Benc
SUSE Labs
