Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44634 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932219Ab3BKVma (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 16:42:30 -0500
Message-ID: <1360618939.8738.50.camel@jlt4.sipsolutions.net> (sfid-20130211_224234_119664_1D99BA93)
Subject: Re: [PATCH] rtlwifi: Initialize rate_init member of struct
 rate_control_ops
From: Johannes Berg <johannes@sipsolutions.net>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Catalin Iacob <iacobcatalin@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 11 Feb 2013 22:42:19 +0100
In-Reply-To: <511964AB.6080701@lwfinger.net> (sfid-20130211_223751_227537_E9EE373A)
References: <1360617485-6194-1-git-send-email-iacobcatalin@gmail.com>
	 <511964AB.6080701@lwfinger.net> (sfid-20130211_223751_227537_E9EE373A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-11 at 15:37 -0600, Larry Finger wrote:

> > +	.rate_init = rtl_rate_init,
> >   	.tx_status = rtl_tx_status,
> >   	.get_rate = rtl_get_rate,
> >   };
> 
> Shouldn't rate_control_rate_init() in net/mac80211/rate.h be changed to protect 
> against the oops? I don't see any value in the client driver having to provide a 
> dummy routine. The rtlwifi family of drivers use their own rate-control 
> mechanism, and get no rate-control info from mac80211.

In this case, I see no value in them providing rate control operations
at all, and they could just set IEEE80211_HW_HAS_RATE_CONTROL, no?

johannes

