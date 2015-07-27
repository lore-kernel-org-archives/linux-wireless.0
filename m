Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dub004-omc3s21.hotmail.com ([157.55.2.30]:64951 "EHLO
	DUB004-OMC3S21.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752041AbbG0IUh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2015 04:20:37 -0400
Message-ID: <DUB128-W86C6FB82F690B96CCC5C5E9C8E0@phx.gbl> (sfid-20150727_102040_719832_481A3016)
From: David Binderman <dcb314@hotmail.com>
To: "johnny.kim@atmel.com" <johnny.kim@atmel.com>,
	"rachel.kim@atmel.com" <rachel.kim@atmel.com>,
	"dean.lee@atmel.com" <dean.lee@atmel.com>,
	"chris.park@atmel.com" <chris.park@atmel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: linux-4.2-rc4/drivers/staging/wilc1000/linux_mon.c:264: memory leak
 ?
Date: Mon, 27 Jul 2015 08:20:35 +0000
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello there,

[linux-4.2-rc4/drivers/staging/wilc1000/linux_mon.c:264]: (error) Memory leak: mgmt_tx

Source code is

    mgmt_tx->buff = kmalloc(len, GFP_ATOMIC);
    if (mgmt_tx->buff == NULL) {
        PRINT_ER("Failed to allocate memory for mgmt_tx buff\n");
        return WILC_FAIL;

    }

Suggest add missing call to kfree.


Regards

David Binderman

 		 	   		  