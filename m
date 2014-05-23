Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:37518 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbaEWKf5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 06:35:57 -0400
Received: by mail-ee0-f48.google.com with SMTP id e49so3498033eek.21
        for <linux-wireless@vger.kernel.org>; Fri, 23 May 2014 03:35:56 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/3] ath10k: async pci probing
Date: Fri, 23 May 2014 12:28:44 +0200
Message-Id: <1400840927-14272-1-git-send-email-michal.kazior@tieto.com> (sfid-20140523_123603_261767_A1ADE36B)
In-Reply-To: <1400767955-16313-1-git-send-email-michal.kazior@tieto.com>
References: <1400767955-16313-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Recently I've tried to build ath10k into kernel
and discovered it doesn't play nice.


v2:
 * split and introduce an additional patch [2/3]
 * unbind driver upon failure


Michal Kazior (3):
  ath10k: relocate core create/destroy functions
  ath10k: remove unnecessary tasklet_kill()
  ath10k: make core registering async

 drivers/net/wireless/ath/ath10k/core.c | 171 ++++++++++++++++++---------------
 drivers/net/wireless/ath/ath10k/core.h |   2 +
 drivers/net/wireless/ath/ath10k/pci.c  |   2 -
 3 files changed, 97 insertions(+), 78 deletions(-)

-- 
1.8.5.3

