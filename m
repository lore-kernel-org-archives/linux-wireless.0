Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752717Ab2AaOF2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 09:05:28 -0500
Date: Tue, 31 Jan 2012 15:05:13 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Luigi Tarenga <luigi.tarenga@gmail.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: PROBLEM: rt2800lib return -128db when signal is stronger than
 -12db
Message-ID: <20120131140512.GC2950@redhat.com> (sfid-20120131_150531_413249_16E369AE)
References: <CAKkO-EgF=NKpj-duK5oOTCMdbOnc0HwmBT9oc9FhtqT5KqZgeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKkO-EgF=NKpj-duK5oOTCMdbOnc0HwmBT9oc9FhtqT5KqZgeg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 30, 2012 at 03:23:15PM +0100, Luigi Tarenga wrote:
> -	int rssi0 = rt2x00_get_field32(rxwi_w2, RXWI_W2_RSSI0);
> -	int rssi1 = rt2x00_get_field32(rxwi_w2, RXWI_W2_RSSI1);
> -	int rssi2 = rt2x00_get_field32(rxwi_w2, RXWI_W2_RSSI2);
> +	s8 rssi0 = rt2x00_get_field32(rxwi_w2, RXWI_W2_RSSI0);
> +	s8 rssi1 = rt2x00_get_field32(rxwi_w2, RXWI_W2_RSSI1);
> +	s8 rssi2 = rt2x00_get_field32(rxwi_w2, RXWI_W2_RSSI2);
>  	u16 eeprom;
>  	u8 offset0;
>  	u8 offset1;
> @@ -539,11 +539,12 @@
>  	/*
>  	 * Convert the value from the descriptor into the RSSI value
>  	 * If the value in the descriptor is 0, it is considered invalid
> -	 * and the default (extremely low) rssi value is assumed
> +	 * and the default (extremely low) rssi value is assumed.
> +         * HW rssiX values go from -13 (strongest) to positive number
> (weakest).
>  	 */
> -	rssi0 = (rssi0) ? (-12 - offset0 - rt2x00dev->lna_gain - rssi0) : -128;
> -	rssi1 = (rssi1) ? (-12 - offset1 - rt2x00dev->lna_gain - rssi1) : -128;
> -	rssi2 = (rssi2) ? (-12 - offset2 - rt2x00dev->lna_gain - rssi2) : -128;
> +	rssi0 = (rssi0) ? (-13 - offset0 - rt2x00dev->lna_gain - rssi0) : -128;
> +	rssi1 = (rssi1) ? (-13 - offset1 - rt2x00dev->lna_gain - rssi1) : -128;
> +	rssi2 = (rssi2) ? (-13 - offset2 - rt2x00dev->lna_gain - rssi2) : -128;

Not sure if change -12 to -13 is needed, seems not compatible with
vendor driver. If you just change rssiX type to s8, will it
fix the problem? That seems to be correct and enough to fix
(example why this make difference: 0xc0 gives s8: -64 int: 192).

If you will be reposting please follow
http://linux.yyz.us/patch-format.html
especially add Signed-off-by: line.

Thanks
Stanislaw
