Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:61108 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754688Ab2HAR6b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Aug 2012 13:58:31 -0400
Date: Wed, 1 Aug 2012 13:58:16 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <stable@vger.kernel.org>,
	<liang.li@windriver.com>
Subject: Re: [RFC/PATCH 0/1] Fix inability to configure adhoc in 3.4.x
Message-ID: <20120801175816.GB13879@windriver.com> (sfid-20120801_195835_738411_848681F6)
References: <1343837663-12645-1-git-send-email-paul.gortmaker@windriver.com>
 <1343838717.4638.9.camel@jlt3.sipsolutions.net>
 <20120801173847.GA13879@windriver.com>
 <1343842929.4638.17.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1343842929.4638.17.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[Re: [RFC/PATCH 0/1] Fix inability to configure adhoc in 3.4.x] On 01/08/2012 (Wed 19:42) Johannes Berg wrote:

> On Wed, 2012-08-01 at 13:38 -0400, Paul Gortmaker wrote:
> 
> > > > 1) cherry pick 8e8b41f9d, and all the driver specific changes it requires
> > > > 
> > > > 2) make a sub-commit for stable that just takes the total==1 from #1.
> > > > 
> > > > 3) patch iwlwifi/iwl-mac80211.c and add ".types = BIT(NL80211_IFTYPE_ADHOC)"
> > > > 
> > > > 4) treat ADHOC as a universal feature that everyone has.
> > > > 
> > > > The following patch does #4, and in theory it could be used in mainline
> > > > and then cherry picked back to stable.  But we weren't 100% sure if that
> > > > was the best solution, since neither of us are really wireless people,
> > > > hence all the detail here.
> > > 
> > > Thanks for the detailed analysis. Given 8e8b41f9d, I don't think any
> > > mainline changes are actually needed?
> > 
> > Perhaps not.  I know Liang was looking at the ath5k and ath9k changes:
> > 
> >   9b4760e  ath5k: add possible wiphy interface combinations
> >   20c8e8d  ath9k: add possible wiphy interface combinations
> > 
> > and thinking that the above commits plus the "total==1" change
> > wouldn't fix any ATH multifunction cards (if they exist) in the
> > ad-hoc use case - but we didn't have such hardware to test with.
> 
> I'm not sure what you mean by "wouldn't fix" here -- the way the devices
> advertise their multi-virtual-interface support is that they do not
> support IBSS (ad-hoc) in combination with any other interface.
> Therefore, pure IBSS should be covered by the total==1 case?

OK, it sounds like I/we were simply just misunderstanding the code,
due to lack of wireless knowledge, and that the exclusion was
intentional.  We'll get the total==1 subpatch posted here tomorrow.

Thanks again for the input.
Paul.
--

> 
> johannes
> 
