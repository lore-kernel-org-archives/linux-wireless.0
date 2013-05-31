Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42049 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab3EaRhb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 May 2013 13:37:31 -0400
Message-ID: <1370021846.14117.13.camel@jlt4.sipsolutions.net> (sfid-20130531_193736_056826_3B5A2235)
Subject: Re: Another try at getting pktgen to work with wifi.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>
Date: Fri, 31 May 2013 19:37:26 +0200
In-Reply-To: <51A8DC1C.1040908@candelatech.com> (sfid-20130531_192143_291284_FB196B0A)
References: <51A79E4A.7000609@candelatech.com>
	 <51A7B049.9090201@openwrt.org> <51A7BA63.4080403@candelatech.com>
	 <51A857BF.7070008@openwrt.org> <51A8DC1C.1040908@candelatech.com>
	 (sfid-20130531_192143_291284_FB196B0A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-05-31 at 10:21 -0700, Ben Greear wrote:

> Before I go work on this, does anyone have any preference over
> whether pktgen packets should obey the QoS or the xmit-queue?

That's the core of the problem is that select_queue has the side effect
of setting skb->priority in mac80211, no? Maybe that side effect needs
to be removed?

Actually that makes it seem like something else should be doing packet
classification, not mac80211 in select_queue()?

Where is skb->priority actually really used in mac80211? I don't see
much?

johannes

