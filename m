Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50974 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188Ab2BHOsr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Feb 2012 09:48:47 -0500
Subject: Re: [PATCH] skbuff: Add new tc classify variable
From: jamal <hadi@cyberus.ca>
Reply-To: jhs@mojatatu.com
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Marek Lindner <lindner_marek@yahoo.de>,
	Sven Eckelmann <sven@narfation.org>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org, linux-wireless@vger.kernel.org
In-Reply-To: <1328692916.2284.5.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <1328639948-25232-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <20120207.135841.1753473725075272902.davem@davemloft.net>
	 <20120207201633.GB26533@pandem0nium>
	 <1328692916.2284.5.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Feb 2012 09:48:41 -0500
Message-ID: <1328712521.2983.1.camel@mojatatu> (sfid-20120208_154853_794902_78DAB7BD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

skb->cb is the right scratch pad to use.
The problem appears to be the wireless stack abusing some of these
fields (prio for one). And we do have marks in place already which
are 32 bit and global.

 
cheers,
jamal

On Wed, 2012-02-08 at 10:21 +0100, Eric Dumazet wrote:
> Le mardi 07 février 2012 à 21:16 +0100, Simon Wunderlich a écrit :

> 
> I really dont understand what the conflict might be.
> 
> As long as skb is in Qdisc layer, Qdisc owns skb->cb[] (a part of it
> actually, see current discussions about IB on netdev)
> 
> As soon as packet is given to device (mac80211), cb[] can be reused.
> 
> Or are you saying tc_class also might be needed by mac80211 in the
> future ?
> 
> 
> 


