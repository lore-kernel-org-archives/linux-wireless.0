Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40417 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416AbbICKR6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Sep 2015 06:17:58 -0400
Message-ID: <1441275474.2565.18.camel@sipsolutions.net> (sfid-20150903_121800_532081_007C04B1)
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	Larry.Finger@lwfinger.net
Date: Thu, 03 Sep 2015 12:17:54 +0200
In-Reply-To: <wrfjvbbsp6ot.fsf@redhat.com>
References: <1440883083-32498-1-git-send-email-Jes.Sorensen@redhat.com>
	 <1440883083-32498-2-git-send-email-Jes.Sorensen@redhat.com>
	 <1441032517.13980.21.camel@sipsolutions.net> <wrfjmvx73u0l.fsf@redhat.com>
	 <1441120044.2441.9.camel@sipsolutions.net> <wrfj4mjcqn3x.fsf@redhat.com>
	 <wrfjvbbsp6ot.fsf@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-09-02 at 22:39 -0400, Jes Sorensen wrote:
> 
> I went back and looked at this, and now I remember why I wrote the code
> the way I did. The Realtek firmware handles rate control, so once I set
> IEEE80211_HW_HAS_RATE_CONTROL, I never see
> rate_flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE nor
> tx_info->control_short_preamble.  In order to know whether to tell the
> firmware to request short preamble or not, I needed to track whether the
> sta supports it.
> 
> Do you have a suggestion for how to handle this in a better way?
> 

Ah, this makes sense. There's an rc_update call or something like that,
that might have the requisite information. Not really sure off the top
of my head.

johannes
