Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53153 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564Ab3LETPw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 14:15:52 -0500
Message-ID: <1386270948.4182.23.camel@jlt4.sipsolutions.net> (sfid-20131205_201555_780670_6A6D5AC4)
Subject: Re: [PATCH] mac80211: fix nested sdata lock for IBSS/CSA
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: linux-wireless@vger.kernel.org, luciano.coelho@intel.com
Date: Thu, 05 Dec 2013 20:15:48 +0100
In-Reply-To: <1386269683-14079-1-git-send-email-sw@simonwunderlich.de>
References: <1386269683-14079-1-git-send-email-sw@simonwunderlich.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-12-05 at 19:54 +0100, Simon Wunderlich wrote:
> This fixes a regression introduced by my patch "mac80211: don't cancel
> csa finalize work within stop_ap", which added sdata locks to
> ieee80211_csa_finalize_work() without removing the locking for
> ieee80211_ibss_finish_csa(), which is called by the former, resulting
> in a deadlock due to nested locking.

Applied.

Maybe you can make a hwsim test for this too :)

johannes

