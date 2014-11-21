Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53711 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbaKUJro (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2014 04:47:44 -0500
Message-ID: <1416563244.1881.1.camel@sipsolutions.net> (sfid-20141121_104759_725228_CF4DFC5E)
Subject: Re: [PATCH v3] mac80211: keep sending peer candidate events while
 in listen state
From: Johannes Berg <johannes@sipsolutions.net>
To: "Nishikawa, Kenzoh" <Kenzoh.Nishikawa@jp.sony.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@lists.open80211s.org" <devel@lists.open80211s.org>,
	"Bob Copeland (me@bobcopeland.com)" <me@bobcopeland.com>
Date: Fri, 21 Nov 2014 10:47:24 +0100
In-Reply-To: <2EB4F5C65A3B8E4E92660930F4EF6B5B06C8BC@JPYOKXMS113.jp.sony.com> (sfid-20141121_101258_074290_AAFA54B9)
References: <2EB4F5C65A3B8E4E92660930F4EF6B5B06C8BC@JPYOKXMS113.jp.sony.com>
	 (sfid-20141121_101258_074290_AAFA54B9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-11-21 at 09:11 +0000, Nishikawa, Kenzoh wrote:
> Instead of sending peer candidate events just once, send them as long as the peer remains in the LISTEN state in the peering state machine, when userspace is implementing the peering manager.  Userspace may silence the events from a peer by progressing the state machine or by setting the link state to BLOCKED.
> 
> Fixes the problem that a mesh peering process won't be fired again after the previous first peering trial fails due to like air propagation error if the peering is managed by user space such as wpa_supplicant.
> 
> This patch works with another patch for wpa_supplicant described here which fires a peering process again triggered by the notice from kernel.
> http://lists.shmoo.com/pipermail/hostap/2014-November/031235.html

Please break those long lines to <72 characters.


> +	else if (sta->plink_state == NL80211_PLINK_LISTEN &&
> +		(sdata->u.mesh.user_mpm ||
> +		sdata->u.mesh.security & IEEE80211_MESH_SEC_AUTHED))

the latter two lines should be indented by one more space

johannes

