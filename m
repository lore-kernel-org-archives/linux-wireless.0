Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:2766 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbXLSTUn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 14:20:43 -0500
MIME-Version: 1.0
Subject: RE: [PATCH 2/8] mac80211: A-MPDU Rx add MLME structures
Date: Wed, 19 Dec 2007 20:59:59 +0200
Message-ID: <1879838866982C46A9CB3D56BA49ADEB04313CF8@hasmsx411.ger.corp.intel.com> (sfid-20071219_192047_327571_EBFD1FC6)
In-Reply-To: <1198012693.4885.180.camel@johannes.berg>
References: <11979070692599-git-send-email-ron.rindjunsky@intel.com> <11979070782201-git-send-email-ron.rindjunsky@intel.com> <1197914893.4885.76.camel@johannes.berg> <c85cb4470712180541l3427454ek94c66b14bb26cb4f@mail.gmail.com> (sfid-20071218_134145_320212_A4A350F5) <1198012693.4885.180.camel@johannes.berg>
From: "Rindjunsky, Ron" <ron.rindjunsky@intel.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<flamingice@sourmilk.net>,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	"Zhu, Yi" <yi.zhu@intel.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > > +     struct sta_ampdu_mlme ampdu_mlme;
> > > +     int timer_to_tid[STA_TID_NUM];  /* convert timer id to tid
*/
> >
> > Since you only use that as an identity mapping it can well be a u8
> > array. Not that I like the trick used, but I don't see any good way
to
> > avoid it either.
> >
> 
> yes... that was quite an irritating issue, had to use this kind of
> mechanism here.
> i will check changing type to u8 (need to exmine if it will cause any
> addresses problems)

> I just checked, it's an unsigned long and not an address so you can
> really pass anything to it. Therefore, I think using a u8 array would
be
> appropriate.

Yes, I also checked and it seems ok.

> johannes
---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

