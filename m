Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:54547 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbYEMMlo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 08:41:44 -0400
Received: by ug-out-1314.google.com with SMTP id h2so880810ugf.16
        for <linux-wireless@vger.kernel.org>; Tue, 13 May 2008 05:41:42 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: mac80211: Set IEEE80211_TXPD_REQ_TX_STATUS for all TX frames
Date: Tue, 13 May 2008 14:53:04 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
References: <200805111434.19071.IvDoorn@gmail.com> <200805131346.35897.IvDoorn@gmail.com> <1210681791.3646.70.camel@johannes.berg>
In-Reply-To: <1210681791.3646.70.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200805131453.04853.IvDoorn@gmail.com> (sfid-20080513_144147_295398_5B290EEC)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 13 May 2008, Johannes Berg wrote:
> 
> > > What about monitor interfaces/injection? Do they already set it?
> > 
> > No, should they?
> 
> Yes, I think so, since hostapd uses injection for frames and definitely
> needs status callback. We could later define a radiotap bit for that, of
> course.

Ok, I'll update the patch.

> > We could even make it so that the mac80211 tx_status handler will ignore
> > the frame when the flag is set so drivers won't have to look at it at all.
> 
> You mean "when the flag is unset"? Not sure, maybe we should, but we'll
> see that when more uses for it come up/better rate control algorithms
> are developed.

The most important frames the issue currently arises is with RTS and CTS-to-self
frames. rt2x00 requests those frames from mac80211 and currently clears the
IEEE80211_TXCTL_REQ_TX_STATUS flag to prevent it being send to mac80211
to not upset the rc-algorithm.

Ivo
