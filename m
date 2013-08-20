Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:51783 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751484Ab3HTSMO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Aug 2013 14:12:14 -0400
Message-ID: <1377022333.2016.59.camel@joe-AO722> (sfid-20130820_201218_224679_41373CAF)
Subject: Re: [PATCH 09/16] wcn36xx: Add smd.c
From: Joe Perches <joe@perches.com>
To: Eugene Krasnikov <k.eugene.e@gmail.com>
Cc: linux-wireless@vger.kernel.org, wcn36xx@lists.infradead.org
Date: Tue, 20 Aug 2013 11:12:13 -0700
In-Reply-To: <1377020479-16935-10-git-send-email-k.eugene.e@gmail.com>
References: <1377020479-16935-1-git-send-email-k.eugene.e@gmail.com>
	 <1377020479-16935-10-git-send-email-k.eugene.e@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-08-20 at 19:41 +0200, Eugene Krasnikov wrote:

> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
[]
> +int wcn36xx_smd_load_nv(struct wcn36xx *wcn)
> +{
[]
> +		/* Add NV body itself */
> +		/* Rework me */
> +		memcpy(wcn->smd_buf + sizeof(msg_body),
> +		       (void *)(&nv_d->table) + fm_offset,
> +		       msg_body.nv_img_buffer_size);

Does this really do what you want?

Perhaps it should be:

		memcpy(wcn->smd_buf + sizeof(msg_body),
		       ((void *)&nv_d->table) + fm_offset,
		       msg_body.nv_img_buffer_size);



