Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37945 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964992AbaCSOGw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2014 10:06:52 -0400
Message-ID: <1395238008.4142.15.camel@jlt4.sipsolutions.net> (sfid-20140319_150658_010472_868B812B)
Subject: Re: [PATCH] mac80211: protect AP VLAN list with local->mtx
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Mar 2014 15:06:48 +0100
In-Reply-To: <1394021648-22605-1-git-send-email-michal.kazior@tieto.com> (sfid-20140305_131926_105353_E2E99219)
References: <1394021648-22605-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20140305_131926_105353_E2E99219)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-03-05 at 13:14 +0100, Michal Kazior wrote:
> It was impossible to change chanctx of master AP
> for AP VLANs because the copy function requires
> RTNL which can't be simply taken in mac80211 code
> due to possible deadlocks.
> 
> This is required for future chanctx reservation
> that re-bind vifs to new chanctx. This requires
> safe AP VLAN iteration without RTNL.
> 
> Now VLANs can be iterated while holding either
> RTNL or local->mtx because the list is modified
> while holding both of these locks.

No objection really, but maybe it would make more sense to use
iflist_mtx?

johannes

