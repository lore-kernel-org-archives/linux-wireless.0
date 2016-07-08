Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:36804 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbcGHEBP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 00:01:15 -0400
Message-ID: <1467950431.17638.6.camel@edumazet-glaptop3.roam.corp.google.com> (sfid-20160708_060125_070414_75A33625)
Subject: Re: [RFC 5/7] net: Add allocation flag to rtnl_unicast()
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Masashi Honma <masashi.honma@gmail.com>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-rdma@vger.kernel.org,
	linux-audit@redhat.com, cluster-devel@redhat.com,
	davem@davemloft.net, johannes@sipsolutions.net,
	pablo@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu,
	dledford@redhat.com, sean.hefty@intel.com,
	hal.rosenstock@gmail.com, paul@paul-moore.com, eparis@redhat.com,
	zbr@ioremap.net, pshelar@nicira.com, ccaulfie@redhat.com,
	teigland@redhat.com, bsingharora@gmail.com
Date: Fri, 08 Jul 2016 06:00:31 +0200
In-Reply-To: <577F1AD7.8040800@gmail.com>
References: <1467764916-4983-1-git-send-email-masashi.honma@gmail.com>
	 <1467764916-4983-6-git-send-email-masashi.honma@gmail.com>
	 <1467946591.1273.45.camel@edumazet-glaptop3.roam.corp.google.com>
	 <577F1AD7.8040800@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-07-08 at 12:15 +0900, Masashi Honma wrote:
=
> Thanks for comment.
> 
> I have selected GFP flags based on existing code.
> 
> I have selected GFP_ATOMIC in inet6_netconf_get_devconf() because
> skb was allocated with GFP_ATOMIC.

Point is : we should remove GFP_ATOMIC uses as much as we can.

Everytime we see one of them, we should think why it was added
and if this is really needed.

inet6_netconf_get_devconf() is a perfect example of one careless
GFP_ATOMIC usage

https://patchwork.ozlabs.org/patch/646291/






