Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f171.google.com ([209.85.160.171]:35347 "EHLO
	mail-yk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757592AbcAKLCy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jan 2016 06:02:54 -0500
Received: by mail-yk0-f171.google.com with SMTP id x67so427274099ykd.2
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jan 2016 03:02:54 -0800 (PST)
MIME-Version: 1.0
From: Bartlomiej Grzeskowiak <bartlomiej.grzeskowiak@gmail.com>
Date: Mon, 11 Jan 2016 12:02:24 +0100
Message-ID: <CADaZW1Gi0k2WjhCo+KZ=pijO2q7o9dE7fM8tTXMG8+LW=36acw@mail.gmail.com> (sfid-20160111_120257_355970_3E682A07)
Subject: WLAN drivers provided by Realtek do not work with backports (cfg80211
 module not compatible)
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We use 8192cu and 8811AU provided by Realtek. Our kernel is 3.10.
We would like to add parallel support for ath10k_pci from backports.

However after inserting compat.ko, cfg80211.ko and mac80211.ko from
backports, 8192cu.ko and 8821au.ko terminate with following message:
[  512.188364] 8192cu: Unknown symbol wiphy_new (err 0)
[  512.188481] 8192cu: Unknown symbol cfg80211_send_disassoc (err 0)
[  512.188554] 8192cu: Unknown symbol cfg80211_send_rx_assoc (err 0)
[  512.188607] 8192cu: Unknown symbol cfg80211_inform_bss_frame (err 0)

Those interfaces are exported when I load cfg80211.ko compiled from kernel 3.10.
But I can not see them in cfg80211.ko provided by backports.

Do you know this problem ?
Is there any easy way to solve this issue ?

BR
Bartek
