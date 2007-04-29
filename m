Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server8.tchmachines.com ([216.180.241.250]:56792 "EHLO
	server8.tchmachines.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031289AbXD2ThO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Apr 2007 15:37:14 -0400
From: Michael Wu <flamingice@sourmilk.net>
To: Jiri Benc <jbenc@suse.cz>
Subject: Re: "Stable" branch of mac80211
Date: Sun, 29 Apr 2007 14:14:14 -0400
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>
References: <20070429194855.451b9e7c@logostar.upir.cz>
In-Reply-To: <20070429194855.451b9e7c@logostar.upir.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1360264.PQ71BQaaiS";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Message-Id: <200704291414.19963.flamingice@sourmilk.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1360264.PQ71BQaaiS
Content-Type: multipart/mixed;
  boundary="Boundary-01=_2BONG4GWPaRawu0"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_2BONG4GWPaRawu0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 29 April 2007 13:48, Jiri Benc wrote:
> Please note that this branch is expected to be rebased frequently and all
> patches are subject to change.
>
wireless-dev has been updated recently. One of the conflicts can be resolve=
d=20
easily. There's also an API change which conflicts with the qdisc fixes=20
because tcf_destroy is no longer exported. A patch for that is attached.

Once updated to the latest wireless-dev, it should be fairly easy to pull=20
together a patch for net-2.6 since wireless-dev should have all the major=20
networking API changes for 2.6.22. I think mac80211 can be pushed to net-2.=
6=20
after that. What do you think?

Thanks,
=2DMichael Wu

--Boundary-01=_2BONG4GWPaRawu0
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="19-fix-tcf-api-update.diff"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
	filename="19-fix-tcf-api-update.diff"

mac80211: update qdisc code to use tcf_destroy_chain

=46rom: Michael Wu <flamingice@sourmilk.net>

tcf_destroy is no longer exported. Use tcf_destroy_chain instead.

Signed-off-by: Michael Wu <flamingice@sourmilk.net>
=2D--

 net/mac80211/wme.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 1cb6358..9874d9a 100644
=2D-- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -354,13 +354,10 @@ static void wme_qdiscop_destroy(struct Qdisc* qd)
 	struct ieee80211_sched_data *q =3D qdisc_priv(qd);
 	struct ieee80211_local *local =3D wdev_priv(qd->dev->ieee80211_ptr);
 	struct ieee80211_hw *hw =3D &local->hw;
=2D	struct tcf_proto *tp;
 	int queue;
=20
=2D	while ((tp =3D q->filter_list) !=3D NULL) {
=2D		q->filter_list =3D tp->next;
=2D		tcf_destroy(tp);
=2D	}
+	tcf_destroy_chain(q->filter_list);
+	q->filter_list =3D NULL;
=20
 	for (queue=3D0; queue < hw->queues; queue++) {
 		skb_queue_purge(&q->requeued[queue]);

--Boundary-01=_2BONG4GWPaRawu0--

--nextPart1360264.PQ71BQaaiS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGNOB7T3Oqt9AH4aERAphjAKCAYcLmG+vrCcqRSbjUdePSvGQKBgCfWLc1
aChZyChVGLGIl6dEVg3i7K4=
=YqZi
-----END PGP SIGNATURE-----

--nextPart1360264.PQ71BQaaiS--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
