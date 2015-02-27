Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:58075 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752247AbbB0Tzf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2015 14:55:35 -0500
Date: Fri, 27 Feb 2015 21:55:31 +0200
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] mac80211: simplify station assignment in
 ieee80211_tx_prepare()
Message-ID: <20150227195531.GA8251@w1.fi> (sfid-20150227_205538_744042_B8A1EDB6)
References: <1424734438-18209-1-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1424734438-18209-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 24, 2015 at 12:33:58AM +0100, Johannes Berg wrote:
> There's no need for the second conditional as the same will be
> done immediately afterwards if there's no station assigned.
> 
> Remove the useless conditional, move fallback assignment into
> the else branch and don't try to look up a multicast address
> which cannot be found anyway.

It looks like this breaks ap_vlan_* hwsim test cases. Found by git
bisect on current wireless-testing, confirmed by reverting this on top
of the current master branch.

-- 
Jouni Malinen                                            PGP id EFC895FA
