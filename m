Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760308AbbIDSYM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Sep 2015 14:24:12 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	Larry.Finger@lwfinger.net
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
References: <1440883083-32498-1-git-send-email-Jes.Sorensen@redhat.com>
	<1440883083-32498-2-git-send-email-Jes.Sorensen@redhat.com>
	<1441032517.13980.21.camel@sipsolutions.net>
	<wrfjmvx73u0l.fsf@redhat.com>
	<1441120044.2441.9.camel@sipsolutions.net>
	<wrfj4mjcqn3x.fsf@redhat.com> <wrfjvbbsp6ot.fsf@redhat.com>
	<1441275474.2565.18.camel@sipsolutions.net>
Date: Fri, 04 Sep 2015 14:24:09 -0400
In-Reply-To: <1441275474.2565.18.camel@sipsolutions.net> (Johannes Berg's
	message of "Thu, 03 Sep 2015 12:17:54 +0200")
Message-ID: <wrfjmvx2gi0m.fsf@redhat.com> (sfid-20150904_202415_877129_470DFED2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:
> On Wed, 2015-09-02 at 22:39 -0400, Jes Sorensen wrote:
>> 
>> I went back and looked at this, and now I remember why I wrote the code
>> the way I did. The Realtek firmware handles rate control, so once I set
>> IEEE80211_HW_HAS_RATE_CONTROL, I never see
>> rate_flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE nor
>> tx_info->control_short_preamble.  In order to know whether to tell the
>> firmware to request short preamble or not, I needed to track whether the
>> sta supports it.
>> 
>> Do you have a suggestion for how to handle this in a better way?
>> 
>
> Ah, this makes sense. There's an rc_update call or something like that,
> that might have the requisite information. Not really sure off the top
> of my head.

I'll add a comment to the code explaining why it is done this way. I had
a peak at the rate_control code earlier, but it wasn't obvious to me
whether I should be using that API at all. Is there an explanation of
the API and it's usage somewhere?

Cheers,
Jes


