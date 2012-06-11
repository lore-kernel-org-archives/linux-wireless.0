Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm18-vm0.bullet.mail.ac4.yahoo.com ([98.139.53.210]:24793 "HELO
	nm18-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750948Ab2FKWlv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 18:41:51 -0400
References: <1339452813.67695.YahooMailNeo@web81603.mail.mud.yahoo.com>
Message-ID: <1339454087.28071.YahooMailNeo@web81608.mail.mud.yahoo.com> (sfid-20120612_004155_278113_E1B9DEBE)
Date: Mon, 11 Jun 2012 15:34:47 -0700 (PDT)
From: Peter Tam <peterctam@yahoo.com>
Reply-To: Peter Tam <peterctam@yahoo.com>
Subject: Atheros 6K WiFi USB adaptors
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1339452813.67695.YahooMailNeo@web81603.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I thought I saw support code usb.c for that AR6000 wifi chip set. I know there is extensive support for the SDIO interface version. But on detail examination, the usb.c code is missing a lot of hif_ops interfce routines.

The equivalents of 
.read_write_sync = ath6kl_sdio_read_write_sync,
.write_async = ath6kl_sdio_write_async,
.irq_enable = ath6kl_sdio_irq_enable,
.irq_disable = ath6kl_sdio_irq_disable,
.scatter_req_get = ath6kl_sdio_scatter_req_get,
.scatter_req_add = ath6kl_sdio_scatter_req_add,
.enable_scatter = ath6kl_sdio_enable_scatter,
.scat_req_rw = ath6kl_sdio_async_rw_scatter,
.cleanup_scatter = ath6kl_sdio_cleanup_scatter,

are missing in usb.c vs sdio.c for examples.

Can some decent soul tell me where
.read_write_sync = ath6kl_usb_read_write_sync,
.write_async = ath6kl_usb_write_async,
.irq_enable = ath6kl_usb_irq_enable,
.irq_disable = ath6kl_usb_irq_disable,
.scatter_req_get = ath6kl_usb_scatter_req_get,
.scatter_req_add = ath6kl_usb_scatter_req_add,
.enable_scatter = ath6kl_usb_enable_scatter,
.scat_req_rw = ath6kl_usb_async_rw_scatter,
.cleanup_scatter = ath6kl_usb_cleanup_scatter,

are sourced from?



Peter
