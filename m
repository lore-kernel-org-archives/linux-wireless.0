Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f43.google.com ([209.85.215.43]:33183 "EHLO
        mail-lf0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932675AbcJMQlt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Oct 2016 12:41:49 -0400
Received: by mail-lf0-f43.google.com with SMTP id x79so148663235lff.0
        for <linux-wireless@vger.kernel.org>; Thu, 13 Oct 2016 09:40:53 -0700 (PDT)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC 0/5] ath6kl: non WMI data service support
Date: Thu, 13 Oct 2016 18:39:24 +0200
Message-Id: <1476376769-4708-1-git-send-email-erik.stromdahl@gmail.com> (sfid-20161013_184155_071475_1BEF514F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series is intended to prepare the ath6kl driver
for newer chipsets that doesn't use the current WMI data
endpoints for data traffic.

The chipset I have been working with (and used for testing)
is QCA6584. It is SDIO based (at least the variant I have
been using) with 802.11p WAVE DSRC capabilities.

This chipset is different from the AR600X family in that
it does not use the WMI data services (service id's 0x101
to 0x104 ) for data traffic.
Instead it uses the HTT data service for data and wmi unified
for control messages.
It is also different when it comes to mailbox addresses
and HTC header format as well, but these differences are not
part of this patch series.

Erik Stromdahl (5):
  ath6kl: HTC mbox tx complete cb support
  ath6kl: Updated TARG_VTOP macro with default value
  ath6kl: Added disable credit flow ctrl for mbox
  ath6kl: Updated credit setup
  ath6kl: service connect rewrite

 drivers/net/wireless/ath/ath6kl/core.h     |   3 +
 drivers/net/wireless/ath/ath6kl/htc-ops.h  |   2 +-
 drivers/net/wireless/ath/ath6kl/htc.h      |   4 +-
 drivers/net/wireless/ath/ath6kl/htc_mbox.c |  75 +++++-------
 drivers/net/wireless/ath/ath6kl/htc_pipe.c |  16 +--
 drivers/net/wireless/ath/ath6kl/init.c     | 187 +++++++++++++++++------------
 drivers/net/wireless/ath/ath6kl/target.h   |   4 +-
 7 files changed, 156 insertions(+), 135 deletions(-)

-- 
2.1.4
