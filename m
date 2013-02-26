Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47684 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641Ab3BZUwe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2013 15:52:34 -0500
Message-ID: <1361911935.8440.18.camel@jlt4.sipsolutions.net> (sfid-20130226_215237_339392_8E4156A0)
Subject: Re: [PATCHv2 2/3] mac80211: mesh power save doze scheduling
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco@cozybit.com>
Cc: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	sleffler@google.com, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org, ath9k-devel@lists.ath9k.org
Date: Tue, 26 Feb 2013 21:52:15 +0100
In-Reply-To: <512B37BA.6060605@cozybit.com> (sfid-20130225_110654_178953_AA37B00E)
References: <1361203709-16669-1-git-send-email-marco@cozybit.com>
	  <1361203709-16669-2-git-send-email-marco@cozybit.com>
	  (sfid-20130218_170842_350606_DE89DB9F) <1361372480.8629.33.camel@jlt4.sipsolutions.net>
	 <512B37BA.6060605@cozybit.com> (sfid-20130225_110654_178953_AA37B00E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-25 at 11:06 +0100, Marco Porsch wrote:

> > This is strange, why bother with the else if there's a continue?
> 
> I don't quite get this comment. The current logic is like this:
> 
> if (unrelated cases) {
> 	continue;
> } else if (related and blocking) {
> 	allow = false;
> 	break;
> } else if (related, non-blocking and new minimum) {
> 	min = sta->nexttbtt;
> }

Yeah I guess I don't see why it's not just

        if (unrelated cases)
        	continue;
        
        if (related & blocking) {
        	allow = false;
        	break;
        }
        
        if (...)
        	min = ...
        
but it really doesn't matter much.

> >> +               } else if (test_sta_flag(sta, WLAN_STA_MPS_WAIT_FOR_CAB) ||
> >> +                          test_sta_flag(sta, WLAN_STA_MPSP_OWNER) ||
> >> +                          test_sta_flag(sta, WLAN_STA_MPSP_RECIPIENT) ||
> >> +                          !timer_pending(&sta->nexttbtt_timer) ||
> >> +                          time_after(jiffies, sta->nexttbtt_jiffies)) {
> >
> > Are you sure jiffies are good enough? Some systems have HZ=33 or so I
> > think, which makes a jiffy like 30ms.
> 
> Hm, jiffies is what I have available easily. Using the TSF would be 
> obvious but may suffer from delay when obtaining it. Umm... hrtimers again?

I really don't care about your messed up timing stuff here, just
saying :)

johannes

