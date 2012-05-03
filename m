Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:44214 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364Ab2ECRMf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 13:12:35 -0400
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-wireless@vger.kernel.org> from <paulmck@linux.vnet.ibm.com>;
	Thu, 3 May 2012 11:12:34 -0600
Received: from d03relay05.boulder.ibm.com (d03relay05.boulder.ibm.com [9.17.195.107])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 7C2B41FF0023
	for <linux-wireless@vger.kernel.org>; Thu,  3 May 2012 11:12:23 -0600 (MDT)
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay05.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q43HCBGZ065564
	for <linux-wireless@vger.kernel.org>; Thu, 3 May 2012 11:12:17 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q43HCAtj008302
	for <linux-wireless@vger.kernel.org>; Thu, 3 May 2012 11:12:10 -0600
Date: Thu, 3 May 2012 10:12:09 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Mohammed Shafi <shafi.wireless@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Suspicious RCU usage in mac80211
Message-ID: <20120503171209.GH2592@linux.vnet.ibm.com> (sfid-20120503_191238_969887_A2D7FE20)
Reply-To: paulmck@linux.vnet.ibm.com
References: <1334202842.3788.10.camel@jlt3.sipsolutions.net>
 <4F86FA05.5080404@lwfinger.net>
 <1334246145.4062.0.camel@jlt3.sipsolutions.net>
 <CAD2nsn1773KvbPCFKBWr5JOkLkj_cz4wk4fkTDA9cAdBUagQcw@mail.gmail.com>
 <4FA0371E.9040704@lwfinger.net>
 <20120502100012.GA8492@arm.com>
 <1335978471.4295.3.camel@jlt3.sipsolutions.net>
 <4FA1F534.8040601@lwfinger.net>
 <20120503084701.GA27872@arm.com>
 <4FA2B845.2000502@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FA2B845.2000502@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 03, 2012 at 11:54:29AM -0500, Larry Finger wrote:
> On 05/03/2012 03:47 AM, Catalin Marinas wrote:
> >
> >IIUC, Paul suggested that you should use rcu_dereference_check() here
> >instead as the protected one is not safe in this context.
> 
> This patch also fails to fix the problem. Did I do what Paul suggested?

That is indeed what I suggested!

What locks does lockdep say are held?

							Thanx, Paul

> Index: wireless-testing-new/net/mac80211/sta_info.h
> ===================================================================
> --- wireless-testing-new.orig/net/mac80211/sta_info.h
> +++ wireless-testing-new/net/mac80211/sta_info.h
> @@ -452,7 +452,7 @@ void ieee80211_assign_tid_tx(struct sta_
>  static inline struct tid_ampdu_tx *
>  rcu_dereference_protected_tid_tx(struct sta_info *sta, int tid)
>  {
> -       return rcu_dereference_protected(sta->ampdu_mlme.tid_tx[tid],
> +       return rcu_dereference_check(sta->ampdu_mlme.tid_tx[tid],
>                                          lockdep_is_held(&sta->lock) ||
>                                          lockdep_is_held(&sta->ampdu_mlme.mtx));
>  }
> 

