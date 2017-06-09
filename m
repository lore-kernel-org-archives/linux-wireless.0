Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvrndsmtp01.broadcom.com ([192.19.229.170]:42894 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751657AbdFIMJA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Jun 2017 08:09:00 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH V3 0/9] nl80211: add support for PTK/GTK handshake offload
Date: Fri,  9 Jun 2017 13:08:41 +0100
Message-Id: <1497010130-16186-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170609_140946_903205_C1120D48)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This patch series add support for offloading the PTK/GTK handshakes for
WPA/WPA2-Personal and 802.1X in nl80211. The nl80211 patches have been
posted as RFC. Compared to that RFC this series also adds a new flag
ATTR_PORT_AUTHORIZED used in both CONNECT and ROAM notifications to
indicate the driver has completed the offloads successfully and the
encryption keys for the connection are applied. Another change is the
addition of the flag ATTR_WANT_1X_4WAY_HS that user-space has to pass
in CONNECT request. Some drivers may need to be aware before the PMK
is programmed through SET_PMK request.

This series also comes with driver implementation in brcmfmac although
it does not use the authorized flag in the ROAM event (yet).

The series applies to the master branch of the mac80211-next repository.

V2:
 - changed patch 2/9 addressing comments from Johannes.
V3:
 - added documentation section in nl80211.h.

Arend van Spriel (6):
  nl80211: add authorized flag to CONNECT event
  nl80211: remove desciption about request from NL80211_CMD_ROAM
  brcmfmac: support 4-way handshake offloading for WPA/WPA2-PSK
  brcmfmac: support 4-way handshake offloading for 802.1X
  brcmfmac: switch to using cfg80211_connect_done()
  brcmfmac: provide port authorized state in CONNECT event

Avraham Stern (2):
  cfg80211: support 4-way handshake offloading for 802.1X
  nl80211: add authorized flag to ROAM event

Eliad Peller (1):
  cfg80211: support 4-way handshake offloading for WPA/WPA2-PSK

 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 159 +++++++++++++++++++--
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |  15 +-
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |   1 +
 .../wireless/broadcom/brcm80211/brcmfmac/feature.h |   4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.h    |  30 ++++
 .../wireless/broadcom/brcm80211/brcmfmac/fwil.h    |   1 +
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |  16 +++
 include/linux/ieee80211.h                          |   4 +
 include/net/cfg80211.h                             |  41 ++++++
 include/uapi/linux/nl80211.h                       |  73 +++++++++-
 net/wireless/core.c                                |   5 +
 net/wireless/nl80211.c                             | 120 +++++++++++++++-
 net/wireless/rdev-ops.h                            |  25 ++++
 net/wireless/sme.c                                 |   2 +
 net/wireless/trace.h                               |  60 ++++++++
 15 files changed, 533 insertions(+), 23 deletions(-)

-- 
1.9.1
