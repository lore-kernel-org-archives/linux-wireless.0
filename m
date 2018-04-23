Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:46972 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753755AbeDWBOa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 22 Apr 2018 21:14:30 -0400
Received: by mail-pg0-f53.google.com with SMTP id t12so7187388pgp.13
        for <linux-wireless@vger.kernel.org>; Sun, 22 Apr 2018 18:14:30 -0700 (PDT)
To: linux-wireless@vger.kernel.org, nataraja@qca.qualcomm.com,
        jouni@qca.qualcomm.com
From: Eric Nelson <eric@nelint.com>
Subject: Tuning roaming on ath6kl through debugfs
Message-ID: <4fc8114b-487b-6f13-9712-a87c8a24c8b5@nelint.com> (sfid-20180423_031437_279104_CE79C18B)
Date: Sun, 22 Apr 2018 18:14:28 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

Does anyone have insight into how the various debugfs files can
be used to control roaming in the ath6kl driver?

Commit e5090444 [1] added support for setting an RSSI "threshold" for
roaming, but doesn't explain the units involved or what occurs when
this threshold is reached or its' relationship to DEF_LRSSI_ROAM_FLOOR.

Commit 1261875 [2] added support for three roaming modes with a
similarly opaque commit message:

	default
	bssbias
	lock

The meaning of these modes isn't spelled out though. I presume
that "lock" will prevent the wireless device from automatically
switching between BSS's, but what are the "default" and "bssbias"
values?

Some insight into the operation of the wireless device can be seen
by looking at the roam_table entry. It seems to show the current RSSI
values for all BSS's with the current SSID, but I've been unable to
force roaming through the use of the lrssi_roam_threshold entry and
also by re-compiles with lower (and higher) values of
DEF_LRSSI_ROAM_FLOOR.

It's also not clear to me how upper layers of the WiFi stack
(i.e. wpa_supplicant) would handle automatic switching of
BSS by the Atheros device itself.

If roaming is a problem for an application, can the value of "lock"
for "roam_mode" be used to disable the feature entirely?

1 - 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e5090444
2 - 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1261875

Please advise,


Eric
