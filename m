Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:22236 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbaK1J1c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 04:27:32 -0500
Message-ID: <54784001.7020706@broadcom.com> (sfid-20141128_102738_703138_F8AE6491)
Date: Fri, 28 Nov 2014 10:27:29 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: "hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Multiple-BSSID issues with hostapd
Content-Type: text/plain; charset="windows-1252"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jouni,

For the brcmfmac we started working on Multiple-BSSID support and came
across some issues with hostapd that are listed listed below.

BSS1 setup on netdev wlan0
BSS2 setup on netdev wlan0_0

* get_station() done on wrong netdev

observed:
Upon association of STA1 with BSS2 (wlan0_0) a get_station() is done for
STA1 with wlan0 as netdev.
expected:
get_station() for STA1 with wlan0_0 as netdev. We verified that wlan0_0
ifindex was used in NL80211_CMD_NEW_STATION event.

* cleanup of wlan0_0 not done upon terminating hostapd

observed:
Upon terminating hostapd, only change interface from AP->STA is received
for wlan0_0 and wlan0. The stop_ap is only done for BSS1. So ending up
with additional netdev, ie. wlan0_0.
expected:
following sequence seems more appropriate:
stop_ap() for BSS2
if_remove() for BSS2
stop_ap() for BSS1
if_change() AP->STA for BSS1

Do you think it makes sense to correct these scenarios according the
described expected behaviour? Maybe the behaviour is only expected by me
and there is a good reason for the current behaviour.

Regards,
Arend


