Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:47208 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab0JHSZ7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 14:25:59 -0400
Received: by qwf7 with SMTP id 7so805265qwf.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Oct 2010 11:25:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1286560985.3612.12.camel@jlt3.sipsolutions.net>
References: <201009210057.13297.chunkeey@googlemail.com> <20100924180013.GD8077@tuxdriver.com>
 <201009250002.21219.chunkeey@googlemail.com> <AANLkTinCkWGs_KMz+QBUw2J5HUVU2hK1+8kVDr_PNZwP@mail.gmail.com>
 <1286492072.20974.49.camel@jlt3.sipsolutions.net> <AANLkTin6nwrhcGdnGxg_gMGSrD_GBc-R51qiendF4iAc@mail.gmail.com>
 <1286560985.3612.12.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Fri, 8 Oct 2010 11:25:38 -0700
Message-ID: <AANLkTikXeA=Q5C84-aaZeq1+vR8vFdXEEe5GyQfCDqr1@mail.gmail.com>
Subject: Re: [RFC v2] mac80211: fix possible null-pointer dereference
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Steve deRosier <steve@cozybit.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes

On Fri, Oct 8, 2010 at 11:03 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>> The patch not only solves this problem, but also responds correctly to
>> non-compatible PLINK_OPEN frames by generating a PLINK_CLOSE with the
>> right reason code.
>
> But then you can't ever actually properly process a *matching*
> PLINK_OPEN frame, afaict, because those definitely do have
>        "!sta && ftype == PLINK_OPEN"

Not always: an sta can be created on reception of a beacon or probe
response (mesh_neighbour_update()), so you could have ftype ==
PLINK_OPEN and a non-null sta. Buy, yes, I agree that !sta && ftype ==
PLINK_OPEN is a valid case.

> which is how the "if (!sta && ftype != PLINK_OPEN) return" came about,
> afaict.

Yes, and Christian's *second* patch (submitted as RFC on Sept 24) does
not change that check.  The matching PLINK_OPEN would be handled in
the following branch:

        } else if (!sta) {
                /* ftype == PLINK_OPEN */
                u32 rates;
                (...)
                sta = mesh_plink_alloc(sdata, mgmt->sa, rates);

> So I still don't think it's quite correct to fix it this way.

Could it be that we are looking at different patches?  Just to be
sure, let me paste below the one we are referring to as sent by
Christian:

---
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index ea13a80..8b7efee 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -412,7 +412,7 @@ void mesh_rx_plink_frame(struct
ieee80211_sub_if_data *sdata, struct ieee80211_m
       enum plink_event event;
       enum plink_frame_type ftype;
       size_t baselen;
-       bool deactivated;
+       bool deactivated, matches_local = true;
       u8 ie_len;
       u8 *baseaddr;
       __le16 plid, llid, reason;
@@ -487,6 +487,7 @@ void mesh_rx_plink_frame(struct
ieee80211_sub_if_data *sdata, struct ieee80211_m
       /* Now we will figure out the appropriate event... */
       event = PLINK_UNDEFINED;
       if (ftype != PLINK_CLOSE && (!mesh_matches_local(&elems, sdata))) {
+               matches_local = false;
               switch (ftype) {
               case PLINK_OPEN:
                       event = OPN_RJCT;
@@ -498,7 +499,15 @@ void mesh_rx_plink_frame(struct
ieee80211_sub_if_data *sdata, struct ieee80211_m
                       /* avoid warning */
                       break;
               }
-               spin_lock_bh(&sta->lock);
+       }
+
+       if (!sta && !matches_local) {
+               rcu_read_unlock();
+               reason = cpu_to_le16(MESH_CAPABILITY_POLICY_VIOLATION);
+               llid = 0;
+               mesh_plink_frame_tx(sdata, PLINK_CLOSE, mgmt->sa, llid,
+                                   plid, reason);
+               return;
       } else if (!sta) {
               /* ftype == PLINK_OPEN */
               u32 rates;
@@ -522,7 +531,7 @@ void mesh_rx_plink_frame(struct
ieee80211_sub_if_data *sdata, struct ieee80211_m
               }
               event = OPN_ACPT;
               spin_lock_bh(&sta->lock);
-       } else {
+       } else if (matches_local) {
               spin_lock_bh(&sta->lock);
               switch (ftype) {
               case PLINK_OPEN:
@@ -564,6 +573,8 @@ void mesh_rx_plink_frame(struct
ieee80211_sub_if_data *sdata, struct ieee80211_m
                       rcu_read_unlock();
                       return;
               }
+       } else {
+               spin_lock_bh(&sta->lock);
       }

       mpl_dbg("Mesh plink (peer, state, llid, plid, event): %pM %s %d %d %d\n",
---

Cheers,

Javier
