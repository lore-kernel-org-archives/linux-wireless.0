Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39637 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754491Ab3KLJot (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 04:44:49 -0500
Message-ID: <1384249482.14301.5.camel@jlt4.sipsolutions.net> (sfid-20131112_104501_255075_8B5A4D5E)
Subject: Re: [PATCH] mac80211_hwsim: Fix bcn_en_iter to use atomic iteration
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 12 Nov 2013 10:44:42 +0100
In-Reply-To: <20131106100630.GA32033@jouni.qca.qualcomm.com>
References: <20131106100630.GA32033@jouni.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-11-06 at 12:06 +0200, Jouni Malinen wrote:
> 'mac80211_hwsim: Fix tracking of beaconing for multi-vif' introduced an
> iteration of active interfaces into the bss_info_changed handler.
> However, it used a wrong type of iteration and could result in a dead
> lock since iflist_mtx can already be held. Fix this by using the atomic
> version of the iteration function.

Applied. Since I have to rebase the tree anyway, I've put it into
mac80211-next for now.

johannes

