Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43330 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558Ab3FSONe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 10:13:34 -0400
Message-ID: <1371651211.8349.20.camel@jlt4.sipsolutions.net> (sfid-20130619_161337_897598_0DD42CC2)
Subject: Re: [RFC 2/2] mac80211:  Fix bss ref leak.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Jun 2013 16:13:31 +0200
In-Reply-To: <51C08BF3.7050706@candelatech.com>
References: <1371504746-8476-1-git-send-email-greearb@candelatech.com>
	  <1371504746-8476-2-git-send-email-greearb@candelatech.com>
	  (sfid-20130617_233256_432869_08F1495E) <1371569205.8318.47.camel@jlt4.sipsolutions.net>
	 <51C08BF3.7050706@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-06-18 at 09:33 -0700, Ben Greear wrote:
> On 06/18/2013 08:26 AM, Johannes Berg wrote:
> > On Mon, 2013-06-17 at 14:32 -0700, greearb@candelatech.com wrote:
> >
> >>   static void ieee80211_destroy_assoc_data(struct ieee80211_sub_if_data *sdata,
> >> -					 bool assoc)
> >> +					 bool assoc, bool put_bss)
> >
> > Do we _really_ need another argument? Shouldn't it always be put in the
> > non-assoc case anyway, at least if non-NULL?
> 
> I don't think so.  Check out the ieee80211_rx_mgmt_assoc_resp method.
> 
>   	if (status_code != WLAN_STATUS_SUCCESS) {
> 		sdata_info(sdata, "%pM denied association (code=%d)\n",
> 			   mgmt->sa, status_code);
> 		ieee80211_destroy_assoc_data(sdata, false, false);
> 
> This passes in false as 'assoc', but we should not free bss here because
> it is being passed back to the calling method, and the return
> code of RX_MGMT_CFG80211_RX_ASSOC means bss should eventually
> be consumed by the cfg80211 logic.
> 
> Of course, this is all 'as far as I can tell'.
> 
> I sort of like the second boolean because it forces the caller to
> think about whether bss should be freed or not...

I just posted a patch to hand it back and never free it in mac80211 at
all, that also allows cfg80211_hold_bss() it across the assoc process
which fixes a (possibly more theoretical) expiry issue.

johannes

