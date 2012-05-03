Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39010 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470Ab2ECTjY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 15:39:24 -0400
Message-ID: <1336073962.5167.18.camel@jlt3.sipsolutions.net> (sfid-20120503_213927_315687_D9518930)
Subject: Re: [PATCH v2 2/4] mac80211: Implement HT mixed protection mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Nagarajan <ashok@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	javier@cozybit.com, devel@lists.open80211s.org
Date: Thu, 03 May 2012 21:39:22 +0200
In-Reply-To: <1335820832-18887-2-git-send-email-ashok@cozybit.com> (sfid-20120430_232128_748335_8B027146)
References: <1335820832-18887-1-git-send-email-ashok@cozybit.com>
	 <1335820832-18887-2-git-send-email-ashok@cozybit.com>
	 (sfid-20120430_232128_748335_8B027146)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-04-30 at 14:20 -0700, Ashok Nagarajan wrote:

> +/** mesh_set_ht_prot_mode - set correct HT protection mode

I think you need a newline before the function name, but this isn't
really valid kernel-doc anyway so please just don't use **

> + *
> + * Section 9.23.3.5 of IEEE 80211s standard

There's no 80211s standard. 802.11s is an amendment, please correct the
reference to the -2012 version.

> +	rcu_read_lock();
> +	list_for_each_entry_rcu(sta, &local->sta_list, list) {
> +		if (sdata == sta->sdata &&
> +		    sta->plink_state == NL80211_PLINK_ESTAB) {

there would be less indentation if you'd add a continue for the mismatch
cases :-)

johannes

