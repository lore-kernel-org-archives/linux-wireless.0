Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost04.isp.att.net ([204.127.217.104]:34118 "EHLO
	fmailhost04.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751912AbZFENDl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jun 2009 09:03:41 -0400
Message-ID: <4A2917AD.2090008@lwfinger.net>
Date: Fri, 05 Jun 2009 08:03:41 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] rfkill: always init poll delayed work
References: <1244015729.7176.28.camel@johannes.local>	 <4A268DAC.4010805@lwfinger.net> <1244040913.4862.8.camel@johannes.local>	 <4A27DF95.50603@lwfinger.net> <1244128337.22576.81.camel@johannes.local>	 <4A27EF6C.8000208@lwfinger.net> <1244132396.22576.82.camel@johannes.local>	 <4A27F649.9080203@lwfinger.net> <1244133087.22576.86.camel@johannes.local>	 <4A27FB8D.5000605@lwfinger.net> <1244134635.22576.88.camel@johannes.local>	 <4A2809F8.6020006@lwfinger.net> <1244138572.22576.90.camel@johannes.local>
In-Reply-To: <1244138572.22576.90.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> 
> I do mean that, but I don't think you can access the 802.11 core's MMIO
> while it's down. I'm out of ideas expect taking the core up, checking,
> and down again periodically.

You were right. What I missed was that the stop callback was taking
the interface down to the uninitialized state, which caused the rfkill
poll routine to bail out without testing the switch state in the
hardware. A quick fix is for the poll routine to call
b43_wireless_core_init() whenever it detects the uninitialized state.
This call brings the interface back to the initialized state where the
 switch state can be tested. With this change, the radio now follows
the switch. The LED now stays on all the time - always something to fix.

What bothers me is that this seems like a lot of work when the same
effect could be achieved by simply turning the radio off/on when the
rfkill blocking state changes. Perhaps there should be the option of
using two new ieee80211_ops callbacks (radio_off/radio_on) that would
default to stop/start if not specified. By specifying these callbacks,
each driver could choose how intrusive the radio shutdown need be.

Larry
