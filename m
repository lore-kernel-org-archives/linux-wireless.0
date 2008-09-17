Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:30350 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbYIQXU0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 19:20:26 -0400
Received: by fg-out-1718.google.com with SMTP id 19so29833fgg.17
        for <linux-wireless@vger.kernel.org>; Wed, 17 Sep 2008 16:20:24 -0700 (PDT)
Message-ID: <1ba2fa240809171620g99e5332y690091373e8476f2@mail.gmail.com> (sfid-20080918_012042_178363_0C516E84)
Date: Thu, 18 Sep 2008 02:20:24 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] mac80211: re-enable aggregation
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1221692757.7412.22.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1221535073-6937-1-git-send-email-lrodriguez@atheros.com>
	 <1221547036.8916.1.camel@johannes.berg>
	 <1ba2fa240809171357p1b190760h19c3e521e100f7e4@mail.gmail.com>
	 <43e72e890809171545k5aeaa52dje2223bdbeb97ce7e@mail.gmail.com>
	 <1ba2fa240809171557i498cb5e1rcacb5961d8e1c3c6@mail.gmail.com>
	 <20080917230357.GA7410@tesla> <1221692757.7412.22.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 18, 2008 at 2:05 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2008-09-17 at 16:03 -0700, Luis R. Rodriguez wrote:
>
>> > What I need to next is to add is rtnl_lock
>> > qdisc_root_lock requires this. This root lock is held during requeuing
>> > which can be triggered by removal or addition of an aggregation queue.
>>
>> I saw that, but rtnl_lock() is mutex basd so no good. Hence we need
>> something that works around this.
>
> As I outlined earlier I'm pretty much convinced you need to go to the
> workqueue anyway. Use schedule_work though, not the mac80211 workqueue,
> you can't take the rtnl on the mac80211 wq.

The Addition is done from
1. Rate scale - tx_status context (tasklet) - need schedule here, but
I don't like this conceptually
2. debugfs - this should be OK

removal is called from the driver using callback ... not nice as well.
Tomas
