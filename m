Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38876 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932918Ab3ECGlH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 May 2013 02:41:07 -0400
Message-ID: <1367563264.9430.5.camel@jlt4.sipsolutions.net> (sfid-20130503_084112_197918_DCED24AB)
Subject: Re: [PATCH] mac80211: clean up mesh RCU warning
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Date: Fri, 03 May 2013 08:41:04 +0200
In-Reply-To: <1367536279-14241-1-git-send-email-thomas@cozybit.com> (sfid-20130503_011325_779040_E2BD5BC1)
References: <1367536279-14241-1-git-send-email-thomas@cozybit.com>
	 (sfid-20130503_011325_779040_E2BD5BC1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-05-02 at 16:11 -0700, Thomas Pedersen wrote:
> When running a kernel with CONFIG_PROVE_RCU, the minstrel
> rate update code would complain about being called without
> the RCU read lock held. This is because
> mesh_sta_info_init() may or may not have been called under
> RCU read lock. Perform some bureaucratic critical section
> toggling to always call mesh_sta_info_init() under RCU,
> and silence this warning.

This was discussed in another thread a while ago, but unfortunately
nothing came out of it. I really don't think this is the right solution,
since the code that this calls doesn't even use rcu_dereference()
properly.

Felix, please come up with a proper fix soon, otherwise I'm going to
revert your changes for 3.10.

johannes

