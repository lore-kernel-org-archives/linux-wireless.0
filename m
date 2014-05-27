Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0153.hostedemail.com ([216.40.44.153]:46837 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751749AbaE0OAF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 May 2014 10:00:05 -0400
Message-ID: <1401199199.18413.26.camel@joe-AO725> (sfid-20140527_160011_664939_778804DB)
Subject: Re: [PATCH 4/7] wil6210: improve debug for WMI receive
From: Joe Perches <joe@perches.com>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Date: Tue, 27 May 2014 06:59:59 -0700
In-Reply-To: <1401191150-29037-5-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1401191150-29037-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1401191150-29037-5-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-05-27 at 14:45 +0300, Vladimir Kondratiev wrote:
> Print error if no events received. This should not happen.
> If it is, it points to the problem in firmware.
> 
> Print information as soon as possible - mbox pointers and
> event header right after reading it. This helps to identify potential
> problem with memory allocation for the event buffer.
[]
> diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
[]
> @@ -658,21 +658,27 @@ void wmi_recv_cmd(struct wil6210_priv *wil)
[]
> 	for (;;) {
> +	for (n = 0;; n++) {
>  		u16 len;
>  
>  		r->head = ioread32(wil->csr + HOST_MBOX +
>  				   offsetof(struct wil6210_mbox_ctl, rx.head));
> -		if (r->tail == r->head)
> +		if (r->tail == r->head) {
> +			if (n == 0)
> +				wil_err(wil, "No events?\n");

This error message might be expanded a bit to describe
a bit more about what to do: report to you, turn on
event debugging, update firmware, etc...


