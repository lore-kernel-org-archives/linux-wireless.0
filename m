Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f170.google.com ([209.85.217.170]:36548 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752535AbbCXM7y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2015 08:59:54 -0400
Received: by lbbug6 with SMTP id ug6so45773271lbb.3
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2015 05:59:53 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/2] ath10k: improve set_bitrate_mask
Date: Tue, 24 Mar 2015 12:57:14 +0000
Message-Id: <1427201836-7741-1-git-send-email-michal.kazior@tieto.com> (sfid-20150324_140009_663003_A120FB5F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes set_bitrate_mask more flexible by
allowing more than applying simple single rate or
max nss limits.

This still isn't ideal and VHT MCSs can't be set
separately (only a few range-options are allowed).

This depends on:
 * ath10k: add multi-channel support
 * ath10k: cleanups 2015-03-20

Based on:
 * Kalle's pending branch + multi-channel support

This will not apply cleanly without multi-channel
support and conflict resolution will be
non-trivial.

Michal Kazior (2):
  ath10k: clean up set_bitrate_mask handling
  ath10k: implement more versatile set_bitrate_mask

 drivers/net/wireless/ath/ath10k/core.h |   4 +-
 drivers/net/wireless/ath/ath10k/mac.c  | 705 +++++++++++++++++++--------------
 2 files changed, 419 insertions(+), 290 deletions(-)

-- 
2.1.4

