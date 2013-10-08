Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:39427 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab3JHCyS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Oct 2013 22:54:18 -0400
Received: by mail-pa0-f53.google.com with SMTP id kq14so8135639pab.40
        for <linux-wireless@vger.kernel.org>; Mon, 07 Oct 2013 19:54:18 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v3 0/2] ath10k: wep & ampdu fix
Date: Mon,  7 Oct 2013 19:51:56 -0700
Message-Id: <1381200718-16271-1-git-send-email-michal.kazior@tieto.com> (sfid-20131008_045422_414653_354714A3)
In-Reply-To: <1380874630-14280-1-git-send-email-michal.kazior@tieto.com>
References: <1380874630-14280-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

One throughput fix and one bug fix.

The bug fix addresses my oversight when reworking
HTC/WMI. I haven't seen the error yet but I'm
quite certain this should be fixed.

v2:
 * A-MPDU patch contains a workaround for
   Netgear/Linksys 11ac APs
 * patchset cover mail title changed to avoid
   confusion (too many patchsets named the same
   way..)

v3:
 * fix lines over 80 chars (Kalle)
 * fix max() cast warning (Kalle)
 * rebase (Kalle)
 * add Tested-by (thanks Kalle!)


Michal Kazior (1):
  ath10k: fix scheduling while atomic bug

Sujith Manoharan (1):
  ath10k: Fix bug in max. VHT A-MPDU size

 drivers/net/wireless/ath/ath10k/core.h |  4 +-
 drivers/net/wireless/ath/ath10k/mac.c  | 68 +++++++++++++++++++++++++---------
 2 files changed, 53 insertions(+), 19 deletions(-)

-- 
1.8.4.rc3

