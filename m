Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:34013 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbbCTN4r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Mar 2015 09:56:47 -0400
Received: by lbbsy1 with SMTP id sy1so75915715lbb.1
        for <linux-wireless@vger.kernel.org>; Fri, 20 Mar 2015 06:56:46 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/9] ath10k: cleanups 2015-03-20
Date: Fri, 20 Mar 2015 13:54:06 +0000
Message-Id: <1426859655-11797-1-git-send-email-michal.kazior@tieto.com> (sfid-20150320_145729_379789_2D9142C1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Here's a bunch of cleanups and fixes associated
with tx/rx rate code.

Feel free to squash some of the patches if you
think it makes sense or let me know which ones you
want me to squash.

There are a few checkpatch warnings for going over
80 chars. I decided to leave them be to avoid code
wrapping which would make the code less readable
than it is now in my opinion.

I have 2 more patches for .set_bitrate_mask()
callback which depend on this patchset. Once you
apply this patchset to your `pending` branch let
me know, please, so I can push the rest with git
indexes your git repo will recognize.


Michal Kazior (9):
  ath10k: move rate definitions to file start
  ath10k: derive rate from bitrate
  ath10k: drop RATETAB_ENT macro
  ath10k: add hw rate definitions
  ath10k: use hw rate definitions for fixed rate
  ath10k: simplify fixed rate selection
  ath10k: rework legacy rx rate decoding
  ath10k: deduplicate bitrate to rate idx conversion
  ath10k: document ofdm/5ghz rate offset with a macro

 drivers/net/wireless/ath/ath10k/htt.h     |   1 +
 drivers/net/wireless/ath/ath10k/htt_rx.c  |  64 ++----------
 drivers/net/wireless/ath/ath10k/hw.h      |  21 ++++
 drivers/net/wireless/ath/ath10k/mac.c     | 161 ++++++++++++++++++------------
 drivers/net/wireless/ath/ath10k/mac.h     |   5 +
 drivers/net/wireless/ath/ath10k/rx_desc.h |  22 ++++
 drivers/net/wireless/ath/ath10k/wmi.c     |  62 +-----------
 7 files changed, 163 insertions(+), 173 deletions(-)

-- 
2.1.4

