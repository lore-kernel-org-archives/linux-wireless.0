Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvsmtp01.broadcom.com ([192.19.211.62]:54806 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750910AbcLLMAS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Dec 2016 07:00:18 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [RFC V3 00/11] nl80211: add support for g-scan
Date: Mon, 12 Dec 2016 11:59:46 +0000
Message-Id: <1481543997-24624-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20161212_130022_561778_C343EDC9)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Android employs a Wifi-HAL layer in its wireless frame. It basically abstracts
dealing with netlink messages from the framework. For some features it employs
nl80211 vendor commands. The goal I set myself is to be able to have a generic
nl80211 Wifi-HAL implementation. One of the features currently requiring the
vendor commands is g-scan. We can only guess what the 'g' stands for ;-) This
series converts the vendor command api into common nl80211 api.

This series adds basic support of g-scan (or GScan, or gscan, or something
completely different; suggestions are welcome). A basic g-scan request consists
of some common attributes and so-called buckets. Each bucket represents a
re-occurring scan request with a given interval and a set of channels. The
common attributes specify how much scans (m) should be stored and how many
BSS-es (n) should be kept per scan before an event is sent. The other option
is to specify a percentage at which an event is sent, where 100% equals (m * n).
A special case of bucket is the exponential backoff bucket, which has an
increasing interval.

The series is applied on top of master branch of wireless-testing as it relied
on patches pending in wireless-drivers-next. As such this series include two
fixes against those pending patched. Hopefully using wireless-testing allows
the nl80211 changes in this series to apply to mac80211-next. I consider it
still in RFC state so it may not matter right now.

Changes:
 V2
  - remove pr_err() statement from nl80211.c
  - get rid of #if 0 code.
  - reordered patches resolving compilation issue.
 V3
  - drop support for RTT info in scan results.
  - cleanup attribute definitions.
  - add driver implementation for brcmfmac.

Arend van Spriel (11):
  nl80211: add reporting of gscan capabilities
  nl80211: rename some notification functions
  nl80211: add support for gscan
  nl80211: add driver api for gscan notifications
  brcmfmac: fix memory leak in brcmf_cfg80211_attach()
  brcmfmac: fix uninitialized field in scheduled scan ssid configuration
  brcmfmac: add firmware feature detection for gscan feature
  brcmfmac: report gscan capabilities if firmware supports it
  brcmfmac: implement gscan functionality
  brcmfmac: handle gscan events from firmware
  brcmfmac: allow gscan to run concurrent with scheduled scan

 .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 266 +++++++++++--
 .../broadcom/brcm80211/brcmfmac/cfg80211.h         |  12 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |   5 +-
 .../wireless/broadcom/brcm80211/brcmfmac/debug.h   |   2 +
 .../wireless/broadcom/brcm80211/brcmfmac/feature.c |  22 +-
 .../wireless/broadcom/brcm80211/brcmfmac/feature.h |   4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/fweh.h    |   1 +
 .../broadcom/brcm80211/brcmfmac/fwil_types.h       |  92 +++++
 .../net/wireless/broadcom/brcm80211/brcmfmac/pno.c | 381 +++++++++++++++++-
 .../net/wireless/broadcom/brcm80211/brcmfmac/pno.h |  37 ++
 include/net/cfg80211.h                             | 155 ++++++++
 include/uapi/linux/nl80211.h                       | 207 ++++++++++
 net/wireless/core.c                                |  33 ++
 net/wireless/core.h                                |   6 +
 net/wireless/nl80211.c                             | 430 ++++++++++++++++++++-
 net/wireless/nl80211.h                             |   4 +-
 net/wireless/rdev-ops.h                            |  25 ++
 net/wireless/scan.c                                |  90 ++++-
 net/wireless/trace.h                               |  19 +
 19 files changed, 1726 insertions(+), 65 deletions(-)

--
1.9.1
