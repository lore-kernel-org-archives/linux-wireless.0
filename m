Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:40840 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751267Ab1IUPpI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Sep 2011 11:45:08 -0400
Received: by mail-bw0-f53.google.com with SMTP id zt12so2044370bkb.40
        for <linux-wireless@vger.kernel.org>; Wed, 21 Sep 2011 08:45:06 -0700 (PDT)
Subject: Re: [RFC 3/5] nl80211/cfg80211: adding intermediate scan result
 event.
From: Luciano Coelho <coelho@ti.com>
To: Jouni Malinen <j@w1.fi>
Cc: Victor Goldenshtein <victorg@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20110921153102.GA32374@jm.kir.nu>
References: <1315224151-16552-1-git-send-email-VictorG@ti.com>
	 <1315224151-16552-4-git-send-email-VictorG@ti.com>
	 <1315224512.4075.10.camel@jlt3.sipsolutions.net> <4E6736D9.3070804@ti.com>
	 <1315387619.4002.3.camel@jlt3.sipsolutions.net> <4E686125.5050208@ti.com>
	 <20110921153102.GA32374@jm.kir.nu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Sep 2011 18:45:03 +0300
Message-ID: <1316619903.2157.546.camel@cumari> (sfid-20110921_174512_883180_C3185BA9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-09-21 at 18:31 +0300, Jouni Malinen wrote: 
> On Thu, Sep 08, 2011 at 09:31:01AM +0300, Victor Goldenshtein wrote:
> > You're right, cfg80211 drivers will not support it. As I couldn't
> > find a way to know whether it mac or cfg based driver, I can add
> > also IEEE80211_HW_SUPPORTS_IM_RESULT" flag (as with cancel_scan) and
> > then will advertise the nl80211 command if it set, is it OK?
> 
> Why would cfg80211 drivers not support this? There is already a pending
> patch set to make ath6kl report scan results during the scan with
> cfg80211_inform_bss_frame() so all it would need to do is to add another
> call for cfg80211_send_intermediate_result() to support this...

Yeah, I guess he didn't mean that no cfg80211 drivers support it, but
that some drivers may not support it.  At least this was what we
discussed privately. ;)


> That brings up a question: Do we need to have this new function or would it
> be feasible for cfg80211 to generate the intermediate reports
> automatically based on cfg80211_inform_bss{,_frame}() calls during the
> scan?

Very good point! Thinking of it, there is not need to add this new
function and have the drivers call it.  cfg80211 can find out when to
send the results by itself, whenever someone calls
cfg80211_inform_bss_frame(), by checking whether intermediate results
are enabled or not.

This will simplify the code. :) Thanks for your comments!

-- 
Cheers,
Luca.

