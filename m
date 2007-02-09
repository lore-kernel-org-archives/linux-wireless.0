Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.rutgers.edu ([128.6.72.243]:61922 "EHLO
	annwn13.rutgers.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992451AbXBIRsI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Feb 2007 12:48:08 -0500
From: Michael Wu <flamingice@sourmilk.net>
To: Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH] d80211: remove hosttime from ieee80211_rx_status
Date: Fri, 9 Feb 2007 12:47:31 -0500
Cc: Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org
References: <200702082359.47085.flamingice@sourmilk.net> <200702091056.46679.flamingice@sourmilk.net> <20070209181513.66fdec56@griffin.suse.cz>
In-Reply-To: <20070209181513.66fdec56@griffin.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1181588.D39VMvjmDg";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200702091247.36267.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1181588.D39VMvjmDg
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 09 February 2007 12:15, Jiri Benc wrote:
> Uh, sorry, I haven't noticed it before: you should copy cb to a local
> rx_status structure as __ieee80211_rx is allowed to destroy the skb,
> yet it still needs the rx_status.
>
=46ixed.

=2D-

d80211: remove hosttime from ieee80211_rx_status

Nobody fills hosttime in ieee80211_rx_status. Removing it allows
ieee80211_rx_status to fit in skb->cb.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
=2D--

 include/net/d80211.h   |    1 -
 net/d80211/ieee80211.c |   29 ++++++++---------------------
 2 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/include/net/d80211.h b/include/net/d80211.h
index 326def5..0b7b963 100644
=2D-- a/include/net/d80211.h
+++ b/include/net/d80211.h
@@ -225,7 +225,6 @@ struct ieee80211_tx_control {
  * (the subset supported by hardware) to the 802.11 code with each received
  * frame. */
 struct ieee80211_rx_status {
=2D        u64 hosttime;
 	u64 mactime;
         int freq; /* receive frequency in Mhz */
         int channel;
diff --git a/net/d80211/ieee80211.c b/net/d80211/ieee80211.c
index bbcefa9..a0c367c 100644
=2D-- a/net/d80211/ieee80211.c
+++ b/net/d80211/ieee80211.c
@@ -2627,7 +2627,7 @@ ieee80211_fill_frame_info(struct ieee802
                 struct timespec ts;
 		struct ieee80211_rate *rate;
=20
=2D                jiffies_to_timespec(status->hosttime, &ts);
+		jiffies_to_timespec(jiffies, &ts);
 		fi->hosttime =3D cpu_to_be64((u64) ts.tv_sec * 1000000 +
 					   ts.tv_nsec / 1000);
 		fi->mactime =3D cpu_to_be64(status->mactime);
@@ -4019,25 +4019,13 @@ static void ieee80211_stat_refresh(unsig
 void ieee80211_rx_irqsafe(struct ieee80211_hw *hw, struct sk_buff *skb,
 			  struct ieee80211_rx_status *status)
 {
=2D	struct ieee80211_rx_status *saved;
 	struct ieee80211_local *local =3D hw_to_local(hw);
=20
=2D	skb->dev =3D local->mdev;
=2D	saved =3D kmalloc(sizeof(struct ieee80211_rx_status), GFP_ATOMIC);
=2D	if (unlikely(!saved)) {
=2D		if (net_ratelimit())
=2D			printk(KERN_WARNING "%s: Not enough memory, "
=2D			       "dropping packet", skb->dev->name);
=2D		/* should be dev_kfree_skb_irq, but due to this function being
=2D		 * named _irqsafe instead of just _irq we can't be sure that
=2D		 * people won't call it from non-irq contexts */
=2D		dev_kfree_skb_any(skb);
=2D		return;
=2D	}
=2D	memcpy(saved, status, sizeof(struct ieee80211_rx_status));
=2D	/* copy pointer to saved status into skb->cb for use by tasklet */
=2D	memcpy(skb->cb, &saved, sizeof(saved));
+	BUILD_BUG_ON(sizeof(struct ieee80211_rx_status) > sizeof(skb->cb));
=20
+	skb->dev =3D local->mdev;
+	/* copy status into skb->cb for use by tasklet */
+	memcpy(skb->cb, status, sizeof(*status));
 	skb->pkt_type =3D ieee80211_rx_msg;
 	skb_queue_tail(&local->skb_queue, skb);
 	tasklet_schedule(&local->tasklet);
@@ -4089,20 +4077,19 @@ static void ieee80211_tasklet_handler(un
 {
         struct ieee80211_local *local =3D (struct ieee80211_local *) data;
         struct sk_buff *skb;
=2D	struct ieee80211_rx_status *rx_status;
+	struct ieee80211_rx_status rx_status;
 	struct ieee80211_tx_status *tx_status;
=20
 	while ((skb =3D skb_dequeue(&local->skb_queue)) ||
 	       (skb =3D skb_dequeue(&local->skb_queue_unreliable))) {
                 switch (skb->pkt_type) {
 		case ieee80211_rx_msg:
=2D			/* get pointer to saved status out of skb->cb */
+			/* status is in skb->cb */
 			memcpy(&rx_status, skb->cb, sizeof(rx_status));
 			/* Clear skb->type in order to not confuse kernel
 			 * netstack. */
 			skb->pkt_type =3D 0;
=2D			__ieee80211_rx(local_to_hw(local), skb, rx_status);
=2D			kfree(rx_status);
+			__ieee80211_rx(local_to_hw(local), skb, &rx_status);
 			break;
 		case ieee80211_tx_status_msg:
 			/* get pointer to saved status out of skb->cb */


--nextPart1181588.D39VMvjmDg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBFzLO4T3Oqt9AH4aERAkxjAJ0eys6WB8x6okSgRakDdo8VCQYl1wCcCD+U
uwfDQ8mvEclW2fDH8haVP/8=
=0Uzr
-----END PGP SIGNATURE-----

--nextPart1181588.D39VMvjmDg--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
