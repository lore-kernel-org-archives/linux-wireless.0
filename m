Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39437 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbYECW4i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 May 2008 18:56:38 -0400
Subject: Re: mac80211 truesize bugs
From: Johannes Berg <johannes@sipsolutions.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: David Miller <davem@davemloft.net>, mb@bu3sch.de,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org
In-Reply-To: <1209830582.3673.8.camel@johannes.berg> (sfid-20080503_180248_421223_067F1B11)
References: <20080501.024320.212547875.davem@davemloft.net>
	 <E1JrW9h-0001tI-00@gondolin.me.apana.org.au>
	 <20080501.034950.261408566.davem@davemloft.net>
	 <20080501.035335.216935614.davem@davemloft.net>
	 <1209639500.7067.0.camel@johannes.berg>
	 <20080501110341.GD7490@gondor.apana.org.au>
	 <1209818282.3987.23.camel@johannes.berg>
	 <20080503125940.GA26199@gondor.apana.org.au>
	 <1209830582.3673.8.camel@johannes.berg>
	 (sfid-20080503_180248_421223_067F1B11)
Content-Type: text/plain; charset=utf-8
Date: Sun, 04 May 2008 00:56:23 +0200
Message-Id: <1209855383.3649.3.camel@johannes.berg> (sfid-20080504_005609_458630_8CFDE7B6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-05-03 at 18:03 +0200, Johannes Berg wrote:
> On Sat, 2008-05-03 at 20:59 +0800, Herbert Xu wrote:
> > On Sat, May 03, 2008 at 02:38:01PM +0200, Johannes Berg wrote:
> > >
> > > Why, btw? It's not too hard to check the allocated size, no?
> >=20
> > Yes that would be a meaningful improvement although we'd need to
> > audit/test this to make sure that we don't spam people's logs
> > with it.
>=20
> It does spam the log. A lot. And I don't know why, from this discussi=
on
> I only thought that it shouldn't.

This was a stupid mistake, if you do it correctly it actually works and
so far has only triggered a single warning on my system:

[  217.507048] SKB BUG: Invalid truesize (4294964120) size=3D432, sizeo=
f(sk_buff)=3D176
=EF=BB=BF
that was with my patch though to update skb->truesize during !skb->sk
pskb_expand_head() calls.

johannes

---
 include/linux/skbuff.h |    8 ++++++--
 net/core/skbuff.c      |   10 ++++++++--
 2 files changed, 14 insertions(+), 4 deletions(-)

--- everything.orig/include/linux/skbuff.h	2008-05-03 15:47:00.00000000=
0 +0200
+++ everything/include/linux/skbuff.h	2008-05-04 00:30:34.000000000 +02=
00
@@ -387,9 +387,13 @@ extern void	      skb_truesize_bug(struc
=20
 static inline void skb_truesize_check(struct sk_buff *skb)
 {
-	int len =3D sizeof(struct sk_buff) + skb->len;
+#ifdef NET_SKBUFF_DATA_USES_OFFSET
+	int len =3D sizeof(struct sk_buff) + skb->end;
+#else
+	int len =3D sizeof(struct sk_buff) + (skb->end - skb->head);
+#endif
=20
-	if (unlikely((int)skb->truesize < len))
+	if (unlikely((int)skb->truesize !=3D len))
 		skb_truesize_bug(skb);
 }
=20
--- everything.orig/net/core/skbuff.c	2008-05-03 16:29:23.000000000 +02=
00
+++ everything/net/core/skbuff.c	2008-05-04 00:31:32.000000000 +0200
@@ -151,9 +151,15 @@ void skb_under_panic(struct sk_buff *skb
=20
 void skb_truesize_bug(struct sk_buff *skb)
 {
+#ifdef NET_SKBUFF_DATA_USES_OFFSET
+	int len =3D sizeof(struct sk_buff) + skb->end;
+#else
+	int len =3D sizeof(struct sk_buff) + (skb->end - skb->head);
+#endif
+
 	printk(KERN_ERR "SKB BUG: Invalid truesize (%u) "
-	       "len=3D%u, sizeof(sk_buff)=3D%Zd\n",
-	       skb->truesize, skb->len, sizeof(struct sk_buff));
+	       "size=3D%u, sizeof(sk_buff)=3D%Zd\n",
+	       skb->truesize, len, sizeof(struct sk_buff));
 }
 EXPORT_SYMBOL(skb_truesize_bug);
=20


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
