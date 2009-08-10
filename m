Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:52981 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932249AbZHJRUR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Aug 2009 13:20:17 -0400
From: Michael Buesch <mb@bu3sch.de>
To: =?iso-8859-1?q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Subject: Re: [RFC PATCH] b43: Implement LP-PHY baseband table initialization
Date: Mon, 10 Aug 2009 19:19:24 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <4A7F713E.8040405@gmail.com> <69e28c910908100549w6af5bd12j568c7f0c2aa31e30@mail.gmail.com> <200908101452.50072.mb@bu3sch.de>
In-Reply-To: <200908101452.50072.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200908101919.25306.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 10 August 2009 14:52:49 Michael Buesch wrote:
> On Monday 10 August 2009 14:49:31 Gábor Stefanik wrote:
> > 2009/8/10 Michael Buesch <mb@bu3sch.de>:
> > > On Monday 10 August 2009 03:00:46 Gábor Stefanik wrote:
> > >> +static const u16 lpphy_sw_control_table[] = {
> > >> +     0x0128,
> > >> +     0x0128,
> > >> +     0x0009,
> > >> +     0x0009,
> > >> +     0x0028,
> > >> +     0x0028,
> > >
> > > Is it possible to use more than one value per line for all these tables?
> > > Make sure to make best use of the 80 columns limit.
> > > This would significantly decrease the patch/file length. (linewise)
> > >
> > > --
> > > Greetings, Michael.
> > >
> > 
> > Well, I converted the tables directly from the Wikitext on
> > bcm-v4.sipsolutions.net using regex search&replace - if you know a
> > good regex to convert the tables to use multiple values on each line,
> > please post it.
> > 
> 
> I have some hacky python scripts to parse and reformat these tables.
> I will post them in a few hours. I'll have to leave now. brb.
> 

Hm, I don't seem to have the scripts anymore. But python re is fairly simple.
Here's a hacky script to parse a table, perform some transformations on it and
print out the C defines:

#!/usr/bin/env python

import re
import sys

d = file(sys.argv[1]).readlines()


for line in d:
	r = re.compile(r"\|\| `0x([0-9A-Fa-f]+)` \|\| ([\w\s\(\)/]+) \|\|")
	m = r.match(line)
	if m:
		offset = int(m.group(1), 16)
		name = m.group(2)
		name = name.replace("workAround", "workaround")

		origname = name

		name = name.replace("(", " ")
		name = name.replace(")", " ")

		name = name.upper()
		name = name.strip()

		name = name.replace(" ", "_")
		name = name.replace("/", "_")
		name = name.replace("CONTROL", "CTL")
		name = name.replace("COMMON", "COMM")
		name = name.replace("CALIBRATION", "CALIB")
		name = name.replace("DEBUG", "DBG")
		name = name.replace("COUNTER", "CNT")
		name = name.replace("POWER", "PWR")
		name = name.replace("B_PHY", "B")
		name = name.replace("ADDRESS", "ADDR")
		name = name.replace("OUT_ENABLE", "OUTEN")
		name = name.replace("THRESHOLD", "THRES")
		name = name.replace("STATUS", "STAT")
		name = name.replace("COEFFICIENT", "COEFF")
		name = name.replace("INTERVAL", "INT")
		name = name.replace("TIMEOUT", "TO")
		name = name.replace("VALUE", "VAL")
		name = name.replace("SAMPLE", "SMPL")

		name = "B43_LPPHY_" + name

		nr_tabs = 5 - (len(name) / 8)
		tabs = "\t" * nr_tabs

		comment = origname

		if (offset & 0x400):
			accessor = "B43_PHY_OFDM"
		else:
			accessor = "B43_PHY_CCK"
		offset &= ~0x400;
		if (offset & ~0xFF):
			print "offset ERROR %X" % offset
			sys.exit(1)
		sys.stdout.write("#define %s%s%s(0x%02X)" % (name, tabs, accessor, offset))
		if comment:
			sys.stdout.write(" /* %s */" % comment)
		sys.stdout.write("\n")
	else:
		pass
		print "NO match " + line

-- 
Greetings, Michael.
