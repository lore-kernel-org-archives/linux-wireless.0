Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43742 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753685AbdBNNer (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 08:34:47 -0500
Message-ID: <1487079282.4705.16.camel@sipsolutions.net> (sfid-20170214_143810_381985_CB02C75D)
Subject: Re: [RFC V2 1/5] nl80211: allow multiple active scheduled scan
 requests
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 14 Feb 2017 14:34:42 +0100
In-Reply-To: <fbaa960e-b14a-e50c-c49e-913e823b1e74@broadcom.com> (sfid-20170214_143342_105651_593FDD48)
References: <1484566941-27000-1-git-send-email-arend.vanspriel@broadcom.com>
         <1484566941-27000-2-git-send-email-arend.vanspriel@broadcom.com>
         <1485250815.7244.8.camel@sipsolutions.net>
         <fbaa960e-b14a-e50c-c49e-913e823b1e74@broadcom.com>
         (sfid-20170214_143342_105651_593FDD48)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-02-14 at 14:33 +0100, Arend Van Spriel wrote:
> On 24-1-2017 10:40, Johannes Berg wrote:
> > > +	/* leave request id zero for legacy request
> > > +	 * or if driver does not support multi-scheduled scan
> > > +	 */
> > > +	if (want_multi && rdev->wiphy.max_sched_scan_reqs > 1) {
> > 
> > Why do the >1 check here? It probably doesn't really make a
> > difference
> > since only one can be running at a time, but it might be nicer - at
> > least for debug in userspace - to have a real value for all multi
> > scans?
> 
> I added the check, because drivers not supporting multi-scheduled
> scan might not bother using the request id in event reporting.

Ok, that's a good point.

johannes
