Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:13483 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbYGHVpn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2008 17:45:43 -0400
Received: by yx-out-2324.google.com with SMTP id 8so697450yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 08 Jul 2008 14:45:42 -0700 (PDT)
Subject: Re: [PATCH 5/6] mac80211: rx.c/tx.c remove more users of
	tx/rx_data->fc
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1215552534.3670.20.camel@johannes.berg>
References: <1215550044.476.43.camel@brick>
	 (sfid-20080708_224734_565441_65F98FD9)  <1215552534.3670.20.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 08 Jul 2008 14:45:40 -0700
Message-Id: <1215553540.476.49.camel@brick> (sfid-20080708_234551_595915_4CE5D97F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-07-08 at 23:28 +0200, Johannes Berg wrote:
> >  
> > -	switch (fc & (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) {
> > -	case IEEE80211_FCTL_TODS:
> 
> > +	if (ieee80211_has_a4(hdr->frame_control)) {
> > +		if (unlikely(sdata->vif.type != IEEE80211_IF_TYPE_WDS &&
> > +			     sdata->vif.type != IEEE80211_IF_TYPE_MESH_POINT))
> > +			return -1;
> > +	} else if (ieee80211_has_tods(hdr->frame_control)) {
> 
> I don't particularly like converting a switch statement to chained ifs
> in this path, you even put the most unlikely one first. With the switch,
> the compiler should be able to generate just two compares for each path
> (binary tree), while with this the common STA path already needs three.
> 
> We could instead open-code the binary tree that the compiler should
> create for the switch, I guess, i.e.

Well, I suppose I can also take another crack at getting my updated byteorder
patches in that allows cpu_to_le16, etc to be in a case statement, then the
switch could be preserved  and the byteswaps can be done at compile time.

I'll go take another crack at it I suppose, but it seems to meet with stunning
silence whenever I post it :-(

Harvey


