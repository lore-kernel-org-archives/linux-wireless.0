Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49686 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756057AbXEKCtI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2007 22:49:08 -0400
Subject: [PATCH 03/19] libertas: fix size of SSID comparison in stop_adhoc  check
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1178829040.6356.1.camel@localhost.localdomain>
References: <1178829040.6356.1.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 10 May 2007 22:52:37 -0400
Message-Id: <1178851957.8607.15.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Dan Williams <dcbw@redhat.com>
---
 drivers/net/wireless/libertas/assoc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/libertas/assoc.c b/drivers/net/wireless/libertas/assoc.c
index b55c7f5..dfffabc 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -333,7 +333,7 @@ static int should_stop_adhoc(wlan_adapter *adapter,
 	if (adapter->curbssparams.ssid.ssidlength != assoc_req->ssid.ssidlength)
 		return 1;
 	if (memcmp(adapter->curbssparams.ssid.ssid, assoc_req->ssid.ssid,
-			sizeof(struct WLAN_802_11_SSID)))
+			adapter->curbssparams.ssid.ssidlength))
 		return 1;
 
 	/* FIXME: deal with 'auto' mode somehow */
-- 
1.5.0.6



