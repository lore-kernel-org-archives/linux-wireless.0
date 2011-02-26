Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38109 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab1BZSAL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Feb 2011 13:00:11 -0500
Received: by iwn34 with SMTP id 34so1964756iwn.19
        for <linux-wireless@vger.kernel.org>; Sat, 26 Feb 2011 10:00:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1298648961.4329.19.camel@jlt3.sipsolutions.net>
References: <20110225112409.977212647@sipsolutions.net> <20110225112620.515442527@sipsolutions.net>
 <1298648166.2603.11.camel@wwguy-ubuntu> <1298648386.4329.18.camel@jlt3.sipsolutions.net>
 <1298647873.28351.10.camel@wwguy-huron> <1298648961.4329.19.camel@jlt3.sipsolutions.net>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Sat, 26 Feb 2011 09:59:51 -0800
Message-ID: <AANLkTimrXV=b6aC1L65iOP1Mi8y1FDhzmdLoe4=KOxSC@mail.gmail.com>
Subject: Re: [PATCH 2/2] iwlagn: fix iwlagn_check_needed_chains
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
	John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Swati Rallapalli <swati@cs.utexas.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Acked-by: Daniel Halperin <dhalperi@cs.washington.edu>
Tested-by: Daniel Halperin <dhalperi@cs.washington.edu>

(I suppose those are redundant?)

Dan

On Fri, Feb 25, 2011 at 7:49 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
> On Fri, 2011-02-25 at 07:31 -0800, Guy, Wey-Yi wrote:
> > On Fri, 2011-02-25 at 07:39 -0800, Johannes Berg wrote:
> > > On Fri, 2011-02-25 at 07:36 -0800, wwguy wrote:
> > >
> > > > > @@ -503,7 +488,46 @@ static void iwlagn_check_needed_chains(s
> > > > >                          * will soon tell us about that.
> > > > >                          */
> > > > >                         need_multiple = false;
> > > > > +                       rcu_read_unlock();
> > > > > +                       break;
> > > >
> > > > why unlock and break here instead stay do it later like before?
> > >
> > > Only because the indentation there was getting so deep it was annoying
> > > to fit into 80 cols :-)
> >
> > how you want to submit this patch? through iwlagn, or yo uwill send it
> > along with mac80211 to John?
>
> Don't really care. I just sent them both here to keep them together and
> for Daniel and Swati ... First though, I'd like them to test it maybe.
>
> johannes
>
