Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:53159 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbZAWTig (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 14:38:36 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
Subject: Re: integration of opensource firmware with b43 kernel driver
Date: Fri, 23 Jan 2009 20:37:42 +0100
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <FF33C500-6653-4A69-B34D-FBE47B2136D3@ing.unibs.it> <497A05DC.4040101@lwfinger.net> <01F0FEC9-8ECF-4284-9428-701B976286D6@ing.unibs.it>
In-Reply-To: <01F0FEC9-8ECF-4284-9428-701B976286D6@ing.unibs.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200901232037.42512.mb@bu3sch.de> (sfid-20090123_203841_350513_68CC3E7C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 23 January 2009 20:24:47 Francesco Gringoli wrote:
> On Jan 23, 2009, at 7:01 PM, Larry Finger wrote:
> 
> > Francesco Gringoli wrote:
> >> Hello,
> >>
> >> we have been testing the firmware for a week now and it seems  
> >> stable. I
> >> personally tested it also on a Linksys WRT54GL and it works both in
> >> station and in AP modes. I collected the feedbacks that some of you  
> >> sent
> >> and it seems that the firmware now runs on these board:
> >>
> >> - 4306, 4311, 4318, 4320
> >
> > As a point of clarification, I think this is restricted to the 4311/1
> > as the 4311/2 uses ucode13, not ucode5. If you need a tester for an
> > open-source version of the 13 firmware, I'm available.
> Damn... that would be a very hard writing.... We do not have any  
> 4311/2 board: at first glance there are more condition registers whose  
> meaning we do not know. Very different hardware, didn't know. Thank  
> you for the feedback.

Well, if you didn't notice it already, there are a zillion different flavors
of the broadcom wireless chip out there. So if you buy a random device, you're almost
guaranteed that you don't have that flavor already. ;)

Another thing is: You simply can _not_ distinguish the devices by the 43xx number in practice.
There are too many devices with the same 43xx number, but different internal designs.
The safest solution for the firmware is to tell by the wireless core revision whether it works or not.
(However, that still leaves a few traps for different PHY and radio revisions, as the firmware also
accesses PHY and radio).

-- 
Greetings, Michael.
