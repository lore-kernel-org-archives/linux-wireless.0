Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:53015 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933146AbaKMSYo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2014 13:24:44 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailout.nyi.internal (Postfix) with ESMTP id 1233C2062E
	for <linux-wireless@vger.kernel.org>; Thu, 13 Nov 2014 13:24:44 -0500 (EST)
Message-ID: <5464F5D6.5090905@noack.us> (sfid-20141113_192454_735073_971325C2)
Date: Thu, 13 Nov 2014 10:17:58 -0800
From: Thomas Pedersen <thomas@noack.us>
MIME-Version: 1.0
To: "Nishikawa, Kenzoh" <Kenzoh.Nishikawa@jp.sony.com>,
	devel@lists.open80211s.org,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: Send peering open frame again if beacon from
 listen state peer is received
References: <2EB4F5C65A3B8E4E92660930F4EF6B5B0619B9@JPYOKXMS113.jp.sony.com>
In-Reply-To: <2EB4F5C65A3B8E4E92660930F4EF6B5B0619B9@JPYOKXMS113.jp.sony.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kenzoh,

Looks like your email is part HTML. Please submit using git-send-email.
Your patch looks ok, just a small comment below.

On 11/12/2014 08:27 PM, Nishikawa, Kenzoh via Devel wrote:
 > net/mac80211/mesh_plink.c |    6 ++++++
 > 1 file changed, 6 insertions(+)
 > diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
 > index 32c7bd0..5ca4306 100644
 > --- a/net/mac80211/mesh_plink.c
 > +++ b/net/mac80211/mesh_plink.c
 >
 > @@ -524,6 +524,12 @@ void mesh_neighbour_update(struct ieee80211_sub_if_data *sdata,
 >                  sdata->u.mesh.mshcfg.auto_open_plinks &&
 >                  rssi_threshold_check(sta, sdata))
 >                            changed = mesh_plink_open(sta);
 > +            else if (sta->plink_state == NL80211_PLINK_LISTEN &&

You should probably check for (sdata->u.mesh.security & IEEE80211_MESH_SEC_AUTHED)
as well like in mesh_sta_info_alloc().

 > +                          sdata->u.mesh.user_mpm)
 > +                          cfg80211_notify_new_peer_candidate(sdata->dev, hw_addr,
 > +                                                                                                   elems->ie_start,
 > +                                                                                                   elems->total_len,
 > +                                                                                                   GFP_KERNEL);
 >               ieee80211_mps_frame_release(sta, elems);
 > out:

-- 
thomas
