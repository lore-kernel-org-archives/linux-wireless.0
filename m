Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:3850 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989AbYETIIM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 04:08:12 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: Re: [PATCH 2/2] Sysfs interface for accessing non-volatile configuration.
Date: Tue, 20 May 2008 10:07:59 +0200
Cc: Javier Cardona <javier@cozybit.com>,
	linux-wireless@vger.kernel.org, carrano@laptop.org,
	dwmw2@infradead.org, dilinger@queued.net
References: <4832422a.20018e0a.6b37.3217@mx.google.com>
In-Reply-To: <4832422a.20018e0a.6b37.3217@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200805201007.59746.hs4233@mail.mn-solutions.de> (sfid-20080520_100819_012125_36620752)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Javier,

here are some notes from the CF/embedded point of view.


My understanding is that currently ONLY the USB dongle / OLPC 
firmware does support mesh. The other firmware's don't support 
mesh at all:

# /sys/class/net/eth1/boot_options
# grep . *
grep: bootflag: Operation not supported
grep: boottime: Operation not supported

or, from the log:

cmd: DNLD_CMD: command 0x00a3, seq 20, size 144
DNLD_CMD: a3 00 90 00 14 00 00 00 03 00 00 00 05 00 00 00
DNLD_CMD: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
DNLD_CMD: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
cmd: CMD_RESP: response 0x80a3, seq 20, size 144
CMD_RESP: a3 80 90 00 14 00 02 00 03 00 00 00 05 00 00 00
CMD_RESP: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
PREP_CMD: command 0x00a3 failed: 2


So I would like to have one (or both) of the following things:

*) a runtime check (e.g. by comparing firmware version) if
   the firmware supports mesh at all, and then doing this only
   in that case. Probably as lbs_has_mesh() call, we're going
   to need this in several places
*) a kernel-config option, because many people use CF/SDIO
   cards in embedded environmnents and like to have things
   small. No need for #ifdef/#endif, because the compiler can
   savely optimize things out: "#define lbs_has_mesh() (0)"
   if mesh is turned off via Kconfig.

Also, you create /sys/class/net/ethX/mesh_ie. This doesn't make
sense to me. /sys/class/net/mshX/boot_options seems to be more 
logical. However, I don't know much about mesh ...
