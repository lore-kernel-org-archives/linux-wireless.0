Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33213 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755814AbYIQXGK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 19:06:10 -0400
Subject: Re: [PATCH v2] mac80211: re-enable aggregation
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20080917230357.GA7410@tesla>
References: <1221535073-6937-1-git-send-email-lrodriguez@atheros.com>
	 <1221547036.8916.1.camel@johannes.berg>
	 <1ba2fa240809171357p1b190760h19c3e521e100f7e4@mail.gmail.com>
	 <43e72e890809171545k5aeaa52dje2223bdbeb97ce7e@mail.gmail.com>
	 <1ba2fa240809171557i498cb5e1rcacb5961d8e1c3c6@mail.gmail.com>
	 <20080917230357.GA7410@tesla>
Content-Type: text/plain
Date: Thu, 18 Sep 2008 01:05:57 +0200
Message-Id: <1221692757.7412.22.camel@localhost> (sfid-20080918_010615_367398_DFBE4685)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-09-17 at 16:03 -0700, Luis R. Rodriguez wrote:

> > What I need to next is to add is rtnl_lock
> > qdisc_root_lock requires this. This root lock is held during requeuing
> > which can be triggered by removal or addition of an aggregation queue.
> 
> I saw that, but rtnl_lock() is mutex basd so no good. Hence we need
> something that works around this.

As I outlined earlier I'm pretty much convinced you need to go to the
workqueue anyway. Use schedule_work though, not the mac80211 workqueue,
you can't take the rtnl on the mac80211 wq.

johannes

