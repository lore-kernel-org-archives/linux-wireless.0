Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751937Ab3B0Kmi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Feb 2013 05:42:38 -0500
Date: Wed, 27 Feb 2013 11:42:48 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: Re: [PATCH 2/6] mac80211: sync suspend and stop interface
Message-ID: <20130227104247.GA3016@redhat.com> (sfid-20130227_114241_816588_28ABA445)
References: <1361793008-2857-1-git-send-email-sgruszka@redhat.com>
 <1361793008-2857-2-git-send-email-sgruszka@redhat.com>
 <1361911440.8440.12.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1361911440.8440.12.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 26, 2013 at 09:44:00PM +0100, Johannes Berg wrote:
> More generally, does this really make much sense? There are other things
> here, e.g. ieee80211_configure_filter(), ieee80211_recalc_ps(),
> ieee80211_hw_config() and probably more that can be executed in this
> function -- I don't think protecting these two calls is really
> sufficient?

Seems all other drv calls like those on ieee80211_confgure_fitler() do
not require sdata. So this is most likely sufficient. I'm able to
reporduce warnings on rt2x00 usb with commit 
761ce8c41ed20ee3af77f2df527edc3f92e6f3bf reverted. This patch make
them gone.

Stanislaw

