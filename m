Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:57363 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242AbZF3LJ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 07:09:26 -0400
Received: by fxm18 with SMTP id 18so49944fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2009 04:09:27 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: mac80211 sw scan: passive dwell time
Date: Tue, 30 Jun 2009 13:09:30 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200906301309.30630.helmut.schaa@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

in mac80211's software scan implementation the passive dwell time
IEEE80211_PASSIVE_CHANNEL_TIME is set to (HZ / 5) which means we
stay 200ms on each passive channel. Compared to iwlwifi's hw scan
and the old ipw* drivers which use values around 120ms this is quite
long.

Reducing the passive dwell time from 200ms to 120ms could save us
something around a second on cards capable of 11a and we would be still
able to catch beacons from most access points (assuming a ~100ms beacon
interval).

Objections?

Thanks,
Helmut
