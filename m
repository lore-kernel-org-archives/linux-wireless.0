Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43645 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808Ab2DYOnO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2012 10:43:14 -0400
Date: Wed, 25 Apr 2012 20:14:06 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Arend van Spriel <arend@broadcom.com>
CC: <johannes@sipsolutions.net>, <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [RFC] mac80211: fix rate control update on 2040 bss change
Message-ID: <20120425144405.GA890@vmraj-lnx.users.atheros.com> (sfid-20120425_164319_078554_0CC3D5C9)
References: <1335358909-24905-1-git-send-email-rmanohar@qca.qualcomm.com>
 <4F980551.3070204@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4F980551.3070204@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 25, 2012 at 04:08:17PM +0200, Arend van Spriel wrote:
> On 04/25/2012 03:01 PM, Rajkumar Manoharan wrote:
> >The rate control updatation never be called on 2040 BSS change.
> 
> 'updatation' == typo?
>
yep. thanks
> >The station should update its rate control on receiving beacon
> >with different HT mode in the HT operation IE. Not doing so,
> >leads to sending frames with higher(ht40) rates whereas AP is
> >running in lower mode (ht20).
> >
> >Signed-off-by: Rajkumar Manoharan<rmanohar@qca.qualcomm.com>
> >---
> >  net/mac80211/mlme.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> >diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> >index c8836fa..56128d3 100644
> >--- a/net/mac80211/mlme.c
> >+++ b/net/mac80211/mlme.c
> >@@ -210,7 +210,7 @@ static u32 ieee80211_config_ht_tx(struct ieee80211_sub_if_data *sdata,
> >  		disable_40 = true;
> >
> >  	if (sta&&  (!reconfig ||
> >-		    (disable_40 != !!(sta->sta.ht_cap.cap&
> >+		    (disable_40 == !!(sta->sta.ht_cap.cap&
> >  					IEEE80211_HT_CAP_SUP_WIDTH_20_40)))) {
> >
Jouni,

To make it more readable, will change as follows

+                (disable_40 != !(sta->sta.ht_cap.cap&

-Rajkumar
