Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:36846 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754045AbYGAX5y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 19:57:54 -0400
Date: Tue, 1 Jul 2008 20:57:48 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michael Buesch <mb@bu3sch.de>,
	Adel Gadllah <adel.gadllah@gmail.com>,
	linux-wireless@vger.kernel.org, stefano.brivio@polimi.it,
	Larry Finger <larry.finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH/RFC] b43: remove input device usage for rfkill
Message-ID: <20080701235747.GG4292@khazad-dum.debian.net> (sfid-20080702_015758_415920_20E5D204)
References: <20080701225207.GB4292@khazad-dum.debian.net> <1214952993.3462.14.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1214952993.3462.14.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 02 Jul 2008, Johannes Berg wrote:
> On Tue, 2008-07-01 at 19:52 -0300, Henrique de Moraes Holschuh wrote:
> > Dmitry (input layer maintainer) added to CC.  This is a [gross misuse of
> > the] input layer issue.
> 
> FWIW, to me half of that mail reads like a rant and I'm ignoring it. If
> you know so much better, why don't you continue working on fixing it?

I apologise.  Re-reading it, it does look like a rant, indeed.  It wasn't
supposed to be, but the tone came up nasty and quite defensive.  I didn't
intend it to.

The sheer ammount of explanations I have had to type over the whole rfkill
business is, apparently, getting to me a lot more than expected, and I guess
that put me in the defensive.  There is no excuse for that.

So, please accept my appologies on the tone of the last email.  Please
reconsider reading that email in full, and please try to ignore the rantness
smell in it.  I did try to explain the technical reasons why some changes
would be needed in b43.

I am sorry I didn't send you any patches.  I don't have any access to a b43
device, and as a rule, I try to avoid modifying code I will not be able to
test, especially when I don't know the code to begin with and the changes
are not going to be small, obvious ones.

> To address one point though: userspace does want a notification when the
> hw-rfkill is activated so it (e.g. network manager) can ask people to
> un-rfkill their device.

I tried to add such notifications directly to the rfkill class.  rfkill now
issues uevents and calls a notification chain for any state changes.  It has
been modified to differentiate hw-rfkill from sw-rfkill, and export that
information to userspace for network-manager and other applications to use.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
