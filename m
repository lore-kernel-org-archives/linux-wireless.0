Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:43713 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932267AbZGOUUh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jul 2009 16:20:37 -0400
Message-ID: <4A5E377E.6090705@redfish-solutions.com>
Date: Wed, 15 Jul 2009 13:09:34 -0700
From: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: mcgrof@winlab.rutgers.edu
Subject: Build instructions for cross-compilation environment
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.

I'm the lead developer for Astlinux.

We're doing a kernel bump from 2.6.26.8 to 2.6.27.26, and wanted to take
the opportunity to start using compat-wireless at the same time, because
we need (amongst other things) better mac80211/cfg80211/nl80211 and
AP-mode for the Ath5k chipset (AR5413, et al).

The README included in the tarball (compat-wireless-2.6.30.tar.bz2)
discusses building replacement drivers on the same system and placing
them into updates/.

I'd like to cross-compile this on a system and replace the drivers that
have been deposited by the plain-vanilla kernel build.

Also, a list of what CONFIG_xxx symbols I need to turn off to ensure
that there is no "residue" left over from the kernel build to interfere
with the compat-wireless build would be helpful (or alternatively,
what's the bare essential list of CONFIG_xxx symbols that need to be
enabled to "hook" compat-wireless into an existing kernel).

Looking at the Makefiles, it doesn't seem that cross-compilation is
ready out-of-the-box:

MADWIFI=$(shell $(MODPROBE) -l ath_pci)
OLD_IWL=$(shell $(MODPROBE) -l iwl4965)


Please reply to me directly (or even on Cc).  I tried to join the list a
couple of weeks ago, but my request hasn't yet been processed.

Thanks,

-Philip

