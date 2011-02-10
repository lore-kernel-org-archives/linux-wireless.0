Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:59352 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755840Ab1BJKVH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 05:21:07 -0500
Subject: Re: SSB AI support code ([RFC] v2)
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: George Kashperko <george@znau.edu.ua>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1297315457.12795.40.camel@dev.znau.edu.ua> (sfid-20110210_063153_817778_FFFFFFFFF46A15B5)
References: <1297258590.17400.37.camel@dev.znau.edu.ua>
	 <AANLkTi=v9PM8pQ8qF1XpuMSYAy4=MAO2W8TQU+a3AGQn@mail.gmail.com>
	 <1297288286.9734.28.camel@maggie>
	 <AANLkTimS7Q5Du5_r3dZbF1gfpDofjL3Vm-AdEZP=zDQd@mail.gmail.com>
	 <4D5320AA.5020405@lwfinger.net> <1297315457.12795.40.camel@dev.znau.edu.ua>
	 (sfid-20110210_063153_817778_FFFFFFFFF46A15B5)
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Feb 2011 11:20:56 +0100
Message-ID: <1297333256.30218.10.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-02-10 at 07:24 +0200, George Kashperko wrote: 
> Here is updated patchset for AI support code.

So this patchset does only contain code for the embedded-AI case.
There's no support for PCI devices so far. Are you going to
add this, too? Or does it work with the existing PCI hostcode?
Otherwise the argument that "brcm80211 can be ported
to it, too" is foobar.

You AI ops seem to be wrong, too:

+/* Ops for the plain SSB bus without a host-device (no PCI or PCMCIA).
*/
+static struct ssb_bus_ops ssb_ops_ai = {
+ .read8 = ssb_ssb_read8,
+ .read16 = ssb_ssb_read16,
+ .read32 = ssb_ssb_read32,
+ .write8 = ssb_ssb_write8,
+ .write16 = ssb_ssb_write16,
+ .write32 = ssb_ssb_write32,
+#ifdef CONFIG_SSB_BLOCKIO
+ .block_read = ssb_ssb_block_read,
+ .block_write = ssb_ssb_block_write,
+#endif

You're still calling the SSB-embedded routines. The comment also seems
wrong. This is not a "plain SSB bus". It's an "AI" bus.

My proposal stays the same: If you want this merged, you'll have to
maintain it (the whole thing) in the long term.

-- 
Greetings Michael.

