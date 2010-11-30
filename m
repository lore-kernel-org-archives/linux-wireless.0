Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:43838 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752464Ab0K3GLr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 01:11:47 -0500
Subject: Re: [PATCH v4 ] wl12xx: BA Initiator support
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Ohad Ben-Cohen <ohad@wizery.com>
Cc: Shahar Levi <shahar_levi@ti.com>, linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTikUOfQbk-TEE2=EejXOTr_t-LXvTim-Sc1OVwKG@mail.gmail.com>
References: <1291038135-20672-1-git-send-email-shahar_levi@ti.com>
	 <AANLkTikUOfQbk-TEE2=EejXOTr_t-LXvTim-Sc1OVwKG@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Nov 2010 08:11:40 +0200
Message-ID: <1291097500.1673.100.camel@powerslave>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-11-29 at 16:44 -0800, ext Ohad Ben-Cohen wrote:
> Hi Shahar,
> 
> On Mon, Nov 29, 2010 at 5:42 AM, Shahar Levi <shahar_levi@ti.com> wrote:
> ...
> > -#define WL1271_FW_NAME "wl1271-fw.bin"
> > +#define WL1271_FW_NAME "wl1271-fw-2.bin"
> 
> Changing the firmware's major version involves usability and
> maintainability pain to the entire wl12xx community, especially if
> done repeatedly, and therefore should be generally avoided.

Yes, I was thinking about the same thing yesterday.  Then I had to
leave, so I'm still not sure whether this is really needed.


> When the firmware API changes, and the old driver can't work with it
> anymore, then you have no choice but changing the name.

In theory the API *has* changed, not just extended.  Check this:

-       ACX_BA_SESSION_RESPONDER_POLICY = 0x0055,
-       ACX_BA_SESSION_INITIATOR_POLICY = 0x0056,
+       ACX_BA_SESSION_POLICY_CFG   = 0x0055,
+       ACX_BA_SESSION_RX_SETUP     = 0x0056,

But in practice, this doesn't matter, because we were not using the
RESPONDER/INITIATOR commands before...


> But if it's just a small API extension enabling new driver
> functionality, you should really avoid bumping the firmware version,
> and instead try to dynamically detect it from the driver and act
> appropriately.
> 
> Please explain what has exactly been changed in the firmware and let's
> try to find a clean solution.

It's basically just those two extra commands that were added.  And one
new event that is part of a future patch.

In theory, we could check the firmware revision after boot and bail out
if the version doesn't match.  Maybe we should add a small
infrastructure for that kind of check.

This new firmware is only required if 11n is enabled too, so at least we
should not have the driver fail whe the new fw version is not there,
unless 11n is enabled.


-- 
Cheers,
Luca.

