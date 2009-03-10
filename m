Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:36590 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826AbZCJNLO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 09:11:14 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Userspace (wpa_supplicant) not notified on interface down with 2.6.29/wireless-testing
Date: Tue, 10 Mar 2009 10:11:09 -0300
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <200903091850.01604.herton@mandriva.com.br> <1236669214.9658.28.camel@johannes.local>
In-Reply-To: <1236669214.9658.28.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Message-Id: <200903101011.10750.herton@mandriva.com.br> (sfid-20090310_141134_054846_7B2A2E76)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Ter=E7a-feira 10 Mar=E7o 2009, =E0s 04:13:34, Johannes Berg escreveu=
:
> On Mon, 2009-03-09 at 18:50 -0300, Herton Ronaldo Krzesinski wrote:
> > I have the problem when using 2.6.29 and judging by the code the si=
tuation
> > stays the same with wireless-testing, even after the fix "mac80211:=
 deauth when
> > interface is marked down" (the fix doesn't work with kernel 2.6.28 =
or later, as
> > I'll explain).
> >=20
> > The problem is, with latest kernels wpa_supplicant isn't still noti=
fied when
> > interface goes down, even after commit "mac80211: deauth when inter=
face is
> > marked down" (e327b847 on Linus tree). There isn't a problem with t=
his commit,
> > but because of other code changes it doesn't work on latest kernels=
 (but works
> > if I apply same/similar change on 2.6.27 for example).
> >=20
> > The issue is as follows: after commit "mac80211: restructure disass=
oc/deauth
> > flows" in 2.6.28, the call to ieee80211_sta_deauthenticate added by=
 commit
> > e327b847 will not work: because we do sta_info_flush(local, sdata);=
 inside
> > ieee80211_stop (iface.c), all stations in interface are cleared, so=
 when calling
> >  ieee80211_sta_deauthenticate->ieee80211_set_disassoc (mlme.c), ins=
ide
> > ieee80211_set_disassoc we have this in the beginning:
> >=20
> >         sta =3D sta_info_get(local, ifsta->bssid);
> >         if (!sta) {
> >=20
> > the !sta check triggers, so the function returns early and
> > ieee80211_sta_send_apinfo(sdata, ifsta); later isn't called, so wpa=
_supplicant
> > isn't notified with SIOCGIWAP
>=20
> Interesting problem.
>=20
> > One possible fix is moving sta_info_flush, to avoid !sta, and seems=
 good, like
> > the following:
> >=20
> > diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
> > index 2acc416..0929581 100644
> > --- a/net/mac80211/iface.c
> > +++ b/net/mac80211/iface.c
> > @@ -370,25 +370,6 @@ static int ieee80211_stop(struct net_device *d=
ev)
> >  	rcu_read_unlock();
> > =20
> >  	/*
> > -	 * Remove all stations associated with this interface.
> > -	 *
> > -	 * This must be done before calling ops->remove_interface()
> > -	 * because otherwise we can later invoke ops->sta_notify()
> > -	 * whenever the STAs are removed, and that invalidates driver
> > -	 * assumptions about always getting a vif pointer that is valid
> > -	 * (because if we remove a STA after ops->remove_interface()
> > -	 * the driver will have removed the vif info already!)
> > -	 *
> > -	 * We could relax this and only unlink the stations from the
> > -	 * hash table and list but keep them on a per-sdata list that
> > -	 * will be inserted back again when the interface is brought
> > -	 * up again, but I don't currently see a use case for that,
> > -	 * except with WDS which gets a STA entry created when it is
> > -	 * brought up.
> > -	 */
> > -	sta_info_flush(local, sdata);
> > -
> > -	/*
> >  	 * Don't count this interface for promisc/allmulti while it
> >  	 * is down. dev_mc_unsync() will invoke set_multicast_list
> >  	 * on the master interface which will sync these down to the
> > @@ -539,6 +520,26 @@ static int ieee80211_stop(struct net_device *d=
ev)
> >  		conf.mac_addr =3D dev->dev_addr;
> >  		/* disable all keys for as long as this netdev is down */
> >  		ieee80211_disable_keys(sdata);
> > +
> > +		/*
> > +		 * Remove all stations associated with this interface.
> > +		 *
> > +		 * This must be done before calling ops->remove_interface()
> > +		 * because otherwise we can later invoke ops->sta_notify()
> > +		 * whenever the STAs are removed, and that invalidates driver
> > +		 * assumptions about always getting a vif pointer that is valid
> > +		 * (because if we remove a STA after ops->remove_interface()
> > +		 * the driver will have removed the vif info already!)
> > +		 *
> > +		 * We could relax this and only unlink the stations from the
> > +		 * hash table and list but keep them on a per-sdata list that
> > +		 * will be inserted back again when the interface is brought
> > +		 * up again, but I don't currently see a use case for that,
> > +		 * except with WDS which gets a STA entry created when it is
> > +		 * brought up.
> > +		 */
> > +		sta_info_flush(local, sdata);
> > +
> >  		local->ops->remove_interface(local_to_hw(local), &conf);
> >  	}
> > =20
> > My question is, is the patch above safe? that is, do we need to alw=
ays
> > call sta_info_flush on interface down like currently, or just for t=
he case we
> > call remove_interface, like the comment states? if the latter, patc=
h above
> > is good, and solves the wpa_supplicant/userspace issue.
>=20
> The comment states it must be before remove_interface, not that it
> doesn't need to be called unless that is called, and this code moving=
 is
> incorrect for AP_VLAN devices.
>=20
> You could move the disassoc part out of the switch to before this.

Ok, here is the new patch, if it's ok please apply (I can resubmit with=
 patch
in subject/standalone message if necessary):

=46rom eb6f79597b9e6af8a3618873a781fd6ebcbd50a0 Mon Sep 17 00:00:00 200=
1
=46rom: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Date: Tue, 10 Mar 2009 09:44:17 -0300
Subject: [PATCH] mac80211: deauth before flushing STA information

Even after commit "mac80211: deauth when interface is marked down"
(e327b847 on Linus tree), userspace still isn't notified when interface
goes down. There isn't a problem with this commit, but because of other
code changes it doesn't work on kernels >=3D 2.6.28 (works if same/simi=
lar
change applied on 2.6.27 for example).

The issue is as follows: after commit "mac80211: restructure disassoc/d=
eauth
flows" in 2.6.28, the call to ieee80211_sta_deauthenticate added by
commit e327b847 will not work: because we do sta_info_flush(local, sdat=
a)
inside ieee80211_stop (iface.c), all stations in interface are cleared,=
 so
when calling ieee80211_sta_deauthenticate->ieee80211_set_disassoc (mlme=
=2Ec),
inside ieee80211_set_disassoc we have this in the beginning:

         sta =3D sta_info_get(local, ifsta->bssid);
         if (!sta) {

The !sta check triggers, thus the function returns early and
ieee80211_sta_send_apinfo(sdata, ifsta) later isn't called, so
wpa_supplicant/userspace isn't notified with SIOCGIWAP.

This commit moves deauthentication to before flushing STA info
(sta_info_flush), thus the above can't happen and userspace is really
notified when interface goes down.

Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
---
 net/mac80211/iface.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 2acc416..f9f27b9 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -370,6 +370,18 @@ static int ieee80211_stop(struct net_device *dev)
 	rcu_read_unlock();
=20
 	/*
+	 * Announce that we are leaving the network, in case we are a
+	 * station interface type. This must be done before removing
+	 * all stations associated with sta_info_flush, otherwise STA
+	 * information will be gone and no announce being done.
+	 */
+	if (sdata->vif.type =3D=3D NL80211_IFTYPE_STATION) {
+		if (sdata->u.mgd.state !=3D IEEE80211_STA_MLME_DISABLED)
+			ieee80211_sta_deauthenticate(sdata,
+				WLAN_REASON_DEAUTH_LEAVING);
+	}
+
+	/*
 	 * Remove all stations associated with this interface.
 	 *
 	 * This must be done before calling ops->remove_interface()
@@ -454,10 +466,6 @@ static int ieee80211_stop(struct net_device *dev)
 		netif_addr_unlock_bh(local->mdev);
 		break;
 	case NL80211_IFTYPE_STATION:
-		/* Announce that we are leaving the network. */
-		if (sdata->u.mgd.state !=3D IEEE80211_STA_MLME_DISABLED)
-			ieee80211_sta_deauthenticate(sdata,
-						WLAN_REASON_DEAUTH_LEAVING);
 		memset(sdata->u.mgd.bssid, 0, ETH_ALEN);
 		del_timer_sync(&sdata->u.mgd.chswitch_timer);
 		del_timer_sync(&sdata->u.mgd.timer);
--=20
1.6.2

>=20
> johannes
>=20

--
[]'s
Herton
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
