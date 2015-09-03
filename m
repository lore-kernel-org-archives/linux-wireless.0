Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33499 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752185AbbICCjd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2015 22:39:33 -0400
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
	<wrfj4mjcqn3x.fsf@redhat.com>
Date: Wed, 02 Sep 2015 22:39:30 -0400
In-Reply-To: <wrfj4mjcqn3x.fsf@redhat.com> (Jes Sorensen's message of "Wed, 02
	Sep 2015 21:59:30 -0400")
Message-ID: <wrfjvbbsp6ot.fsf@redhat.com> (sfid-20150903_043952_111387_C77D0374)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes Sorensen <Jes.Sorensen@redhat.com> writes:
> Johannes Berg <johannes@sipsolutions.net> writes:
>>>         sta_priv->short_preamble = false;
>>
>> I don't think there's any need to track it, especially since you only
>> use it in TX where you have the TX info data about it.
>
> Oh, I hadn't spotted that information in struct tx_info - in that case I
> ought to be able to get rid of this one.

I went back and looked at this, and now I remember why I wrote the code
the way I did. The Realtek firmware handles rate control, so once I set
IEEE80211_HW_HAS_RATE_CONTROL, I never see
rate_flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE nor
tx_info->control_short_preamble.  In order to know whether to tell the
firmware to request short preamble or not, I needed to track whether the
sta supports it.

Do you have a suggestion for how to handle this in a better way?

Cheers,
Jes
