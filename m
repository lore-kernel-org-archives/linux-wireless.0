Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:37846 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035AbYGHXNK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 19:13:10 -0400
Received: by yx-out-2324.google.com with SMTP id 8so711149yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jul 2008 16:13:09 -0700 (PDT)
Subject: Re: [PATCH 5/6v2] mac80211: rx.c/tx.c remove more users of
	tx/rx_data->fc
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1215558277.3670.24.camel@johannes.berg>
References: <1215550044.476.43.camel@brick>
	 (sfid-20080708_224734_565441_65F98FD9)  <1215552534.3670.20.camel@johannes.berg>
	 <1215553540.476.49.camel@brick>
	 (sfid-20080708_234544_948979_2D1B0842)  <1215554768.3670.22.camel@johannes.berg>
	 <1215555934.476.52.camel@brick>
	 (sfid-20080709_002538_307988_869EF96A)  <1215558277.3670.24.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 08 Jul 2008 16:13:07 -0700
Message-Id: <1215558787.476.56.camel@brick> (sfid-20080709_011314_301102_BE18DAF5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-07-09 at 01:04 +0200, Johannes Berg wrote:
> On Tue, 2008-07-08 at 15:25 -0700, Harvey Harrison wrote:
> > Those functions that still use ieee80211_get_hdrlen are moved over
> > to use the little endian frame control.
> 
> > -	switch (fc & (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) {
> > -	case IEEE80211_FCTL_TODS:
> > -		/* BSSID SA DA */
> > -		memcpy(dst, hdr->addr3, ETH_ALEN);
> > -		memcpy(src, hdr->addr2, ETH_ALEN);
> > -
> > +	switch (hdr->frame_control &
> > +		cpu_to_le16(IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) {
> > +	case __constant_cpu_to_le16(IEEE80211_FCTL_TODS):
> >  		if (unlikely(sdata->vif.type != IEEE80211_IF_TYPE_AP &&
> >  			     sdata->vif.type != IEEE80211_IF_TYPE_VLAN))
> >  			return -1;
> >  		break;
> 
> Looks good, but didn't you just lose all the memcpys?
> 

See the three lines immediately before the part you quoted.

Harvey

