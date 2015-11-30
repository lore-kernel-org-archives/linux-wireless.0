Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56925 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbbK3K7F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Nov 2015 05:59:05 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [PATCH 08/11] brcmfmac: Make 5G join preference configurable.
References: <1448447567-12189-1-git-send-email-arend@broadcom.com>
	<1448447567-12189-9-git-send-email-arend@broadcom.com>
Date: Mon, 30 Nov 2015 12:58:58 +0200
In-Reply-To: <1448447567-12189-9-git-send-email-arend@broadcom.com> (Arend van
	Spriel's message of "Wed, 25 Nov 2015 11:32:44 +0100")
Message-ID: <87si3nkb2l.fsf@kamboji.qca.qualcomm.com> (sfid-20151130_115909_470187_13197EAF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend@broadcom.com> writes:

> From: Hante Meuleman <meuleman@broadcom.com>
>
> By default the 5G band has an advantage of 8 dBm on the RSSI when
> it comes to selection during join and roam. This patch adds a
> module param to make this value configurable. Using the value 99
> results in configuration that 5G has always preference over 2.4G.
>
> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

[...]

> +/* Module param joinboost_5g used for preferred join selection.
> + * Use value 99 to configure preferred join to choose 5G always over 2.4G, any
> + * other value configures the advantage of 5G signal strength over 2.4G signal
> + * strength.
> + */
> +static int brcmf_joinboost_5g_rssi = BRCMF_JOIN_PREF_RSSI_BOOST;
> +module_param_named(joinboost_5g, brcmf_joinboost_5g_rssi, int, 0);
> +MODULE_PARM_DESC(joinboost_5g, "Join preference 5G RSSI boost");

I'm not sure here, is a module parameter really the right way to
configure something like this?

-- 
Kalle Valo
