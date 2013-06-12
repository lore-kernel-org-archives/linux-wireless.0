Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:65404 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab3FLH4o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 03:56:44 -0400
Date: Wed, 12 Jun 2013 02:56:34 -0500
From: Calvin Owens <jcalvinowens@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Felix Fietkau <nbd@openwrt.org>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, netdev@vger.kernel.org
Subject: Re: [PATCH] mac80211: ath9k: Use RCU protection calling
 ieee80211_get_tx_rates
Message-ID: <20130612075634.GA1649@gmail.com> (sfid-20130612_095702_423526_F674824B)
References: <20130609225120.GA2789@gmail.com>
 <20130610042959.GA1902@gmail.com>
 <1370950926.8356.14.camel@jlt4.sipsolutions.net>
 <20130611171304.GA2189@gmail.com>
 <1370980523.8356.70.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1370980523.8356.70.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 06/11 at 21:55 +0200, Johannes Berg wrote:
> Now the subject should no longer say "mac80211:" :)
> 
> However... given that ieee80211_get_tx_rates() actually *copies* the
> rates into the parameter, I guess it should do the rcu_read_lock()
> internally. I guess I wasn't paying attention previously. Felix?

I thought about that, but it seemed too simple, so I assumed I was
missing something. ;)

I'll send a patch per above. That makes the header file update
unnecessary too.

> johannes
