Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:22308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753200Ab2GQK6j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2012 06:58:39 -0400
Date: Tue, 17 Jul 2012 12:58:20 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: fix crash with single-queue drivers
Message-ID: <20120717105819.GA25862@redhat.com> (sfid-20120717_125843_134218_B7B980E4)
References: <1341399225-12604-1-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1341399225-12604-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 04, 2012 at 12:53:45PM +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Larry (and some others I think) reported that with
> single-queue drivers mac80211 crashes when waking
> the queues. This happens because we allocate just
> a single queue for each virtual interface in case
> the driver doesn't have at least 4 queues, but the
> code stopping/waking the virtual interface queues
> wasn't taking this into account.
> 
> Reported-by: Larry Finger <Larry.Finger@lwfinger.net>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

John, this patch is needed in 3.5, it fix this bug report:
https://bugzilla.kernel.org/show_bug.cgi?id=44411
You can cherry-pick that patch from wireless-next commit:
a6f38ac3cc853189705006cc1e0f17ce8467a1df
If it does not make 3.5 release it has to be posted to
stable.

Stanislaw
