Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:35223 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758096Ab3CESGf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Mar 2013 13:06:35 -0500
Message-ID: <1362506794.1759.2.camel@joe-AO722> (sfid-20130305_190638_389983_57EB5C9B)
Subject: Re: [PATCH] ath6kl: print firmware capabilities
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Tue, 05 Mar 2013 10:06:34 -0800
In-Reply-To: <20130305163842.32118.84598.stgit@localhost6.localdomain6>
References: <20130305163842.32118.84598.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-03-05 at 18:38 +0200, Kalle Valo wrote:
> Printin the  firmware capabilities during the first firmware boot makes it easier to find out what
> features firmware supports.
[]
> diff --git a/drivers/net/wireless/ath/ath6kl/init.c b/drivers/net/wireless/ath/ath6kl/init.c
[]
> +static void ath6kl_init_fw_capas(struct ath6kl *ar, char *buf, size_t buf_len)
> +{
[]
> +		if (buf_len - len < 4) {
> +			ath6kl_warn("firmware capability buffer too small!\n");
> +			strncpy(buf, "<error>", buf_len);

4 is an odd size to use.
It seems weird to overwrite the known bits.
why not just add ...?



