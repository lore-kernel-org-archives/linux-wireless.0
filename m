Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34840 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab0JDNLT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 09:11:19 -0400
Subject: Re: [PATCH 4/6] mac80211: assure we also cancel deferred scan
 request
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1285934732-16087-4-git-send-email-sgruszka@redhat.com>
References: <1285934732-16087-1-git-send-email-sgruszka@redhat.com>
	 <1285934732-16087-4-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Oct 2010 15:11:01 +0200
Message-ID: <1286197861.3620.31.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-10-01 at 14:05 +0200, Stanislaw Gruszka wrote:
> When cfg80211 request the scan and mac80211 perform some management work,
> we defer the scan request. We do not canceling such requests when calling
> ieee80211_scan_cancel(), because of SCAN_SW_SCANNING bit check just
> before the call. So fix that problem. Keeping local->mtx lock assures
> that the deferred scan will not become "working" HW scan.

But don't we also delay it becoming a working scan while we have work
pending? Which seems OK?

Also what's with all the other changes here, they don't seem related to
this?

johannes

