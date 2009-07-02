Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38150 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbZGBNAx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2009 09:00:53 -0400
Date: Thu, 2 Jul 2009 08:47:38 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Build error in 2.6.31-rc1-wl
Message-ID: <20090702124737.GA2839@tuxdriver.com>
References: <4A4BCA87.8020805@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4A4BCA87.8020805@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 01, 2009 at 03:43:51PM -0500, Larry Finger wrote:
> When building the above kernel based on a fress pull of
> wireless-testing, I get the following build error:
> 
>   CC      net/core/skbuff.o
> net/core/skbuff.c: In function ‘__copy_skb_header’:
> net/core/skbuff.c:563: error: ‘struct sk_buff’ has no member named
> ‘do_not_encrypt’
> net/core/skbuff.c:563: error: ‘const struct sk_buff’ has no member
> named ‘do_not_encrypt’
> make[2]: *** [net/core/skbuff.o] Error 1
> 
> The code that errors is
> 
>         new->vlan_tci           = old->vlan_tci;
> #if defined(CONFIG_MAC80211) || defined(CONFIG_MAC80211_MODULE)
>         new->do_not_encrypt     = old->do_not_encrypt;
> #endif
> 
>         skb_copy_secmark(new, old);
> }

Some patch damage when moving to 2.6.31-rc1.  Johannes sent me a
fix-up yesterday, so I have folded it back into the damaged patch
and pushed it out.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
			¡Viva Honduras Libre!
