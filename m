Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32871 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab3IFJsi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Sep 2013 05:48:38 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Bartosz Markowski <bartosz.markowski@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v4 2/2] ath10k: implement per-VDEV FW statistics
References: <1378196481-13983-1-git-send-email-bartosz.markowski@tieto.com>
	<1378196481-13983-3-git-send-email-bartosz.markowski@tieto.com>
Date: Fri, 6 Sep 2013 12:48:28 +0300
In-Reply-To: <1378196481-13983-3-git-send-email-bartosz.markowski@tieto.com>
	(Bartosz Markowski's message of "Tue, 3 Sep 2013 10:21:21 +0200")
Message-ID: <87eh92i8lv.fsf@kamboji.qca.qualcomm.com> (sfid-20130906_114841_354785_1B4A5D95)
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
> ---

[...]

>  		for (i = 0; i < num_peer_stats; i++) {
> -			peer_stats = (struct wmi_peer_stats *)tmp;
> +			peer_stats = (struct wmi_peer_stats_common *)tmp;

You still have the evil cast here :)

(Evil here meaning that that you make the implicit assumption that _v1
and _v2 start with the _common struct.)

Let me send v5 and you can review that before I commit.

-- 
Kalle Valo
