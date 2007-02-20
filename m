Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:47750
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932732AbXBTKFR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Feb 2007 05:05:17 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: Capture of unsuccessful ARP exchange
Date: Tue, 20 Feb 2007 11:04:41 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Pavel Roskin <proski@gnu.org>, Jouni Malinen <j@w1.fi>,
	linux-wireless@vger.kernel.org
References: <1171935085.8133.42.camel@dv> <1171938483.10139.13.camel@dv> <1171959815.15489.75.camel@johannes.berg>
In-Reply-To: <1171959815.15489.75.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200702201104.42201.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 20 February 2007 09:23, Johannes Berg wrote:
> > When ping finally starts working, all the data is transmitted at 1Mbps.
> > And the QoS field is still there , so it's not a problem by itself.
> 
> Didn't you say that you're using mb's tree? You have a 4311 IIRC so I
> wouldn't be surprised if there are problems with receive sensitivity
> that go away after, say, two minutes (recalibration interval).

My tree has serious transmission problems (TX and I think RX, too).
I'd like to fix that as soon as possible, but I really can't find the
damn bug. It's kind of: I verified the whole PHY code for sanity and
correctness, but still don't see where it is.

Maybe we can workaround that by driving the card at highest
attenuation control values, always. But that would obviously break
regulatory domain laws, so... .
Let's try to find the bug. :)

If someone wants to help searching, please do so. I'm kind of
running out of ideas where to search.
It's some issue with the idle-TSSI measurement in the PHY powercontrol
init code. We almost always get a 0 value there, but we should
get something around 50. That messes up attenuation control, later.
Well, why do we get a 0 there? I have no idea. Must be a bug somewhere
in the code that's run before the idle-TSSI is measured.

-- 
Greetings Michael.
