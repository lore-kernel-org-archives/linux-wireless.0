Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755980Ab0JDPPg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 11:15:36 -0400
Date: Mon, 4 Oct 2010 17:17:00 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/6] mac80211: assure we also cancel deferred scan request
Message-ID: <20101004151659.GB16478@redhat.com>
References: <1285934732-16087-1-git-send-email-sgruszka@redhat.com>
 <1285934732-16087-4-git-send-email-sgruszka@redhat.com>
 <1286197861.3620.31.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1286197861.3620.31.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 04, 2010 at 03:11:01PM +0200, Johannes Berg wrote:
> On Fri, 2010-10-01 at 14:05 +0200, Stanislaw Gruszka wrote:
> > When cfg80211 request the scan and mac80211 perform some management work,
> > we defer the scan request. We do not canceling such requests when calling
> > ieee80211_scan_cancel(), because of SCAN_SW_SCANNING bit check just
> > before the call. So fix that problem. Keeping local->mtx lock assures
> > that the deferred scan will not become "working" HW scan.
> 
> But don't we also delay it becoming a working scan while we have work
> pending? Which seems OK?

Yes, you have right, we cancel the scan_work before that, so transition
will not happen.

> Also what's with all the other changes here, they don't seem related to
> this?

This change

        mutex_lock(&local->mtx);
        if (test_bit(SCAN_SW_SCANNING, &local->scanning) ||
-           (!local->scanning && local->scan_req))
+           (!test_bit(SCAN_HW_SCANNING, &local->scanning) && local->scan_req))
                finish = __ieee80211_scan_completed(&local->hw, true, false);
        mutex_unlock(&local->mtx);


is for ignore local->scanning bits, in case we have some bits set up but no
hw scanning is pending. Not sure If this fix some real problem, but
make things safer IMHO.

We have to think here about hw, sw and deferred scan. Canceling scan_work
seems to wrong for hw_scan, but we still have to remember about sw scan and
deferred scan ... I will try to rewrite patch to cope with all cases.

Stanislaw
