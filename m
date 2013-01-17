Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ultra-3eti.com ([173.13.207.162]:55148 "EHLO
	mail.ultra-3eti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757065Ab3AQQ0Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2013 11:26:24 -0500
From: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
To: Thomas Pedersen <thomas@cozybit.com>
CC: Georgiewskiy Yuriy <bottleman@icf.org.ru>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	open11s <devel@lists.open80211s.org>
Subject: RE: help: 802.11s bad performance with 802.11n enabled
Date: Thu, 17 Jan 2013 16:14:33 +0000
Message-ID: <BD54DDEB2546894FAB0731EA7B0EDF8D07C1AF64@RockMX01.rock.corp> (sfid-20130117_172628_547128_78FA8BD0)
References: <BD54DDEB2546894FAB0731EA7B0EDF8D07C1256F@RockMX01.rock.corp>
 <alpine.DEB.2.02.1212031842350.27546@icf.org.ru>
 <CAG6hwVM3GFe-v7fONDR_2wuggT+z_ZhDQN-pH7BA1gyxLZzDQQ@mail.gmail.com>
 <alpine.DEB.2.02.1212080721070.8165@icf.org.ru>
 <alpine.DEB.2.02.1212080726150.22564@icf.org.ru>
 <CAG6hwVMsghDHzgyk1ZJE7YoMi2+t-LKNGtgw_ha2DdEwHc71hg@mail.gmail.com>
 <alpine.DEB.2.02.1212080739540.23821@icf.org.ru>
 <BD54DDEB2546894FAB0731EA7B0EDF8D07C12939@RockMX01.rock.corp>
 <CAG6hwVMVd0azJotzVqcz+Uu7vpDtxJa+4XfK0BS_31=gBPD2vA@mail.gmail.com>
In-Reply-To: <CAG6hwVMVd0azJotzVqcz+Uu7vpDtxJa+4XfK0BS_31=gBPD2vA@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


TP> We recently applied
TP> https://github.com/cozybit/authsae/commit/0e5c65c3f773db820d6cee7b365cd4a70181c72d
which may fix your issue.

All, I just find that the patch above introduce a segmentation fault.

Below is the patch content. Look at line 970, "cand->state" would dereference a NULL pointer because the "if"  statement makes sure "cand" is NULL.



if ((cand = find_peer(mgmt->sa, 0)) == NULL) {

968 	  	

-    sae_debug(AMPE_DEBUG_FSM, "Mesh plink: plink open from unauthed peer\n");

  	967 	

+    /* "1" here means only get peers in SAE_ACCEPTED */

  	968 	

+    if ((cand = find_peer(mgmt->sa, 1)) == NULL) {

  	969 	

+    sae_debug(AMPE_DEBUG_FSM, "Mesh plink: plink open from unauthed peer "MACSTR" state=%d\n",

  	970 	

+                  MAC2STR(mgmt->sa), cand->state);

969 	971 	

         return 0;

970 	972 	

     }


