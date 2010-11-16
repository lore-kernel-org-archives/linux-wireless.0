Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58262 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756298Ab0KPSG5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 13:06:57 -0500
Subject: Re: [PATCH] mac80211:  Fix deadlock in ieee80211_do_stop.
From: Johannes Berg <johannes@sipsolutions.net>
To: Tejun Heo <tj@kernel.org>
Cc: Ben Greear <greearb@candelatech.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4CE292F7.4090200@kernel.org>
References: <1289592426-5367-1-git-send-email-greearb@candelatech.com>
	 <1289594998.3736.11.camel@jlt3.sipsolutions.net>
	 <4CDDAA3B.9090007@candelatech.com>
	 <1289596096.3736.13.camel@jlt3.sipsolutions.net>
	 <4CDE699B.70401@kernel.org> <4CE1A344.7040201@candelatech.com>
	 <4CE292F7.4090200@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 09:40:58 -0800
Message-ID: <1289929258.3673.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-11-16 at 15:19 +0100, Tejun Heo wrote:

> 3. What if you replace it with the following?
> 
>    alloc_workqueue(wiphy_name(local->hw.wiphy), WQ_NON_REENTRANT, 0)

Wait ... what's the difference between this and
alloc_ordered_workqueue() then?

johannes

