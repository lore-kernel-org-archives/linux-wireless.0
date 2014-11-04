Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:60318 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbaKDOeV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 09:34:21 -0500
Received: by mail-la0-f51.google.com with SMTP id q1so983200lam.10
        for <linux-wireless@vger.kernel.org>; Tue, 04 Nov 2014 06:34:20 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH 0/7] ath10k: rework rx path
Date: Tue,  4 Nov 2014 15:22:04 +0100
Message-Id: <1415110931-10945-1-git-send-email-michal.kazior@tieto.com> (sfid-20141104_153425_118704_73D34811)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This patchset unifies rx path. Instead of
branching for A-MSDU and MSDU cases a single
codepath is introduced.

This yields:

   text    data     bss     dec     hex filename
  14068       0       0   14068    36f4 before/htt_rx.o
  13308       3       0   13311    33ff after/htt_rx.o

I haven't measured any Rx performance loss in my
setup but I may be biased. In theory this could
reduce i-cache pressure and improve Rx throughput
on CPU contrained systems by a few mbps.

This patchset serves two purposes though:
 - clean up and unify the Rx path a bit
 - make it possible to reuse code more easily in
   the future


Michal Kazior (7):
  ath10k: start using sk_buff_head
  ath10k: simplify Rx loop
  ath10k: refactor htt->rx_confused
  ath10k: unify rx undecapping
  ath10k: remove unused function argument
  ath10k: use rx descriptor for ppdu status extraction
  ath10k: report rx rate and signal for fragmented Rx

 drivers/net/wireless/ath/ath10k/htt_rx.c | 1063 ++++++++++++++++--------------
 1 file changed, 577 insertions(+), 486 deletions(-)

-- 
1.8.5.3

