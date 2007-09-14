Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([140.186.70.10]:34536 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731AbXINFFV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2007 01:05:21 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1IW3ML-00086R-DB
	for linux-wireless@vger.kernel.org; Fri, 14 Sep 2007 01:04:53 -0400
Subject: Re: [PATCH 00/05] orinoco: Agere/Lucent firmware download
From: Pavel Roskin <proski@gnu.org>
To: Dave <kilroyd@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <46E8557F.2080401@gmail.com>
References: <46E8557F.2080401@gmail.com>
Content-Type: text/plain
Date: Fri, 14 Sep 2007 01:05:12 -0400
Message-Id: <1189746312.26312.39.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, Dave!

On Wed, 2007-09-12 at 22:09 +0100, Dave wrote:
> Implements firmware download to RAM for Lucent-Agere firmware.
> Firmware download is a requirement to implement WPA on these cards.

I really appreciate your efforts.

Please avoid copying to David Gibson in the future, as he stepped down
as the maintainer.

Also, it may work better if you post your patches to orinoco-devel
first, and then to linux-wireless.  Many people hesitate to reply to
messages cross-posted to several lists.  orinoco-users doesn't need to
be involved at all.

I understand that it's a major change, and in needs to be tested
thoroughly.  I don't have time to review the patches right now, but it
is on my TODO list.

> The following firmwares download and run on my Dell TrueMobile 1150:
> 7.65, 8.10, 8.42, 8.58

What some users may want to run is 6.06 or 6.16, as the 7.xx and 8.xx
firmwares have stability issues with the monitor mode.

> The following firmwares download, but are not compatible with the
> current orinoco_cs driver:
> 9.40, 9.42, 9.48

That's great news anyway.  We may see Hermes II supported eventually.

> All my testing done on a pentium3 Dell C600. FW 9.48 download also
> confirmed on a powerbook using a modified airport driver compiled
> with a static copy of the firmware

Please use sparse to check endianess and other issues.  You can use this
command once sparse is in PATH:

make C=2 CF="-Wall -D__CHECK_ENDIAN__"

-- 
Regards,
Pavel Roskin

