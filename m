Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:59833 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751476AbYFYRVq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 13:21:46 -0400
Subject: Re: [RFC] rtl8187: Realtek 8187B wireless support with product
	id0x8197/0x8189
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry.Finger@lwfinger.net, linville@tuxdriver.com,
	hintak_leung@yahoo.co.uk, linux-wireless@vger.kernel.org
In-Reply-To: <1214413636.21847.41.camel@johannes.berg>
References: <4862796a.pmrQX9GXIZ1wDm2k%Larry.Finger@lwfinger.net>
	 (sfid-20080625_185832_411910_F133FFF7)  <1214413636.21847.41.camel@johannes.berg>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 25 Jun 2008 13:21:44 -0400
Message-Id: <1214414504.7901.17.camel@dv> (sfid-20080625_192150_598254_0DF91880)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-06-25 at 19:07 +0200, Johannes Berg wrote:
> > - control->queue, which the herton's change used, for switching bet=
ween 4
> > tramission queue at end point 6,7,5,4, has disappeared. I hard-code=
d 6 in
> > this version, (see commemt #37 for background), but what's the corr=
ect
> > way to do this in current wireless-2.6 code?
>=20
> We switched to using multiqueue netdevs so you have to use
> skb_get_queue_mapping() now.

The last patch I posted to the list was using skb_get_queue_mapping().
Look for "=EF=BB=BF[PATCH WIP] rtl8187b support" from May 22, 2008.

Unfortunately, the patch was still too big and complex for my taste to
be submitted officially, and I didn't have time for further cleanups.

--=20
Regards,
Pavel Roskin
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
