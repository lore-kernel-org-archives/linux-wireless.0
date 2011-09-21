Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:38813 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978Ab1IUPbM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 11:31:12 -0400
Date: Wed, 21 Sep 2011 18:31:02 +0300
From: Jouni Malinen <j@w1.fi>
To: Victor Goldenshtein <victorg@ti.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [RFC 3/5] nl80211/cfg80211: adding intermediate scan result
 event.
Message-ID: <20110921153102.GA32374@jm.kir.nu> (sfid-20110921_173115_534140_CC0BF823)
References: <1315224151-16552-1-git-send-email-VictorG@ti.com>
 <1315224151-16552-4-git-send-email-VictorG@ti.com>
 <1315224512.4075.10.camel@jlt3.sipsolutions.net>
 <4E6736D9.3070804@ti.com>
 <1315387619.4002.3.camel@jlt3.sipsolutions.net>
 <4E686125.5050208@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E686125.5050208@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 08, 2011 at 09:31:01AM +0300, Victor Goldenshtein wrote:
> You're right, cfg80211 drivers will not support it. As I couldn't
> find a way to know whether it mac or cfg based driver, I can add
> also IEEE80211_HW_SUPPORTS_IM_RESULT" flag (as with cancel_scan) and
> then will advertise the nl80211 command if it set, is it OK?

Why would cfg80211 drivers not support this? There is already a pending
patch set to make ath6kl report scan results during the scan with
cfg80211_inform_bss_frame() so all it would need to do is to add another
call for cfg80211_send_intermediate_result() to support this... That
brings up a question: Do we need to have this new function or would it
be feasible for cfg80211 to generate the intermediate reports
automatically based on cfg80211_inform_bss{,_frame}() calls during the
scan?

-- 
Jouni Malinen                                            PGP id EFC895FA
