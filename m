Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51681 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350Ab1JROa4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 10:30:56 -0400
Subject: Re: [RFC] mac80211: properly go back to operational channel?
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>, Jouni Malinen <j@w1.fi>,
	reinette chatre <reinette.chatre@intel.com>
In-Reply-To: <20111018141922.GA6204@redhat.com>
References: <1317121970-3638-1-git-send-email-sgruszka@redhat.com>
	 <1317123289.4082.12.camel@jlt3.sipsolutions.net>
	 <20110929150018.GA4554@redhat.com>
	 <1317740824.6741.22.camel@jlt3.sipsolutions.net>
	 <20111005111507.GA2184@redhat.com>
	 <1317813762.4839.7.camel@jlt3.sipsolutions.net>
	 <20111018141922.GA6204@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 18 Oct 2011 16:30:51 +0200
Message-ID: <1318948251.3958.29.camel@jlt3.sipsolutions.net> (sfid-20111018_163059_756361_9D1DDFEA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-10-18 at 16:19 +0200, Stanislaw Gruszka wrote:
> For local->tmp_channel == NULL and local->scan_channel == NULL
> ieee80211_cfg_on_oper_channel() will return false if
> local->oper_channel != local->hw.conf.channel,
> hece we do not properly go back to oper_channel from tmp_channel.

Huh, good catch.

> Does patch have sense? 

Let's see what Ben says. It seems a bit like the
ieee80211_cfg_on_oper_channel() test there should be inverted instead of
removed?

> Could it fixes problems we are talking
> in this thread?

Yes, could be related, also some issue Jouni and Reinette have been
seeing with P2P might be related as well.

johannes


