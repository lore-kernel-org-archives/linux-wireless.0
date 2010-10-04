Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55255 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755744Ab0JDNCj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 09:02:39 -0400
Subject: Re: [PATCH 2/6] mac80211: merge ieee80211_scan_work() common code
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1285934732-16087-2-git-send-email-sgruszka@redhat.com>
References: <1285934732-16087-1-git-send-email-sgruszka@redhat.com>
	 <1285934732-16087-2-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Oct 2010 15:02:27 +0200
Message-ID: <1286197347.3620.26.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-10-01 at 14:05 +0200, Stanislaw Gruszka wrote:
> Merge common code using goto instruction. Except less LOC, one of
> the benefit is decrease number of places where function
> ieee80211_scan_completed() is called.

> +	int rc = 1;

This shouldn't be necessary, and will only serve to hide warnings if
somebody rearranges this code in the future.

> +	bool aborted = true;

I'd prefer also not initialising this here and putting the = true into
all the few places that need it so that we get warnings for new places
that jump to the completed w/o properly setting aborted.

johannes


