Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab1CPIkh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Mar 2011 04:40:37 -0400
Date: Wed, 16 Mar 2011 09:40:23 +0100
From: Jiri Pirko <jpirko@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	netfilter-devel@vger.kernel.org, eric.dumazet@gmail.com,
	linville@tuxdriver.com, kaber@trash.net
Subject: Re: net-next-2.6 status...
Message-ID: <20110316084022.GA2845@psychotron.brq.redhat.com>
References: <20110315.160124.104058374.davem@davemloft.net>
 <20110316065008.GA2780@psychotron.redhat.com>
 <20110316.000251.189704695.davem@davemloft.net>
 <20110316073803.GB2780@psychotron.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110316073803.GB2780@psychotron.redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wed, Mar 16, 2011 at 08:38:03AM CET, jpirko@redhat.com wrote:
>Wed, Mar 16, 2011 at 08:02:51AM CET, davem@davemloft.net wrote:
>>From: Jiri Pirko <jpirko@redhat.com>
>>Date: Wed, 16 Mar 2011 07:50:09 +0100
>>
>>>>Jiri, I know there is your patch set there, but I think you and Changli
>>>>still need to go back and forth one more time wrt. orig_dev semantics.
>>>>Since you have been posting this patch set for some time I'm still
>>>>willing to apply it for this merge window, but please make haste and
>>>>work out the remaining discussion.  Thank you.
>>> 
>>> Dave, you can apply the rest of the series and leave only the first
>>> patch (af_packet) out. There's no dependency. We will figure out things
>>> around origdev later.
>>
>>I was about to do that but I've found other problems.
>>
>>You cannot make the modifications you make to linux/if.h, those
>>interface flags are visible to userspace.
>
>What do you suggest? To remove unused flags and leave gaps there or to
>not to remove the flags at all?

Well, the following comment:
<quote>
/* Private (from user) interface flags (netdevice->priv_flags). */
</quote>
leads me to think that these flags should not be used by userspace.
So maybe it may not be problem to change those values.
>
>Thanks.
>
>Jirka
