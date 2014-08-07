Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:64984 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbaHGMpO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2014 08:45:14 -0400
From: Arend van Spriel <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH for-3.17 0/2] brcmfmac: early bug fixes
Date: Thu, 7 Aug 2014 14:45:07 +0200
Message-ID: <1407415509-22442-1-git-send-email-arend@broadcom.com> (sfid-20140807_144532_012357_0CC9FE4E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This small series fixes two issues found. The memory leak was reported
as allocation without checking result, which revealed that the allocated
buffer was never freed. The other issue was observed upon resolving a
merge conflict between our internal branch and the wireless-testing
master branch.

Arend van Spriel (2):
  brcmfmac: fix curly brace mistake in brcmf_pcie_handle_mb_data()
  brcmfmac: fix memory leakage in msgbuf

 drivers/net/wireless/brcm80211/brcmfmac/msgbuf.c | 4 ++++
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c   | 3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

-- 
1.9.1

