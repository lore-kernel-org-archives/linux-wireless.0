Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.184]:61518 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbYIBUx7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 16:53:59 -0400
Received: by fk-out-0910.google.com with SMTP id 18so1959917fkq.5
        for <linux-wireless@vger.kernel.org>; Tue, 02 Sep 2008 13:53:57 -0700 (PDT)
Date: Tue, 2 Sep 2008 23:53:52 +0300
From: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Zhu Yi <yi.zhu@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	LKML <linux-kernel@vger.kernel.org>, reinette.chatre@intel.com,
	linux-wireless@vger.kernel.org,
	Jan-Espen Pettersen <sigsegv@radiotube.org>
Subject: Re: new: regression iwl3945/mac80211 endless after suspend
	associate/deassociate loop
Message-ID: <20080902205351.GB8230@google.com> (sfid-20080902_225404_566029_ADCBEB1C)
References: <20080901160658.GA11063@google.com> <1220319536.28282.128.camel@debian.sh.intel.com> <4b0be9b641de902cb7de4ad50686f6e1.squirrel@secure.sipsolutions.net> <20080902130429.GB19172@google.com> <1220362201.3176.4.camel@borkbork.foobar.com> <20080902145840.GE19172@google.com> <20080902150625.GC3050@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080902150625.GC3050@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 02, 2008 at 11:06:25AM -0400, John W. Linville wrote:
> On Tue, Sep 02, 2008 at 05:58:41PM +0300, Michael S. Tsirkin wrote:
> > On Tue, Sep 02, 2008 at 09:30:01AM -0400, Dan Williams wrote:
> > > On Tue, 2008-09-02 at 16:04 +0300, Michael S. Tsirkin wrote:
> 
> > > > But it happens to work fine without 8ab65b03b7893da4a49009e7e356e36e27b0c407.
> > > 
> > > That's really odd; that patch (the don't-send-empty-extended-rates-IE
> > > patch) shouldn't have anything to do with this behavior, if it did you
> > > wouldn't get associated to the AP in the first place I think.  You're
> > > 100% sure that this patch is causing the problem?
> > 
> > No, not sure. But reverting it seems to have helped.
> > And there does not seem to be anything else relevant between rc4 and
> > rc5.
> 
> So you determined that commit by eye rather than by git bisect?

Yes.

> Any chance I could talk you into confirming that using git bisect?

It's a bit time consuming because the bug triggers often, but not in
100% of suspends. So you need to fiddle with it a bit after each
bisect to figure out whether it's there.

> Thanks,
> 
> John
> -- 
> John W. Linville
> linville@tuxdriver.com
