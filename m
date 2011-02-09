Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:52517 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563Ab1BIPam (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 10:30:42 -0500
Message-ID: <4D52B31E.3030902@neratec.com>
Date: Wed, 09 Feb 2011 16:30:38 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath9k: pulse detection
References: <1297252905-29739-1-git-send-email-zefir.kurtisi@neratec.com>,<1297252905-29739-3-git-send-email-zefir.kurtisi@neratec.com> <44EE5C37ADC36343B0625A05DD408C4850DAA785D2@CHEXMB-01.global.atheros.com>
In-Reply-To: <44EE5C37ADC36343B0625A05DD408C4850DAA785D2@CHEXMB-01.global.atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/09/2011 04:15 PM, Vasanth Thiagarajan wrote:
> 
> +       /* update 64-bit time stamp with that of rs */
> +       /* TODO: do this per-wiphy */
> +       ts = rs->rs_tstamp;
> +       if (ts <= (last_ts & 0xffffffff))
> 
> last_ts is not initialized.
true, but does not really matter since only deltas are relevant.

> +               ts_hi++;
> +       last_ts = ((u64)ts_hi << 32) | ts;
> +
> +
> +       if (rs->rs_datalen != 0) {
> +               char *vdata = (char *)ds->ds_vdata + rs->rs_datalen - 3;
> +               dur = (u32) vdata[0];
> +       }
> +
> +       /* ZKU: reverse measured scaling factor of 2/3 for duration */
> 
> ZKU ??
> 
thats me :)

Sorry letting you read the code. It is meant only to test the proposed 
approach. I missed to change the prefix to RFC.

Zefir

> Vasanth--
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

