Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:58848 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767933Ab2KOOIR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Nov 2012 09:08:17 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com,
	Daniel Wagner <wagi@monom.org>,
	Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v2 00/22] brcmsmac: Tx rework and expanded debug/trace support
Date: Thu, 15 Nov 2012 08:07:50 -0600
Message-Id: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com> (sfid-20121115_150835_933546_F2F8A655)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

As promised, here's the updated patch series for brcmsmac to remove the
tx packet queue, add flow control, and add enhanced debug trace support.
I've broken up the tx rework into multiple patches as you requested.
Most notably I've split out the AMPDU session support into a separate
patch, which should make it easier to review that change. I've done
basic testing of each of the new commits to try and verify that no
obvious regressions are introduced by any of them.

Patch 6 contains the real meat of the tx changes and is still fairly
large. It's going to be difficult to break up this patch any further
though. The most obvious thing to break out at this point would be the
flow control support. However, doing this before removing the tx queue
basically results in throw-away code, and removing it after means that
the commit that removes the tx queue may not work well, potentially
making bisects more difficult. The flow control changes really aren't
that big anyway.

Otherwise the changes are pretty trivial, and functionally the end
result should be identical to v1. I've found that I am still receiving
frames occasionally after stopping a queue so I've kept the headroom in
the tx fifos for now.

Changes since v1:

 * Break up the tx path rework as much as possible
 * BRCMDBG no longer selects BRCMS_TRACING
 * Macro for checking for enabled debug levels has been removed in favor
   of open coding the checks
 * brcms_debug.[ch] renamed to debug.[ch]
 * Debug macros changed to lower-case
 * Removed some additional dead code
 * A few trivial clean-ups

Thanks,
Seth


Seth Forshee (22):
  brcmsmac: Introduce AMPDU sessions for assembling AMPDUs
  brcmsmac: Don't weight AMPDU packets in txfifo
  brcmsmac: Add helper function for updating txavail count
  brcmsmac: Remove unimplemented flow control functions
  brcmsmac: Use IEEE 802.11 AC levels for pktq precedence levels
  brcmsmac: Remove internal tx queue
  brcmsmac: Use correct descriptor count when calculating next rx
    descriptor
  brcmsmac: Reduce number of entries in tx DMA rings
  brcm80211: Allow trace support to be enabled separately from debug
  brcm80211: Convert log message levels to debug levels
  brcmsmac: Add module parameter for setting the debug level
  brcmsmac: Add support for writing debug messages to the trace buffer
  brcmsmac: Use debug macros for general error and debug statements
  brcmsmac: Add brcms_dbg_mac80211() debug macro
  brcmsmac: Add rx and tx debug macros
  brcmsmac: Add brcms_dbg_int() debug macro
  brcmsmac: Add brcms_dbg_dma() debug macro
  brcmsmac: Add brcms_dbg_ht() debug macro
  brcmsmac: Improve tx trace and debug support
  brcmsmac: Add tracepoint for macintstatus
  brcmsmac: Add tracepoint for AMPDU session information
  brcmsmac: Remove some noisy and uninformative debug messages

 drivers/net/wireless/brcm80211/Kconfig             |   11 +
 drivers/net/wireless/brcm80211/brcmsmac/Makefile   |    3 +-
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.c    |  723 ++++++------
 drivers/net/wireless/brcm80211/brcmsmac/ampdu.h    |   29 +-
 drivers/net/wireless/brcm80211/brcmsmac/antsel.c   |    4 +-
 .../brcm80211/brcmsmac/brcms_trace_events.h        |  175 ++-
 drivers/net/wireless/brcm80211/brcmsmac/channel.c  |   10 +-
 drivers/net/wireless/brcm80211/brcmsmac/debug.c    |   44 +
 drivers/net/wireless/brcm80211/brcmsmac/debug.h    |   46 +
 drivers/net/wireless/brcm80211/brcmsmac/dma.c      |  343 ++++--
 drivers/net/wireless/brcm80211/brcmsmac/dma.h      |   11 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |  123 ++-
 drivers/net/wireless/brcm80211/brcmsmac/main.c     | 1166 ++++++--------------
 drivers/net/wireless/brcm80211/brcmsmac/main.h     |   48 +-
 drivers/net/wireless/brcm80211/brcmsmac/pub.h      |   37 -
 drivers/net/wireless/brcm80211/brcmsmac/stf.c      |    8 +-
 drivers/net/wireless/brcm80211/brcmsmac/types.h    |    3 +-
 drivers/net/wireless/brcm80211/include/defs.h      |   11 +-
 18 files changed, 1298 insertions(+), 1497 deletions(-)
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/debug.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmsmac/debug.h

