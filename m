Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60936 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab3ARVa1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2013 16:30:27 -0500
Message-ID: <1358544641.7922.28.camel@jlt4.sipsolutions.net> (sfid-20130118_223031_690786_A7B7B8AE)
Subject: Re: [PATCH V9 2/2] cfg80211/nl80211: Enable drivers to implement
 MAC address based ACL
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Date: Fri, 18 Jan 2013 22:30:41 +0100
In-Reply-To: <1358488125-6154-2-git-send-email-vthiagar@qca.qualcomm.com>
References: <1358488125-6154-1-git-send-email-vthiagar@qca.qualcomm.com>
	 <1358488125-6154-2-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-01-18 at 11:18 +0530, Vasanthakumar Thiagarajan wrote:

> + * @NL80211_ATTR_ACL_POLICY: ACL policy, see &enum nl80211_acl_policy_attr.
> + *
> + * @NL80211_ATTR_MAC_ADDRS: Array of nested MAC addresses, used for
> + *	MAC ACL.

Ok so one last (not a promise ;-) ) thing ...

You basically completely back-pedalled from wanting to support white &
blacklist at the same time to no longer even allowing that in the API.
Should I really merge this? Who says you're not going to return in a
couple of weeks and want that then, making the API very strange?

Right now, you have it structured like this:

POLICY=u8 value, ADDRS=[1=addr1, 2=addr2, ...]

(= indicates attribute type/value, [] indicates nesting)

I think it might be smarter to do

ACL=[TYPE=addr1|addr2|..., TYPE=addr3|addr4|...]

where "|" just indicates concatenation. I don't really strictly see a
reason to have a new nested attribute for each MAC address, since they
are each just 6 bytes long, for all I care they could be concatenated.
But if you wanted nesting, that would make it look like this:

ACL[TYPE=[1=addr1, 2=addr2, ...], TYPE=[1=addr3, 2=addr4, ...]]

which is acceptable too, just requires more code to parse.


Anyway, if you think that the dual list approach is dead indefinitely, I
guess I can apply it. I'm just not sure I believe that ;-)

johannes

