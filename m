Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:33112 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750733AbeEVIT1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 May 2018 04:19:27 -0400
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
        Eylon Pedinovsky <eylon.pedinovsky@broadcom.com>,
        Jithu Jance <jithu.jance@broadcom.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 0/3] nl80211: support offloading FILS-SK roaming scenarios
Date: Tue, 22 May 2018 10:19:05 +0200
Message-Id: <1526977148-11600-1-git-send-email-arend.vanspriel@broadcom.com> (sfid-20180522_101931_125869_EF8CD352)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This small patch series is based on patch originally submitted by Vidyullatha
to support driver/firmware roaming for FILS-SK offload. It also reworks the
connection response code to reuse the fils parameter structure for the ROAM
event.

The series is intended for 4.18 and applies to the master branch of the
mac80211-next repository.

Arend van Spriel (2):
  cfg80211: use separate struct for fils parameters
  nl80211: add FILS related parameters to ROAM event

Vidyullatha Kanchanapally (1):
  nl80211: Update ERP info using NL80211_CMD_UPDATE_CONNECT_PARAMS

 include/net/cfg80211.h       | 51 ++++++++++++++++---------
 include/uapi/linux/nl80211.h |  6 ++-
 net/wireless/core.c          |  4 ++
 net/wireless/nl80211.c       | 90 +++++++++++++++++++++++++++++++++++++-------
 net/wireless/sme.c           | 88 ++++++++++++++++++++++++++++++-------------
 5 files changed, 180 insertions(+), 59 deletions(-)

--
1.9.1
