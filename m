Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47140 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751764AbcINOSQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 10:18:16 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "greearb@candelatech.com" <greearb@candelatech.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 09/21] ath10k: print fw debug messages in hex.
Date: Wed, 14 Sep 2016 14:18:05 +0000
Message-ID: <87oa3qefac.fsf@kamboji.qca.qualcomm.com> (sfid-20160914_161819_702609_197D6FEB)
References: <1462986153-16318-1-git-send-email-greearb@candelatech.com>
        <1462986153-16318-10-git-send-email-greearb@candelatech.com>
In-Reply-To: <1462986153-16318-10-git-send-email-greearb@candelatech.com>
        (greearb@candelatech.com's message of "Wed, 11 May 2016 10:02:21        -0700")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> This allows user-space tools to decode debug-log
> messages by parsing dmesg or /var/log/messages.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>

Don't tracing points already provide the same information?

> +void ath10k_dbg_print_fw_dbg_buffer(struct ath10k *ar, __le32 *ibuf, int=
 len,
> +				    const char* lvl)
> +{
> +	/* Print out raw hex, external tools can decode if
> +	 * they care.
> +	 * TODO:  Add ar identifier to messages.
> +	 */
> +	int q =3D 0;
> +
> +	dev_printk(lvl, ar->dev, "ath10k_pci ATH10K_DBG_BUFFER:\n");
> +	while (q < len) {
> +		if (q + 8 <=3D len) {
> +			printk("%sath10k: [%04d]: %08X %08X %08X %08X %08X %08X %08X %08X\n",
> +			       lvl, q,
> +			       ibuf[q], ibuf[q+1], ibuf[q+2], ibuf[q+3],
> +			       ibuf[q+4], ibuf[q+5], ibuf[q+6], ibuf[q+7]);
> +			q +=3D 8;
> +		}
> +		else if (q + 7 <=3D len) {
> +			printk("%sath10k: [%04d]: %08X %08X %08X %08X %08X %08X %08X\n",
> +			       lvl, q,
> +			       ibuf[q], ibuf[q+1], ibuf[q+2], ibuf[q+3],
> +			       ibuf[q+4], ibuf[q+5], ibuf[q+6]);
> +			q +=3D 7;
> +		}
> +		else if (q + 6 <=3D len) {
> +			printk("%sath10k: [%04d]: %08X %08X %08X %08X %08X %08X\n",
> +			       lvl, q,
> +			       ibuf[q], ibuf[q+1], ibuf[q+2], ibuf[q+3],
> +			       ibuf[q+4], ibuf[q+5]);
> +			q +=3D 6;
> +		}
> +		else if (q + 5 <=3D len) {
> +			printk("%sath10k: [%04d]: %08X %08X %08X %08X %08X\n",
> +			       lvl, q,
> +			       ibuf[q], ibuf[q+1], ibuf[q+2], ibuf[q+3],
> +			       ibuf[q+4]);
> +			q +=3D 5;
> +		}
> +		else if (q + 4 <=3D len) {
> +			printk("%sath10k: [%04d]: %08X %08X %08X %08X\n",
> +			       lvl, q,
> +			       ibuf[q], ibuf[q+1], ibuf[q+2], ibuf[q+3]);
> +			q +=3D 4;
> +		}
> +		else if (q + 3 <=3D len) {
> +			printk("%sath10k: [%04d]: %08X %08X %08X\n",
> +			       lvl, q,
> +			       ibuf[q], ibuf[q+1], ibuf[q+2]);
> +			q +=3D 3;
> +		}
> +		else if (q + 2 <=3D len) {
> +			printk("%sath10k: [%04d]: %08X %08X\n",
> +			       lvl, q,
> +			       ibuf[q], ibuf[q+1]);
> +			q +=3D 2;
> +		}
> +		else if (q + 1 <=3D len) {
> +			printk("%sath10k: [%04d]: %08X\n",
> +			       lvl, q,
> +			       ibuf[q]);
> +			q +=3D 1;
> +		}
> +		else {
> +			break;
> +		}
> +	}/* while */
> +
> +	dev_printk(lvl, ar->dev, "ATH10K_END\n");
> +}

Isn't this almost the same as what ath10k_dbg_dump() does?

--=20
Kalle Valo=
