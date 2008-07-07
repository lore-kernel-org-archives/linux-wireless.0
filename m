Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:15825 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753906AbYGGVnJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2008 17:43:09 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2278071wfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jul 2008 14:43:09 -0700 (PDT)
Subject: Re: [PATCH 1/1 V2] mac80211: Fix ieee80211_rx_reorder_ampdu:
	ignore QoS null packets
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>, linville@tuxdriver.com,
	johannes@sipsolutions.net, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
In-Reply-To: <1ba2fa240807071423n755d4e5ay81a6543be7761a92@mail.gmail.com>
References: <1215434881-5410-1-git-send-email-tomas.winkler@intel.com>
	 <1215447824.14247.2.camel@brick> <200807071902.51683.mb@bu3sch.de>
	 <1215458792.14247.7.camel@brick>
	 <1ba2fa240807071423n755d4e5ay81a6543be7761a92@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Mon, 07 Jul 2008 14:43:07 -0700
Message-Id: <1215466987.14247.12.camel@brick> (sfid-20080707_234333_490812_B3548B64)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-07-08 at 00:23 +0300, Tomas Winkler wrote:
> On Mon, Jul 7, 2008 at 10:26 PM, Harvey Harrison
> > Or, after having a coffee and actually engaging brain (similar to
> > ieee80211_is_data_qos)
> >
> > int ieee80211_is_data_nullfunc(__le16 fc)
> > {
> >        return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE | =EF=BB=BFIEE=
E80211_=EF=BB=BFSTYPE_NULLFUNC)) =3D=3D
> >                cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_N=
ULLFUNC);
> > }
> >
> > Tomas, you want a patch?
> >
> > Harvey
>=20
> Maybe it's the late hour but I'm not sure what is wrong with the
> Emmanuel's  patch. Mostly it fixes big stall in RX.
> Checked and validated.

Because there are two cases that want to be caught here:

Commit 511fe3f3c4ba0b5b77421336f64a19b6cd00e65f changed:

        /* null data frames are excluded */
-       if (unlikely(fc & IEEE80211_STYPE_NULLFUNC))
+       if (unlikely(ieee80211_is_nullfunc(hdr->frame_control)))

Which isn't quite equivalent, as it wants to catch just the one bit bei=
ng
set.

How about this:

=46rom: Harvey Harrison <harvey.harrison@gmail.com>
Subject: [PATCH] mac80211: rx.c fix nullfunc data test

commit 511fe3f3c4ba0b5b77421336f64a19b6cd00e65f mac80211: rx.c use new =
helpers
contained an error when testing for nullfunc data frames.  Introduce a
new helper that tests just the NULLFUNC bit as before rather than an ex=
act
match.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/linux/ieee80211.h |   14 ++++++++++++++
 net/mac80211/rx.c         |    2 +-
 2 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index a1630ba..5ba407e 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -239,6 +239,20 @@ static inline int ieee80211_is_data_qos(__le16 fc)
 }
=20
 /**
+ * ieee80211_is_data_nullfunc - check if type is IEEE80211_FTYPE_DATA =
and IEEE80211_STYPE_NULLFUNC is set
+ * @fc: frame control bytes in little-endian byteorder
+ */
+static inline int ieee80211_is_data_nullfunc(__le16 fc)
+{
+	/*
+	 * mask with STYPE_NULLFUNC rather than IEEE80211_FCTL_STYPE as we ju=
st need
+	 * to check the one bit
+	 */
+	return (fc & cpu_to_le16(IEEE80211_FCTL_FTYPE | IEEE80211_STYPE_NULLF=
UNC)) =3D=3D
+	       cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_NULLFUNC);
+}
+
+/**
  * ieee80211_is_data_present - check if type is IEEE80211_FTYPE_DATA a=
nd has data
  * @fc: frame control bytes in little-endian byteorder
  */
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index fab443d..ce879e7 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2047,7 +2047,7 @@ static u8 ieee80211_rx_reorder_ampdu(struct ieee8=
0211_local *local,
 	tid_agg_rx =3D sta->ampdu_mlme.tid_rx[tid];
=20
 	/* null data frames are excluded */
-	if (unlikely(ieee80211_is_nullfunc(hdr->frame_control)))
+	if (unlikely(ieee80211_is_data_nullfunc(hdr->frame_control)))
 		goto end_reorder;
=20
 	/* new un-ordered ampdu frame - process it */
--=20
1.5.6.1.322.ge904b



--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
