Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31682 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181AbbI3KFW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 06:05:22 -0400
Date: Wed, 30 Sep 2015 13:05:12 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Tony Cho <tony.cho@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	rachel.kim@atmel.com, chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH 32/32] staging: wilc1000: fix kernel fail after ifconfig
 wlan0 up
Message-ID: <20150930100512.GE7340@mwanda> (sfid-20150930_120531_131036_3A2A6272)
References: <1443606914-25563-1-git-send-email-tony.cho@atmel.com>
 <1443606914-25563-10-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1443606914-25563-10-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ugh...  No.  Just do this:

diff --git a/drivers/staging/wilc1000/wilc_msgqueue.c b/drivers/staging/wilc1000/wilc_msgqueue.c
index 869736a..52d8f95 100644
--- a/drivers/staging/wilc1000/wilc_msgqueue.c
+++ b/drivers/staging/wilc1000/wilc_msgqueue.c
@@ -102,6 +102,8 @@ int wilc_mq_send(WILC_MsgQueueHandle *pHandle,
 
 	up(&pHandle->hSem);
 
+	return 0;
+
 ERRORHANDLER:
 	/* error occured, free any allocations */
 	if (pstrMessage) {
