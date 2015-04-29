Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:33107 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbbD2Xvz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2015 19:51:55 -0400
Received: by iecrt8 with SMTP id rt8so55305014iec.0
        for <linux-wireless@vger.kernel.org>; Wed, 29 Apr 2015 16:51:55 -0700 (PDT)
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	adrian.chadd@gmail.com, Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 00/11] ath9k: Spectral scan updates
Date: Wed, 29 Apr 2015 23:51:11 +0000
Message-Id: <1430351482-59418-1-git-send-email-mickflemm@gmail.com> (sfid-20150430_015200_344723_6112A7BF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On FFT spectral scans the hardware is able to send multiple FFT
frames per report (packet).

This is the default behavior when short_repeat is set to 0
(when is set to 1 hw will only generate one frame per report since
it only has 4usec to perform the measurement), however the current
code doesn't support that. In case hardware sends multiple frames
back the length check will fail and no frames will be processed. So
the current code doesn't work unless short_repeat is set to 1 or if
the hardware sends a single report per packet for some other reason.
Notice that on ath9k_htc short_repeat is by default set to 0
so that's what happened on my experiments with an AR7010 + AR9280
device, I got lots of data back but no output on the spectral scan.

This patch series adds support for handling multiple FFT frames per
report, performs a few integrity checks on the received data and
in general improves the handling of FFT spectral scans.

Note that this feature generates a LOT of data, each report can be
up to 1K for HT20 and 2K+ for HT20/40. It's meant to be used for
real-time data processing in the userspace. The buffers we currently
have for relayfs won't be able to handle a full report unless they
are being consumed from the userspace fast enough. That's why this
feature is disabled by default (short_repeat is set to 1 by default
also on ath9k_htc).

Now we need someone to write a nice real-time GUI for that...

Many thanks to Adrian Chadd for adding support for FFT spectral
scans in the first place !

Hope you enjoy it ;-)

Nick Kossifidis (11):
 Add a new debug flag for FFT spectral scan
 Fix hanlding of maximum magnitude index
 Move processing of FFT frames to different functions
 Perform integrity checks when processing FFT frames
 Support processing of multiple FFT frames per report
 Skip malformed frames on normal FFT report
 No need for that extra memcpy
 Skip FFT reports if we are out of output buffers
 No need for that extra memset
 Mix the received FFT bins to the random pool
 Enable short repeat by default on ath9k_htc

 drivers/net/wireless/ath/ath.h                   |   2 +
 drivers/net/wireless/ath/ath9k/common-spectral.c | 740 +++++++++++++++++++----
 drivers/net/wireless/ath/ath9k/common-spectral.h |  35 +-
 drivers/net/wireless/ath/ath9k/htc_drv_init.c    |   2 +-
 4 files changed, 646 insertions(+), 133 deletions(-)

-- 
2.3.5

