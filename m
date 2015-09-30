Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.242]:14485 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932139AbbI3MVY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 08:21:24 -0400
From: "Kim, Leo" <Leo.Kim@atmel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
	"Cho, Tony" <Tony.Cho@atmel.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"Kim, Rachel" <Rachel.Kim@atmel.com>,
	"Park, Chris" <Chris.Park@atmel.com>,
	"Shin, Austin" <Austin.Shin@atmel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Kim, Johnny" <johnny.kim@atmel.com>,
	"Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
	"Noureldin, Adel" <Adel.Noureldin@atmel.com>,
	"Abozaeid, Adham" <Adham.Abozaeid@atmel.com>
Subject: RE: [PATCH 32/32] staging: wilc1000: fix kernel fail after ifconfig
 wlan0 up
Date: Wed, 30 Sep 2015 12:21:19 +0000
Message-ID: <74F3875218FC364C9618AB19CB60E9057670C1D4@penmbx02.corp.atmel.com> (sfid-20150930_142127_506480_7B33C468)
References: <1443606914-25563-1-git-send-email-tony.cho@atmel.com>
 <1443606914-25563-10-git-send-email-tony.cho@atmel.com>
 <20150930100512.GE7340@mwanda>
In-Reply-To: <20150930100512.GE7340@mwanda>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear Dan,

Thank you! 
Always helpful your advice listen carefully.

I will send in the morning.

 Thanks, BR
 Leo

-----Original Message-----
From: Dan Carpenter [mailto:dan.carpenter@oracle.com] 
Sent: Wednesday, September 30, 2015 7:05 PM
To: Cho, Tony
Cc: gregkh@linuxfoundation.org; devel@driverdev.osuosl.org; Kim, Rachel; Park, Chris; Shin, Austin; linux-wireless@vger.kernel.org; Kim, Johnny; Ferre, Nicolas; Noureldin, Adel; Kim, Leo; Abozaeid, Adham
Subject: Re: [PATCH 32/32] staging: wilc1000: fix kernel fail after ifconfig wlan0 up

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
