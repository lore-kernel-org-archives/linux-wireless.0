Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50716 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab1JKLjq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 07:39:46 -0400
Message-ID: <4E942AF7.10500@qca.qualcomm.com> (sfid-20111011_133950_045589_588E0A58)
Date: Tue, 11 Oct 2011 14:39:35 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Jouni Malinen <jouni@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/5] ath6kl: Add debugfs file for target roam table
References: <1318243411-16110-1-git-send-email-jouni@qca.qualcomm.com> <1318243411-16110-3-git-send-email-jouni@qca.qualcomm.com>
In-Reply-To: <1318243411-16110-3-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/10/2011 01:43 PM, Jouni Malinen wrote:
> The new roam_table debugfs file can be used to display the current
> roam table from the target.

One comment:

> +static int ath6kl_wmi_roam_tbl_event_rx(struct wmi *wmi, u8 *datap, int len)
> +{
> +#ifdef CONFIG_ATH6KL_DEBUG
> +	struct ath6kl *ar = wmi->parent_dev;
> +	struct wmi_target_roam_tbl *tbl;
> +	u16 num_entries;
> +
> +	if (len < sizeof(*tbl))
> +		return -EINVAL;
> +
> +	tbl = (struct wmi_target_roam_tbl *) datap;
> +	num_entries = le16_to_cpu(tbl->num_entries);
> +	if (sizeof(*tbl) + num_entries * sizeof(struct wmi_bss_roam_info) > len)
> +		return -EINVAL;
> +
> +	if (ar->debug.roam_tbl == NULL ||
> +	    ar->debug.roam_tbl_len < (unsigned int) len) {
> +		kfree(ar->debug.roam_tbl);
> +		ar->debug.roam_tbl = kmalloc(len, GFP_ATOMIC);
> +		if (ar->debug.roam_tbl == NULL)
> +			return -ENOMEM;
> +	}
> +
> +	memcpy(ar->debug.roam_tbl, datap, len);
> +	ar->debug.roam_tbl_len = len;
> +
> +	if (test_bit(ROAM_TBL_PEND, &ar->flag)) {
> +		clear_bit(ROAM_TBL_PEND, &ar->flag);
> +		wake_up(&ar->event_wq);
> +	}
> +#endif /* CONFIG_ATH6KL_DEBUG */
> +
> +	return 0;
> +}

I would prefer to have the part inside ifdef in debug.c, for example
like ath6kl_debug_fwlog_event() is implemented. That way we can get rid
of the ifdef inside code and related functinality would be in the same file.

Kalle
