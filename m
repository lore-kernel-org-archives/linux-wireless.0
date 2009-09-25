Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:39852 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752669AbZIYOQB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 10:16:01 -0400
Date: Fri, 25 Sep 2009 15:15:54 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
To: Johannes Berg <johannes@sipsolutions.net>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, linux-wireless@vger.kernel.org
Subject: Re: 2.6.31-git wireless broken
In-Reply-To: <1253868214.3868.713.camel@johannes.local>
Message-ID: <Pine.LNX.4.64.0909251506260.11390@sister.anvils>
References: <Pine.LNX.4.64.0909241737390.20846@sister.anvils>
 <1253813740.3868.324.camel@johannes.local>  <Pine.LNX.4.64.0909241859020.25022@sister.anvils>
  <1253816614.3868.406.camel@johannes.local>  <Pine.LNX.4.64.0909242036270.7469@sister.anvils>
  <1253856038.3868.500.camel@johannes.local>  <Pine.LNX.4.64.0909250838420.3783@sister.anvils>
 <1253868214.3868.713.camel@johannes.local>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 25 Sep 2009, Johannes Berg wrote:
> On Fri, 2009-09-25 at 09:06 +0100, Hugh Dickins wrote:
> 
> > Should be, but you're right, for whatever reason it is not running
> > with these recent kernels.
> > 
> > I expect that correlates with iwconfig showing me ESSID:off/any.
> 
> Well it showing you that means that nothing is even trying to connect :)
> 
> > I'm thinking that (unless you've a better idea) I should do another
> > bisect for when that behaviour starts - hoping that whatever problem
> > led me to your patch, got fixed up later on, but superseded by this
> > different problem.
> 
> Not sure, might be very time consuming.

That bisection, focussing on wpa_supplicant running versus ESSID:off/any
(indeed they match up), now completed on the Aspire One (I'll assume for
the moment that the laptop would show the same).

Yes, it does appear that the patch I originally pointed to introduced a
problem which later got fixed, but was enough to throw the bisection off
when I just looked for "wireless not working".

But you can't escape, you've been too busy, the guilty patch is... 

a9a11622c5c742c115fad371c0397ae86dd3bb67 is first bad commit
commit a9a11622c5c742c115fad371c0397ae86dd3bb67
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Mon Jul 27 12:01:53 2009 +0200

    cfg80211: self-contained wext handling where possible
    
    Finally! This is what you've all been waiting for!
    
    This patch makes cfg80211 take care of wext emulation
    _completely_ by itself, drivers that don't need things
    cfg80211 doesn't do yet don't even need to be aware of
    wireless extensions.
    This means we can also clean up mac80211's and iwm's
    Kconfig and make it possible to build them w/o wext
    now!
    
    		RIP wext.
    
    Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

:040000 040000 ce98d49476cd6547eabab0db90bdff31cc40104e 8ea4d1374da1fb39e1ea431cd07da96ecdccd565 M	drivers
:040000 040000 23a9348f55a10a0c8278049f71be02728514fc61 de6267de96e307e41bb5aded9666c5bc1e4fe938 M	net

RIP wireless - not quite what I'd been waiting for ;)

Hugh
