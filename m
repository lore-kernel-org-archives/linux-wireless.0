Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48073 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab2FDGNk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2012 02:13:40 -0400
Message-ID: <1338790417.4512.0.camel@jlt3.sipsolutions.net> (sfid-20120604_081418_835258_51AFB2F3)
Subject: Re: [PATCH] mac80211: don't call drv_ampdu_action() during reconfig
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 04 Jun 2012 08:13:37 +0200
In-Reply-To: <1338755341-13141-1-git-send-email-arik@wizery.com> (sfid-20120603_222938_747172_0AC3AE01)
References: <1338755341-13141-1-git-send-email-arik@wizery.com>
	 (sfid-20120603_222938_747172_0AC3AE01)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-06-03 at 23:29 +0300, Arik Nemtsov wrote:
> When tearing down BA sessions during HW reconfig, the low level driver
> is not aware of them yet. Add a parameter to relevant Rx/Tx BA functions
> to prevent calls to the driver, while removing all mac80211 related state.

I think iwlwifi uses the callback, even during restart, to clean up
hardware state, so this might break it.

johannes


