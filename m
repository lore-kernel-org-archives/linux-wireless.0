Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:45980 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161179Ab3BONaZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 08:30:25 -0500
Received: by mail-bk0-f41.google.com with SMTP id q16so1563981bkw.0
        for <linux-wireless@vger.kernel.org>; Fri, 15 Feb 2013 05:30:24 -0800 (PST)
Message-ID: <511E386D.1010806@cozybit.com> (sfid-20130215_143029_411568_3FB97627)
Date: Fri, 15 Feb 2013 14:30:21 +0100
From: Marco Porsch <marco@cozybit.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: devel@lists.open80211s.org, vthiagar@qca.qualcomm.com,
	jouni@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	mcgrof@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
	senthilb@qca.qualcomm.com, johannes@sipsolutions.net
Subject: Re: [PATCH 1/3] mac80211: move mesh sync beacon handler into neighbour_update
References: <1360928446-543-1-git-send-email-marco@cozybit.com> <1360930499.15040.7.camel@jlt4.sipsolutions.net> <20130215124046.GA3493@localhost> <20130215124255.GB3493@localhost>
In-Reply-To: <20130215124255.GB3493@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 02/15/2013 01:42 PM, Bob Copeland wrote:
> On Fri, Feb 15, 2013 at 07:40:46AM -0500, Bob Copeland wrote:
>>> I don't think you should drop this comment; also why not just address
>>> it? There's a timestamp in rx_status that should be the correct one for
>>> ath9k (which is pretty much all this seems to work on anyway :) )
>>
>> The comment is just moved?  Mesh already uses rx_status->mactime, if
>> the driver supplies it, which the comment says :)
>
> Oh I see - you are saying not to drop the comment about rcu locking.

 > diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
 > index f7526e5..fe6fc22 100644
 > --- a/net/mac80211/mesh_plink.c
 > +++ b/net/mac80211/mesh_plink.c
 > @@ -488,13 +489,19 @@ mesh_sta_info_get(struct ieee80211_sub_if_data 
*sdata,
 >    * Initiates peering if appropriate.
 >    */
 >   void mesh_neighbour_update(struct ieee80211_sub_if_data *sdata,
 > -			   u8 *hw_addr,
 > -			   struct ieee802_11_elems *elems)
 > +			   struct ieee80211_mgmt *mgmt,
 > +			   struct ieee802_11_elems *elems,
 > +			   struct ieee80211_rx_status *rx_status)
 >   {
 > +	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 >   	struct sta_info *sta;
 >   	u32 changed = 0;
 > +	u64 tsf;
 >
 > -	sta = mesh_sta_info_get(sdata, hw_addr, elems);
 > +	/* get tsf before entering rcu-read section */

The comment about RCU lock moved here.

 > +	tsf = drv_get_tsf(sdata->local, sdata);
 > +
 > +	sta = mesh_sta_info_get(sdata, mgmt->sa, elems);
 >   	if (!sta)
 >   		goto out;
 >

--Marco
