Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59802 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994AbYFKMMq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 08:12:46 -0400
Message-ID: <7ba851519c84785f96af3637e9bab65b.squirrel@secure.sipsolutions.net>
In-Reply-To: <43e72e890806110403nddfca7cn66b91a938919e1f0@mail.gmail.com> 
References: <43e72e890806080855p284f85brd0ff1f1dfce96bf8@mail.gmail.com>
    <c85cb4470806090053l5b763a23j43bbf0c87f594b0d@mail.gmail.com>
    <1213001797.698.57.camel@johannes.berg>
    <43e72e890806090201q55bff8e3m694121ebd4befee6@mail.gmail.com>
    <43e72e890806090325y5a1aebadq68204695044f4b6f@mail.gmail.com>
    <1ba2fa240806101657w14599f30x67f58acbc7fe9e80@mail.gmail.com>
    <43e72e890806102132q1aaba42ehd76bdd30b8d4080a@mail.gmail.com>
    <43e72e890806102136jb8e695fla98a8594dde14396@mail.gmail.com>
    <43e72e890806110403nddfca7cn66b91a938919e1f0@mail.gmail.com>
Date: Wed, 11 Jun 2008 14:12:41 +0200 (CEST)
Subject: Re: [compat-masters] Backported MQ requirement on 802.11n for
     older kernels
From: "Johannes Berg" <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Tomas Winkler" <tomasw@gmail.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	compat-masters@lists.madwifi.org,
	"Tim Gardner" <tim.gardner@canonical.com>,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Johannes -- why do we have the requirement for NETDEVICES_MULTIQUEUE
> on CONFIG_MAC80211_QOS? My current config doesn't have it it and
> CONFIG_MAC80211_QOS still works right now enabled. Of course the
> driver I'm testing doesn't have 11n though.

because otherwise skb_get_queu_mapping always returns 0 and you use only
one queue.

> Shouldn't we just make MAC80211_QOS depend on NET_SCHED and figure out
> we can't support 11n based on NETDEVICES_MULTIQUEUE?

no, 11e also needs multiple queues.

johannes
