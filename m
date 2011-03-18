Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:34918 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756818Ab1CRTNp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 15:13:45 -0400
Date: Fri, 18 Mar 2011 20:13:37 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Juan Carlos Garza <juancarlosgarza@gmail.com>
Cc: Ivo Van Doorn <ivdoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org
Subject: Re: [rt2x00-users] rt2800usb stops working with big file transfers
 in AP and IBSS
Message-ID: <20110318191337.GA9288@sig21.net>
References: <AANLkTik9wfkskAHEpmsm4_gPM0FFBf=q8OVXM99NBRjO@mail.gmail.com>
 <201103172107.25316.helmut.schaa@googlemail.com>
 <AANLkTi=u3dw1D1-+-Cy9aEPc2H1MAF+cUi=ucvMTNrNc@mail.gmail.com>
 <201103181642.28386.helmut.schaa@googlemail.com>
 <AANLkTi=oAQ1M=XmFpyjh+2zkHidN_AdG7880A=TGsM-h@mail.gmail.com>
 <20110318165626.GA12889@sig21.net>
 <AANLkTim7QdUByYTDC=ZjjY5ZrAuwhvEUZOKUeGYctXN2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTim7QdUByYTDC=ZjjY5ZrAuwhvEUZOKUeGYctXN2@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 18, 2011 at 06:24:56PM +0100, Juan Carlos Garza wrote:
> On Fri, Mar 18, 2011 at 5:56 PM, Johannes Stezenbach <js@sig21.net> wrote:
> > On Fri, Mar 18, 2011 at 05:15:04PM +0100, Ivo Van Doorn wrote:
> >> I have to do a performance test to see if there are any issues remaining,
> >> but so far all those patches resulted in poorer performance (reduced
> >> association successes).
> >
> > IIRC you did no report any newer test results after
> > http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2011-January/003070.html
> 
> I did get once or twice a warning saying:
> Queue 14 failed to flush, and I think it did not work afterwards...

With my patches applied?  That's not good.  I hope I can find some
time next week to retest with a current wireless-testing tree.

> I do not need to associate, as I use the Access Point rather than a
> Station. Clients could associate with the access point without
> problems. But this patch might bring more stability... can someone
> give me the path to the experimental branch git repository?

http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git

Please be aware that rt2800usb AP currently does not work with
power saving stations, i.e. you have to disable power saving
on the stations (iwconfig wlan0 power off).  Which you
can't on some mobile devices...

(And IIRC rt2800usb stations also still have issues with power saving.)

I was working on a patch for AP mode but I ran out of time and got sucked
into other projects.  There is a broken half-baked patch
in rt2x00/experimental which needs to be reverted, please
no not use.
http://git.kernel.org/?p=linux/kernel/git/ivd/rt2x00.git;a=commit;h=66045e31c8475f69178aea0ef650e7e087929d62
You can find some recent discussion about it in the
rt2x00-users archives.


Johannes
