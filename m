Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.174]:6033 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbYCFS1i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2008 13:27:38 -0500
Received: by ug-out-1314.google.com with SMTP id z38so3934064ugc.16
        for <linux-wireless@vger.kernel.org>; Thu, 06 Mar 2008 10:27:34 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: handling Qdisc issues
Date: Thu, 6 Mar 2008 19:27:09 +0100
Cc: Ron Rindjunsky <ron.rindjunsky@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, tomas.winkler@intel.com
References: <1204822307-5111-1-git-send-email-ron.rindjunsky@intel.com> <200803061902.33865.IvDoorn@gmail.com> <1204826767.25502.135.camel@johannes.berg>
In-Reply-To: <1204826767.25502.135.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200803061927.09891.IvDoorn@gmail.com> (sfid-20080306_182742_939650_68D7DF0F)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 06 March 2008, Johannes Berg wrote:
> 
> > > +#if TODO
> > > +Is this correct??
> > > +#endif
> > > +	rt2x00lib_write_tx_desc(rt2x00dev, skb, control, queue->qid);
> > 
> > This is incorrect, even though it theoretically would work.
> > The qid != queue number, for most TX queues the value will be the same,
> > but the meaning of the field is different.
> 
> Hence my #if TODO which causes sparse to warn about the code :) I meant
> to ask you but never had time to continue working on this patch.
> 
> > Resolving this issue will also be something I can fix relatively fast after this
> > patch is accepted and applied to wireless-testing.
> 
> You could also just make a patch for exactly this and ask Ron to merge
> it together with this?

Well that patch would then be completely untested (I code, but have hardly time
to perform the testing myself).
I can already say that the patch from Ron will work despite the my
remark about the different meaning of the qid field.
My patch that will clean it up, and will fix the issue, will be something
that needs testing before it should be send upstream...
I want to prevent messes like the rt2x00 2.1.0 release, which was broken
in every possible way, from happening again in wireless-testing ;)

Ivo
