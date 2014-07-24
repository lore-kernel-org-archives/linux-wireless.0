Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33445 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759157AbaGXNB6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 09:01:58 -0400
Message-ID: <1406206914.14675.20.camel@jlt4.sipsolutions.net> (sfid-20140724_150207_773531_81C841FA)
Subject: Re: [PATCHv2 2/2] mac80211: extend set_coverage_class signature
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Philippe Duchein <wireless-dev@duchein.net>
Date: Thu, 24 Jul 2014 15:01:54 +0200
In-Reply-To: <CAA2SeNLPf6Tt61H5D1j6d3SwO1nuZQM3WuqL8-+15RKLmVAe1w@mail.gmail.com> (sfid-20140724_141224_734190_5E59242F)
References: <1406198362-4999-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 <1406198362-4999-3-git-send-email-lorenzo.bianconi83@gmail.com>
	 <1406200353.14675.18.camel@jlt4.sipsolutions.net>
	 <CAA2SeNLPf6Tt61H5D1j6d3SwO1nuZQM3WuqL8-+15RKLmVAe1w@mail.gmail.com>
	 (sfid-20140724_141224_734190_5E59242F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-07-24 at 14:12 +0200, Lorenzo Bianconi wrote:
> > On Thu, 2014-07-24 at 12:39 +0200, Lorenzo Bianconi wrote:
> >
> >> @@ -2950,7 +2951,7 @@ struct ieee80211_ops {
> >>       int (*get_survey)(struct ieee80211_hw *hw, int idx,
> >>               struct survey_info *survey);
> >>       void (*rfkill_poll)(struct ieee80211_hw *hw);
> >> -     void (*set_coverage_class)(struct ieee80211_hw *hw, u8 coverage_class);
> >> +     int (*set_coverage_class)(struct ieee80211_hw *hw, s16 coverage_class);
> >
> > This patch also needs to update all drivers ......
> 
> Currently just ath9k, ath5k and p54 implement set_coverage_class
> function pointer. I would send a different patch for these changes.
> Should I include them in this patchset?

Guess what will happen if I merge this patch?

Hint: the kernel will not compile correctly any more.

johannes

