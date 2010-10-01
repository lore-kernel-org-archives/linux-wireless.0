Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53385 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab0JAQLp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Oct 2010 12:11:45 -0400
Subject: Re: [PATCH 1/6] mac80211: perform scan cancel in hw reset work
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1285934732-16087-1-git-send-email-sgruszka@redhat.com>
References: <1285934732-16087-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Oct 2010 18:11:35 +0200
Message-ID: <1285949495.3739.39.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-10-01 at 14:05 +0200, Stanislaw Gruszka wrote:
> Move ieee80211_scan_cancel() and all other related code to
> ieee80211_restart_work() as ieee80211_restart_hw() is intended to be
> callable from any context.
> 
> Fix a bug that RTNL lock is not taken during ieee80211_cancel_scan().
> 
> Take local->mtx before WARN(test_bit(SCAN_HW_SCANNING, &local->scanning)
> to prevent the race condition with __ieee80211_start_scan() described
> here: http://marc.info/?l=linux-wireless&m=128516716810537&w=2
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>

This one's obvious -- the other ones I need a bit of time to review, and
it's practically weekend here now. I'll try to get to it ASAP.

johannes

