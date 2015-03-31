Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:34568 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbbCaKwc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2015 06:52:32 -0400
Received: by lboc7 with SMTP id c7so9349165lbo.1
        for <linux-wireless@vger.kernel.org>; Tue, 31 Mar 2015 03:52:30 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 0/2] ath10k: improve set_bitrate_mask
Date: Tue, 31 Mar 2015 10:49:19 +0000
Message-Id: <1427798961-7334-1-git-send-email-michal.kazior@tieto.com> (sfid-20150331_125243_387644_1F19F126)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This makes set_bitrate_mask more flexible by
allowing more than applying simple single rate or
max nss limits.

This still isn't ideal and VHT MCSs can't be set
separately (only a few range-options are allowed).

v2:
 * fix ouf-of-bounds
 * rebased to master branch + multi-channel patches

This will not apply cleanly without multi-channel
support and conflict resolution will be
non-trivial.


Michal Kazior (2):
  ath10k: clean up set_bitrate_mask handling
  ath10k: implement more versatile set_bitrate_mask

 drivers/net/wireless/ath/ath10k/core.h |   4 +-
 drivers/net/wireless/ath/ath10k/mac.c  | 708 +++++++++++++++++++--------------
 2 files changed, 421 insertions(+), 291 deletions(-)

-- 
2.1.4

