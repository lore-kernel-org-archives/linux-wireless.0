Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f183.google.com ([209.85.211.183]:52169 "EHLO
	mail-yw0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbZGaQLt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 12:11:49 -0400
Received: by ywh13 with SMTP id 13so1873922ywh.15
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2009 09:11:48 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 31 Jul 2009 09:11:27 -0700
Message-ID: <43e72e890907310911k3c3bd54al20188301b7f8d97d@mail.gmail.com>
Subject: regression on mac80211_hswim
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Jouni Malinen <j@w1.fi>, Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Noticed a regression on mac80211_hwsim when creating two devices using
regtest=4. Here's the doc on regtest=4:

 * @HWSIM_REGTEST_WORLD_ROAM: Used for testing the world roaming. We acomplish
 *      this by using a custom beacon-capable regulatory domain for the first
 *      radio. All other device world roam.

HWSIM_REGTEST_WORLD_ROAM = 4,

So I used to test world roaming without any hardware by starting
hostapd on wlan0, and then scanning on the wlan1. Today wlan1 never
sees wlan0's AP. Tested with git hostapd, and wireless-testing. I
would have looked further into it but I really have no time to do so.

  Luis
