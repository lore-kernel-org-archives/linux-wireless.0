Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35906 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104AbZHQPaK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 11:30:10 -0400
Date: Mon, 17 Aug 2009 11:24:32 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bob Copeland <me@bobcopeland.com>, linux-wireless@vger.kernel.org
Subject: Re: 2.6.31-rc6 lockdep report
Message-ID: <20090817152432.GB5412@tuxdriver.com>
References: <20090817151223.GA13125@hash.localnet> <1250522209.15103.19.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1250522209.15103.19.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 17, 2009 at 05:16:49PM +0200, Johannes Berg wrote:
> On Mon, 2009-08-17 at 11:12 -0400, Bob Copeland wrote:
> > Haven't looked at it yet, I just hit this one while riding the
> > train this morning and connecting to someone's adhoc station.
> > 
> > [43559.227490] wlan0: Selected IBSS BSSID 2a:51:0a:35:5c:a1 based on configured SSID
> > [43559.258660] ath5k phy0: bf=efb0b680 bf_skb=(null)
> > [43559.291501] phy0: Adding new IBSS station 00:21:e9:94:5e:93 (dev=wlan0)
> > [43559.291518] phy0: Allocated STA 00:21:e9:94:5e:93
> > [43559.292327] phy0: Inserted STA 00:21:e9:94:5e:93
> > [43633.646820] phy0: Adding new IBSS station 00:1e:c2:3b:f4:e3 (dev=wlan0)
> > [43633.646838] phy0: Allocated STA 00:1e:c2:3b:f4:e3
> > [43633.646859] 
> > [43633.646860] =========================================================
> > [43633.646864] [ INFO: possible irq lock inversion dependency detected ]
> > [43633.646867] 2.6.31-rc6 #179
> > [43633.646870] ---------------------------------------------------------
> > [43633.646873] cc1/18756 just changed the state of lock:
> > [43633.646876]  (&local->sta_lock){..-...}, at: [<fa244acd>] sta_info_insert+0x91/0x174 [mac80211]
> > [43633.646900] but this lock took another, SOFTIRQ-unsafe lock in the past:
> > [43633.646903]  (todo_lock){+.+...}
> > [43633.646906] 
> > [43633.646907] and interrupts could create inverse lock ordering between them.
> 
> Yeah, commit 6565a1c6d2e0754b5f1e8160252f6dc9493ed6c4 needs to be
> backported. I suspect it applies as-is, John mind trying that? If not,
> let me know and I'll port it.

Cherry-picked it ok, will send along w/ next batch of fixes...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
