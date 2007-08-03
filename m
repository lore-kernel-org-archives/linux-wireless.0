Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2154 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091AbXHCBGr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2007 21:06:47 -0400
Date: Thu, 2 Aug 2007 20:55:18 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Daniel Drake <dsd@gentoo.org>, flamingice@sourmilk.net,
	linux-wireless@vger.kernel.org, jbenc@suse.cz,
	Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	Larry Finger <larry.finger@lwfinger.net>
Subject: Re: mac80211 IPv6 problems
Message-ID: <20070803005517.GA4261@tuxdriver.com>
References: <46b1fde0.b+weBDN75J0SPe2a%Larry.Finger@lwfinger.net> <200708021807.20649.mb@bu3sch.de> <46B20695.2080100@lwfinger.net> <1186088678.2931.10.camel@pmac.infradead.org> <46B25B04.5020804@gentoo.org> <1186094778.6701.6.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1186094778.6701.6.camel@shinybook.infradead.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 02, 2007 at 11:46:18PM +0100, David Woodhouse wrote:
> On Thu, 2007-08-02 at 18:30 -0400, Daniel Drake wrote:
> > This may be a stack-level issue. This is one of the issues holding =
back=20
> > zd1211rw-mac80211 going into mainline: we have a report that=20
> > zd1211rw-softmac works fine with IPv6 but mac80211 only works=20
> > occasionally with the same device on the same system.
> >=20
> > Does anyone have any ideas?
>=20
> It receives its own neighbour solicitation (multicast) packets when t=
he
> AP sends them back out again. These packets...
>=20
> 23:41:56.046939 00:0a:95:f3:99:92 > 33:33:ff:f3:99:92, ethertype IPv6
> (0x86dd), length 78: :: > ff02::1:fff3:9992: ICMP6, neighbor
> solicitation, who has fe80::20a:95ff:fef3:9992, length 24
>=20
> You should be able to see this without _any_ IPv6 infrastructure -- a=
nd
> you'll see the link-local IPv6 address remains 'tentative'.
>=20
> Once you've fixed that, setting up a local route advertisement d=E6mo=
n
> (radvd) to give you site-local addresses is fairly trivial too -- and
> then you can also check that Ethernet multicast is working properly.

I hacked-up the (untested) patch below -- thoughts?

---

=46rom: John W. Linville <linville@tuxdriver.com>

[PATCH] mac80211: filter locally-originated multicast frames

In STA mode, the AP will echo our traffic.  This includes multicast
traffice.

Receiving these frames confuses some protocols and applications,
notably IPv6 Duplicate Address Detection.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---

 net/mac80211/ieee80211.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/ieee80211.c b/net/mac80211/ieee80211.c
index a42e70e..6dc6451 100644
--- a/net/mac80211/ieee80211.c
+++ b/net/mac80211/ieee80211.c
@@ -4263,11 +4263,14 @@ void __ieee80211_rx(struct ieee80211_hw *hw, st=
ruct sk_buff *skb,
 					rx.u.rx.ra_match =3D 0;
 				} else if (!multicast &&
 					   compare_ether_addr(sdata->dev->dev_addr,
-							      hdr->addr1) !=3D 0) {
+							      hdr->addr1)) {
 					if (!sdata->promisc)
 						continue;
 					rx.u.rx.ra_match =3D 0;
-				}
+				} else if (multicast &&
+					   !compare_ether_addr(sdata->dev->dev_addr,
+							       hdr->addr3))
+					rx.u.rx.ra_match =3D 0;
 				break;
 			case IEEE80211_IF_TYPE_IBSS:
 				if (!bssid)
--=20
John W. Linville
linville@tuxdriver.com
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
