Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57054 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbaLUQZG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2014 11:25:06 -0500
Message-ID: <1419179100.2387.3.camel@sipsolutions.net> (sfid-20141221_172522_525637_FBBD7DB4)
Subject: Re: [PATCH] mac80211: fix dot11MulticastTransmittedFrameCount
 tested address
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: Fred Chou <fred.chou.nd@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Sun, 21 Dec 2014 17:25:00 +0100
In-Reply-To: <CAB3XZEeQJs7pye+SBr-s09gO8crqkbVWJndVKx836QGQcrjKDQ@mail.gmail.com> (sfid-20141221_162758_580385_FD188582)
References: <1419168328-6114-1-git-send-email-eliad@wizery.com>
	 <5496D6F6.6050001@gmail.com>
	 <CAB3XZEeQJs7pye+SBr-s09gO8crqkbVWJndVKx836QGQcrjKDQ@mail.gmail.com>
	 (sfid-20141221_162758_580385_FD188582)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-12-21 at 17:27 +0200, Eliad Peller wrote:
> On Sun, Dec 21, 2014 at 4:19 PM, Fred Chou <fred.chou.nd@gmail.com> wrote:
> > On 21/12/2014 9:25 PM, Eliad Peller wrote:
> >> dot11MulticastTransmittedFrameCount should be updated according
> >> to the DA, which might be different from hdr1.
> >
> > Shouldn't address 1 be used to determine whether the MPDU is multicast?
> > From Std-2012 definition of multicast: "When applied to a MAC protocol
> > data unit (MPDU), it is an MPDU with a group address in the Address 1
> > field."
> >
> good point. i guess it depends on the meaning of
> dot11MulticastTransmittedFrameCount -
> multicast frames sent by sta are not multicast frames per se (as they
> are sent directly to the AP), but they are destined to multicast
> group.
> 
> i tried understanding the meaning of this MIB from here (as i couldn't
> find clear definition in the spec):
> http://tools.cisco.com/Support/SNMP/do/BrowseOID.do?local=en&translate=Translate&objectInput=dot11MulticastTransmittedFrameCount

Yeah I can't find a good reference in the spec either - anyone want to
dig through the flow charts? :)

Btw, since this is ancient code from devicescape, it is possible that
they only cared about AP mode then - and there there's no difference
between the addresses.

> where it seems to be similar (IIUC) to the way i interpreted it, but i
> might got it wrong :)

I think you're probably right - however I wonder if we can stick the
code elsewhere (like subif xmit?) instead of introducing more
conditionals here?

johannes

