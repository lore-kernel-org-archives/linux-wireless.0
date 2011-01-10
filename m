Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755001Ab1AJWlw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 17:41:52 -0500
Date: Mon, 10 Jan 2011 17:41:27 -0500
From: Jarod Wilson <jarod@redhat.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>, stable@kernel.org,
	Kyle McMartin <kmcmartin@redhat.com>,
	kernel@lists.fedoraproject.org, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 2.6.35] mac80211: fix hard lockup in
 sta_addba_resp_timer_expired
Message-ID: <20110110224127.GF7793@redhat.com>
References: <20110110123808.GA3683@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110110123808.GA3683@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 10, 2011 at 01:38:21PM +0100, Stanislaw Gruszka wrote:
> Problem is 2.6.35 specific, bug was introduced in backport
> of upstream 44271488b91c9eecf249e075a1805dd887e222d2 commit.
> 
> We can not call del_timer_sync(addba_resp_timer) from
> ___ieee80211_stop_tx_ba_session(), as this function can be called from
> that timer callback. To fix, simply use not synchronous del_timer().
> 
> Resolve https://bugzilla.redhat.com/show_bug.cgi?id=667459

Selfishly merged and committed to the F14 kernel tree, because I think I
may be hitting the same issue once in a while here on my own T61. :)

-- 
Jarod Wilson
jarod@redhat.com

