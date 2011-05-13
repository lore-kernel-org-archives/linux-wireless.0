Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:49159 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758028Ab1EMMSM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 08:18:12 -0400
Received: by mail-ew0-f47.google.com with SMTP id 5so724527ewy.6
        for <linux-wireless@vger.kernel.org>; Fri, 13 May 2011 05:18:10 -0700 (PDT)
Subject: Re: [PATCH v3 1/3] cfg80211/nl80211: add support for scheduled
 scans
From: Luciano Coelho <coelho@ti.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, eliad@wizery.com
In-Reply-To: <1305283963.3487.12.camel@jlt3.sipsolutions.net>
References: <1305122977-6740-1-git-send-email-coelho@ti.com>
	 <1305122977-6740-2-git-send-email-coelho@ti.com>
	 <20110512150530.GB2171@redhat.com> <1305217201.12586.949.camel@cumari>
	 <20110513104524.GA14971@redhat.com>
	 <1305283963.3487.12.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 15:18:06 +0300
Message-ID: <1305289086.12586.1111.camel@cumari> (sfid-20110513_141815_930735_82DC372A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-05-13 at 12:52 +0200, Johannes Berg wrote:
> On Fri, 2011-05-13 at 12:45 +0200, Stanislaw Gruszka wrote:
> 
> > > because the scheduled scan is a long-term operation and the normal scan
> > > is done for a very short time (and the rest of the stack assumes it will
> > > complete quickly enough as not to interfere with the connection.
> > 
> > Hmm, is this drawback of implementation or can not be done technically
> > (question to myself :-) ? I can image that in ideal case hardware scanning
> > will not affect normal operation, no matter how long it will take.
> > Software scan is much worse, since we have to change channels manually.
> > We currently share code between software scan and hardware scan in
> > mac80211. Perhaps separating hw and sw scan code, would be a good idea
> > and allow to consolidate hw scan and sched scan. I planning to look
> > at this more closely.
> 
> Well, it's also a semantic question. If you trigger a scan, you expect a
> result (or an abort) after a while. It could of course be extended with
> a new attribute, but the error checking for that gets complicated,
> especially if you consider older kernels that would simply ignore that
> new attribute.
> 
> So basically, the only difference between "trigger scan (scheduled=1)"
> and "trigger scheduled scan" (which this implements) would be in
> nl80211. Everything else would have to separate them, since there are a
> lot of internal things that behave differently depending on whether a
> scan is running or not. Add the error checking, and I think we've got a
> good case for new API :)

I agree.  I think it's better to keep it simpler with a new command.
Especially because the scheduled scan command will be extended with a
few more arguments, which may not make sense with normal scans, such as
filters etc.

-- 
Cheers,
Luca.

