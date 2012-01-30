Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:35537 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530Ab2A3UPP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 15:15:15 -0500
Message-ID: <4F26FA4A.9090102@hauke-m.de> (sfid-20120130_211519_203571_A5CDCA50)
Date: Mon, 30 Jan 2012 21:15:06 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	b43-dev <b43-dev@lists.infradead.org>,
	Arend van Spriel <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Broadcom sprom
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I had a look at the sprom parsing, as the SoC sprom parsing code is
dated and does not fill in some fields introduced in updates of struct
ssb_sprom. I had a look at the brcm/include/bcmsrom_tbl.h file found in
the Broadcom SoC SDK containing the positions and names of the sprom
values. For the old sprom versions <= 4 our struct ssb_sprom contains
mostly all fields available in the sprom, but for more recent it misses
some/many values. I searched brcmsmac for some of them and they are
mostly parsing the same values for v8 and v9 as the Broadcom SoC SDK
does, but they do not use all of them.

How should we proceed? Should I extend struct ssb_sprom to support all
sprom values available or found in the Broadcom SDK in sprom version 1
to 9 and add the parsing code to bcm47xx arch code, ssb (for old
versions) and bcma, or just the ones currently needed by any driver? As
even brcmsmac does not use all of them some seam to be unused at all.

As the struct would be under 1KB if we put in all sprom values we know
of I am for adding all these values into it and we do not have to deal
with sproms till version 10 is released. ;-)

What are you opinions about this?

Hauke
