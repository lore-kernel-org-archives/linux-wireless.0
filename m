Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:50943 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751527AbeEBMcm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 May 2018 08:32:42 -0400
Received: from mail-it0-f72.google.com ([209.85.214.72])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1fDqw4-0003u9-Si
        for linux-wireless@vger.kernel.org; Wed, 02 May 2018 12:32:40 +0000
Received: by mail-it0-f72.google.com with SMTP id n190-v6so3403734itg.4
        for <linux-wireless@vger.kernel.org>; Wed, 02 May 2018 05:32:40 -0700 (PDT)
Date: Wed, 2 May 2018 07:32:36 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Haim Dreyfuss <haim.dreyfuss@intel.com>,
        linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Subject: Re: [wireless-regdb] [PATCH 2/2] wireless-regdb: Parse wmm rule data
Message-ID: <20180502123236.GA981@ubuntu-xps13> (sfid-20180502_143318_934936_47B643E8)
References: <1525181772-30337-1-git-send-email-haim.dreyfuss@intel.com>
 <1525181772-30337-2-git-send-email-haim.dreyfuss@intel.com>
 <20180501200256.GM3502@ubuntu-xps13>
 <1525209561.25505.3.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1525209561.25505.3.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 01, 2018 at 11:19:21PM +0200, Johannes Berg wrote:
> On Tue, 2018-05-01 at 15:02 -0500, Seth Forshee wrote:
> > 
> > > +import attr
> > 
> > I'm a little hesitant to add use of non-standard libraries if it isn't
> > necessary, as some distros have traditionally built the regdb from
> > source (not sure how practical that is after the db-as-firmware changes
> > though). Do we lose anything critical if we don't use attr?
> 
> I probably suggested the use of attr. It's super useful, for things like
> this:
> 
> > > +@attr.s(frozen=True)
> > > +class WmmRule(object):
> > > +    vo_c = attr.ib()
> > > +    vi_c = attr.ib()
> > > +    be_c = attr.ib()
> > > +    bk_c = attr.ib()
> > > +    vo_ap = attr.ib()
> > > +    vi_ap = attr.ib()
> > > +    be_ap = attr.ib()
> > > +    bk_ap = attr.ib()
> > > +
> > > +    def _as_tuple(self):
> > > +        return (self.vo_c, self.vi_c, self.be_c, self.bk_c,
> > > +                self.vo_ap, self.vi_ap, self.be_ap, self.bk_ap)
> 
> Spelling this out as a real object with all the __repr__ and comparisons
> etc. gets far more verbose.
> 
> While we can get rid of it in theory, it's a ~100KiB package without any
> further dependencies, and the code is better off for it.
> 
> Ultimately it's your decision, but I suspect that python is already such
> a big dependency that adding this library is in the noise.

I'm more thinking that for e.g. Debian if attr is installed via pip and
not a distro package then that might be a problem for their package
builds. But let's go ahead and leave it, if there's fallout we can
figure that out later.

Thanks,
Seth
