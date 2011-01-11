Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:35486 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421Ab1AKXie (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 18:38:34 -0500
Date: Wed, 12 Jan 2011 00:38:31 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>, stable@kernel.org,
	Kyle McMartin <kmcmartin@redhat.com>,
	kernel@lists.fedoraproject.org, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [stable] [PATCH 2.6.35] mac80211: fix hard lockup in sta_addba_resp_timer_expired
Message-ID: <20110111233831.GC16349@one.firstfloor.org>
References: <20110110123808.GA3683@redhat.com>
Mime-Version: 1.0
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

Applied to the 2.6.35.11 queue thanks.

-Andi
