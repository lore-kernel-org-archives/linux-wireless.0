Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51630 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758026Ab1IIIC2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Sep 2011 04:02:28 -0400
Subject: Re: [PATCH v2 1/3] mac80211: Start implementing QoS support for
 mesh interfaces
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Thomas Pedersen <thomas@cozybit.com>,
	devel@lists.open80211s.org, linux-wireless@vger.kernel.org,
	jlopex@gmail.com
In-Reply-To: <CAPjQAd9+QB2WpovrrLV3ArPRqv-tEY_HY3tKjYjvFcJZxM=LHg@mail.gmail.com> (sfid-20110908_181929_199296_563197DA)
References: <1315442994-304-1-git-send-email-javier@cozybit.com>
	 <1315442994-304-2-git-send-email-javier@cozybit.com>
	 <1315465312.3948.4.camel@jlt3.sipsolutions.net>
	 <CAPjQAd9+QB2WpovrrLV3ArPRqv-tEY_HY3tKjYjvFcJZxM=LHg@mail.gmail.com>
	 (sfid-20110908_181929_199296_563197DA)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Sep 2011 10:02:18 +0200
Message-ID: <1315555338.17050.1.camel@jlt3.sipsolutions.net> (sfid-20110909_100233_232370_CCBDF5B3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-09-08 at 09:17 -0700, Javier Cardona wrote:
> On Thu, Sep 8, 2011 at 12:01 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Wed, 2011-09-07 at 17:49 -0700, Javier Cardona wrote:
> >
> >> +     /* For mesh, the use of the QoS header is mandatory */
> >> +     if (ieee80211_vif_is_mesh(&sdata->vif))
> >> +             sta_flags |= WLAN_STA_WME;
> >> +
> >
> > With patch 3, this piece seems unnecessary?
> 
> At that point we don't know who the next hop peer will so the previous
> block (below) will not find an sta.  Also, we want the QoS header in
> multicast frames.  So I thought this might be the least intrusive way.
> 
> >>>
>         if (!is_multicast_ether_addr(hdr.addr1)) {
>                 rcu_read_lock();
>                 sta = sta_info_get(sdata, hdr.addr1);
>                 if (sta)
>                         sta_flags = get_sta_flags(sta);
>                 rcu_read_unlock();
>         }
> >>>

Ok, yeah, that makes sense.

johannes

