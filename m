Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3877 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754477Ab1ATJCB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 04:02:01 -0500
From: "Arend Van Spriel" <arend@broadcom.com>
To: "Jonas Gorski" <jonas.gorski@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"gregkh@suse.de" <gregkh@suse.de>
cc: "Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Dowan Kim" <dowan@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>
Date: Thu, 20 Jan 2011 00:58:51 -0800
Subject: RE: [RFT 0/8] Clean proto/ethernet.h and remove it.
Message-ID: <400C43189542CE41BC0A5B252FC90136952F05954D@SJEXCHCCR02.corp.ad.broadcom.com>
References: <1295476532-21130-1-git-send-email-jonas.gorski@gmail.com>
In-Reply-To: <1295476532-21130-1-git-send-email-jonas.gorski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jonas,

The brcm80211 driver is currently a staging driver and as such maintained by GregKH (git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-2.6.git). In the staging-next branch of that repository similar patches have already been posted. Maybe they are still in the queue.

Gr. AvS
________________________________________
From: Jonas Gorski [jonas.gorski@gmail.com]
Sent: Wednesday, January 19, 2011 11:35 PM
To: linux-wireless@vger.kernel.org
Cc: Brett Rudley; Henry Ptasinski; Dowan Kim; Roland Vossen; Arend Van Spriel
Subject: [RFT 0/8] Clean proto/ethernet.h and remove it.

After the short discussion I started cleaning up the code, and this is the
first small patch series. I thought I'll start with rather simple
replacements.

This series replaces everything from proto/ethernet.h with their
equivalents in the kernel and then removes it.

It does not fix previously existing style violations, so checkpatch still
complains about too long lines; I will address these in further patches.

Since I do not have a supported device at hand, I'd be happy if anyone
could test that I didn't break anything while replacing things. Especially
in patch 7 (Replace ether_addr with fixed size array) I might have broken
something.

--

Jonas

Jonas Gorski (8):
  staging: brcm80211: Remove unused ETHER_<foo> macros.
  staging: brcm80211: Use linux ethhdr struct.
  staging: brcm80211: Remove unused ETHER_<foo> defines.
  staging: brcm80211: Remove ETHER_MAX_LEN definition.
  staging: brcm80211: Remove ETHER_TYPE_BRCM.
  staging: brcm80211: Remove static ether_bcast.
  staging: brcm80211: Replace ether_addr with fixed size array.
  staging: brcm80211: Remove proto/ethernet.h.

 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |   19 +++---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |    1 -
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   |    5 +-
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h   |    1 -
 drivers/staging/brcm80211/brcmfmac/wl_iw.c         |    5 +-
 drivers/staging/brcm80211/brcmfmac/wl_iw.h         |    1 -
 drivers/staging/brcm80211/include/bcmcdc.h         |    3 +-
 drivers/staging/brcm80211/include/bcmutils.h       |    2 +-
 drivers/staging/brcm80211/include/proto/802.11.h   |   20 +++---
 drivers/staging/brcm80211/include/proto/bcmevent.h |    8 ++-
 drivers/staging/brcm80211/include/proto/ethernet.h |   72 --------------------
 drivers/staging/brcm80211/include/proto/wpa.h      |    2 -
 drivers/staging/brcm80211/include/wlioctl.h        |   23 +++---
 drivers/staging/brcm80211/sys/wl_mac80211.c        |    3 +-
 drivers/staging/brcm80211/sys/wlc_alloc.c          |    4 +-
 drivers/staging/brcm80211/sys/wlc_ampdu.c          |    2 +-
 drivers/staging/brcm80211/sys/wlc_bmac.c           |   34 ++++-----
 drivers/staging/brcm80211/sys/wlc_bmac.h           |   14 ++--
 drivers/staging/brcm80211/sys/wlc_bsscfg.h         |    6 +-
 drivers/staging/brcm80211/sys/wlc_key.h            |    2 +-
 drivers/staging/brcm80211/sys/wlc_mac80211.c       |   55 +++++++--------
 drivers/staging/brcm80211/sys/wlc_mac80211.h       |   12 ++--
 drivers/staging/brcm80211/sys/wlc_pub.h            |   10 ++--
 drivers/staging/brcm80211/sys/wlc_scb.h            |    2 +-
 drivers/staging/brcm80211/util/bcmsrom.c           |   18 ++---
 drivers/staging/brcm80211/util/bcmutils.c          |    5 +-
 26 files changed, 117 insertions(+), 212 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/include/proto/ethernet.h



