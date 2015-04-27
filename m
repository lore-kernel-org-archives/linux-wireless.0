Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33233 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbbD0HEW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Apr 2015 03:04:22 -0400
MIME-Version: 1.0
From: Valentin Rothberg <valentinrothberg@gmail.com>
Date: Mon, 27 Apr 2015 09:03:50 +0200
Message-ID: <CAD3Xx4+vRhswKAbpHnrYQMRNKOppOQzgFOgoJw_1iAfK4baCtQ@mail.gmail.com> (sfid-20150427_090426_019911_C3B6E3D7)
Subject: NFC: CONFIG_NFC_DEBUG not defined
To: clement.perrochaud@nxp.com
Cc: sameo@linux.intel.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, lauro.venancio@openbossa.org,
	aloisio.almeida@openbossa.org, Paul Bolle <pebolle@tiscali.nl>,
	Andreas Ruprecht <rupran@einserver.de>,
	hengelein Stefan <stefan.hengelein@fau.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Clément,

your commit dece45855a8b ("NFC: nxp-nci: Add support for NXP NCI
chips") adds the Makefile drivers/nfc/nxp-nci/Makefile with the
following line:

+ccflags-$(CONFIG_NFC_DEBUG) := -DDEBUG

The Kconfig option NFC_DEBUG is not defined so the line turns out to
be a nop.  There is another reference in drivers/nfc/Makefile.  Is
there a patch queued somewhere to add the option?

I found this issue with ./scripts/checkkconfigsymbols.py by diffing
v4.0 and v4.1-rc1.

Kind regards,
 Valentin
