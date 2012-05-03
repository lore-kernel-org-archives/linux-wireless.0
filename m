Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49939 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755584Ab2ECQyg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 12:54:36 -0400
Received: by yenm10 with SMTP id m10so1442256yen.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2012 09:54:35 -0700 (PDT)
Message-ID: <4FA2B845.2000502@lwfinger.net> (sfid-20120503_185440_089021_486262D2)
Date: Thu, 03 May 2012 11:54:29 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Mohammed Shafi <shafi.wireless@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Suspicious RCU usage in mac80211
References: <1334201497.3788.1.camel@jlt3.sipsolutions.net> <4F865155.2000202@lwfinger.net> <1334202842.3788.10.camel@jlt3.sipsolutions.net> <4F86FA05.5080404@lwfinger.net> <1334246145.4062.0.camel@jlt3.sipsolutions.net> <CAD2nsn1773KvbPCFKBWr5JOkLkj_cz4wk4fkTDA9cAdBUagQcw@mail.gmail.com> <4FA0371E.9040704@lwfinger.net> <20120502100012.GA8492@arm.com> <1335978471.4295.3.camel@jlt3.sipsolutions.net> <4FA1F534.8040601@lwfinger.net> <20120503084701.GA27872@arm.com>
In-Reply-To: <20120503084701.GA27872@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/03/2012 03:47 AM, Catalin Marinas wrote:
>
> IIUC, Paul suggested that you should use rcu_dereference_check() here
> instead as the protected one is not safe in this context.

This patch also fails to fix the problem. Did I do what Paul suggested?


Index: wireless-testing-new/net/mac80211/sta_info.h
===================================================================
--- wireless-testing-new.orig/net/mac80211/sta_info.h
+++ wireless-testing-new/net/mac80211/sta_info.h
@@ -452,7 +452,7 @@ void ieee80211_assign_tid_tx(struct sta_
  static inline struct tid_ampdu_tx *
  rcu_dereference_protected_tid_tx(struct sta_info *sta, int tid)
  {
-       return rcu_dereference_protected(sta->ampdu_mlme.tid_tx[tid],
+       return rcu_dereference_check(sta->ampdu_mlme.tid_tx[tid],
                                          lockdep_is_held(&sta->lock) ||
                                          lockdep_is_held(&sta->ampdu_mlme.mtx));
  }
