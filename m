Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:28906 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022Ab1BIPSU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 10:18:20 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 09 Feb 2011 07:17:59 -0800
From: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 9 Feb 2011 20:45:46 +0530
Subject: RE: [PATCH 2/2] ath9k: pulse detection
Message-ID: <44EE5C37ADC36343B0625A05DD408C4850DAA785D2@CHEXMB-01.global.atheros.com>
References: <1297252905-29739-1-git-send-email-zefir.kurtisi@neratec.com>,<1297252905-29739-3-git-send-email-zefir.kurtisi@neratec.com>
In-Reply-To: <1297252905-29739-3-git-send-email-zefir.kurtisi@neratec.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


+       /* update 64-bit time stamp with that of rs */
+       /* TODO: do this per-wiphy */
+       ts = rs->rs_tstamp;
+       if (ts <= (last_ts & 0xffffffff))

last_ts is not initialized.
+               ts_hi++;
+       last_ts = ((u64)ts_hi << 32) | ts;
+
+
+       if (rs->rs_datalen != 0) {
+               char *vdata = (char *)ds->ds_vdata + rs->rs_datalen - 3;
+               dur = (u32) vdata[0];
+       }
+
+       /* ZKU: reverse measured scaling factor of 2/3 for duration */

ZKU ??

Vasanth