Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45084 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932197Ab1JROyH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Oct 2011 10:54:07 -0400
Message-ID: <4E9D9306.1060005@openwrt.org> (sfid-20111018_165411_515345_F5C0D93C)
Date: Tue, 18 Oct 2011 16:53:58 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Stanislaw Gruszka <sgruszka@redhat.com>,
	linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>, Jouni Malinen <j@w1.fi>,
	reinette chatre <reinette.chatre@intel.com>
Subject: Re: [RFC] mac80211: properly go back to operational channel?
References: <1317121970-3638-1-git-send-email-sgruszka@redhat.com>  <1317123289.4082.12.camel@jlt3.sipsolutions.net>  <20110929150018.GA4554@redhat.com>  <1317740824.6741.22.camel@jlt3.sipsolutions.net>  <20111005111507.GA2184@redhat.com>  <1317813762.4839.7.camel@jlt3.sipsolutions.net>  <20111018141922.GA6204@redhat.com> <1318948251.3958.29.camel@jlt3.sipsolutions.net>
In-Reply-To: <1318948251.3958.29.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-10-18 4:30 PM, Johannes Berg wrote:
> On Tue, 2011-10-18 at 16:19 +0200, Stanislaw Gruszka wrote:
>>  For local->tmp_channel == NULL and local->scan_channel == NULL
>>  ieee80211_cfg_on_oper_channel() will return false if
>>  local->oper_channel != local->hw.conf.channel,
>>  hece we do not properly go back to oper_channel from tmp_channel.
> 
> Huh, good catch.
> 
>>  Does patch have sense?
> 
> Let's see what Ben says. It seems a bit like the
> ieee80211_cfg_on_oper_channel() test there should be inverted instead of
> removed?
> 
>>  Could it fixes problems we are talking
>>  in this thread?
> 
> Yes, could be related, also some issue Jouni and Reinette have been
> seeing with P2P might be related as well.
Just remembered this old patch, also related to this part:
http://news.gmane.org/find-root.php?message_id=%3c1311607763%2d12603%2d3%2dgit%2dsend%2demail%2deliad%40wizery.com%3e

- Felix
