Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:62487 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756313AbaHHJbi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Aug 2014 05:31:38 -0400
Received: by mail-wi0-f171.google.com with SMTP id hi2so700700wib.4
        for <linux-wireless@vger.kernel.org>; Fri, 08 Aug 2014 02:31:35 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	Ben Greear <greearb@candelatech.com>,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [RFC 0/3] ath10k: ce fixes 2014-08-08
Date: Fri,  8 Aug 2014 11:22:12 +0200
Message-Id: <1407489735-28091-1-git-send-email-michal.kazior@tieto.com> (sfid-20140808_113147_302588_B9BDA076)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This removes implicit endianess in some places.
I'd love to get rid of it from
ath10k_pci_diag_access* as well but let's fix
ath10k_pci_diag_mem_* first.

@Kalle, @Ben: As far as I understand this
conflicts with fw dumping you work on so I'm
tentatively posting this as an RFC first.


Michal Kazior (3):
  ath10k: move pci init structures
  ath10k: dont duplicate service-pipe mapping
  ath10k: make target endianess more explicit

 drivers/net/wireless/ath/ath10k/pci.c | 410 +++++++++++++++++-----------------
 drivers/net/wireless/ath/ath10k/pci.h |  18 +-
 2 files changed, 210 insertions(+), 218 deletions(-)

-- 
1.8.5.3

