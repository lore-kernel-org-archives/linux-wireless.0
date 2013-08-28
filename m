Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38990 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753018Ab3H1KPu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Aug 2013 06:15:50 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: implement per-VDEV FW statistics
References: <1377592996-21934-1-git-send-email-bartosz.markowski@tieto.com>
Date: Wed, 28 Aug 2013 13:15:45 +0300
In-Reply-To: <1377592996-21934-1-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Tue, 27 Aug 2013 10:43:16 +0200")
Message-ID: <87k3j6glym.fsf@kamboji.qca.qualcomm.com> (sfid-20130828_121554_406199_4EAEA7D2)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> The WMI_REQUEST_PEER_STAT command with latst (1.0.0.716) FW
> can return per-VDEV statistics. Using debugfs we can fetch this info now.
>
> This is a backward compatible change. In case of older FW the VDEV
> statistics are simply not returned.
>
> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>

[...]

>  		for (i = 0; i < num_peer_stats; i++) {
> -			peer_stats = (struct wmi_peer_stats *)tmp;
> +			peer_stats = (struct wmi_peer_stats_1 *)tmp;

Oh yeah, you assume here that _v2 struct starts with _v1. That's a bit
dangerous, at least add a comment here saying that.

-- 
Kalle Valo
