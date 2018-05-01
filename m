Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:44948 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751004AbeEAVTY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 May 2018 17:19:24 -0400
Message-ID: <1525209561.25505.3.camel@sipsolutions.net> (sfid-20180501_232252_644030_BDF96EEC)
Subject: Re: [wireless-regdb] [PATCH 2/2] wireless-regdb: Parse wmm rule data
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>,
        Haim Dreyfuss <haim.dreyfuss@intel.com>
Cc: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Date: Tue, 01 May 2018 23:19:21 +0200
In-Reply-To: <20180501200256.GM3502@ubuntu-xps13>
References: <1525181772-30337-1-git-send-email-haim.dreyfuss@intel.com>
         <1525181772-30337-2-git-send-email-haim.dreyfuss@intel.com>
         <20180501200256.GM3502@ubuntu-xps13>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-05-01 at 15:02 -0500, Seth Forshee wrote:
> 
> > +import attr
> 
> I'm a little hesitant to add use of non-standard libraries if it isn't
> necessary, as some distros have traditionally built the regdb from
> source (not sure how practical that is after the db-as-firmware changes
> though). Do we lose anything critical if we don't use attr?

I probably suggested the use of attr. It's super useful, for things like
this:

> > +@attr.s(frozen=True)
> > +class WmmRule(object):
> > +    vo_c = attr.ib()
> > +    vi_c = attr.ib()
> > +    be_c = attr.ib()
> > +    bk_c = attr.ib()
> > +    vo_ap = attr.ib()
> > +    vi_ap = attr.ib()
> > +    be_ap = attr.ib()
> > +    bk_ap = attr.ib()
> > +
> > +    def _as_tuple(self):
> > +        return (self.vo_c, self.vi_c, self.be_c, self.bk_c,
> > +                self.vo_ap, self.vi_ap, self.be_ap, self.bk_ap)

Spelling this out as a real object with all the __repr__ and comparisons
etc. gets far more verbose.

While we can get rid of it in theory, it's a ~100KiB package without any
further dependencies, and the code is better off for it.

Ultimately it's your decision, but I suspect that python is already such
a big dependency that adding this library is in the noise.

johannes
