Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42274 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab0L2JRM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Dec 2010 04:17:12 -0500
Subject: Re: [PATCH 4/4] mwl8k: Enable HW encryption for AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org, mwl8k-devel@cozybit.com,
	buytenh@wantstofly.org, Nishant Sarmukadam <nishants@marvell.com>,
	Pradeep Nemavat <pnemavat@marvell.com>
In-Reply-To: <1293577297-25755-5-git-send-email-thomas@cozybit.com>
References: <1293577297-25755-1-git-send-email-thomas@cozybit.com>
	 <1293577297-25755-5-git-send-email-thomas@cozybit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Dec 2010 10:17:10 +0100
Message-ID: <1293614230.3546.4.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-12-28 at 15:01 -0800, Thomas Pedersen wrote:

> @@ -824,15 +827,22 @@ static void mwl8k_encapsulate_tx_frame(struct sk_buff *skb)
>  	header_pad = 0;
>  	data_pad = 0;
>  	if (key_conf != NULL) {
> -		if (key_conf->alg == ALG_WEP) {
> +		switch (key_conf->cipher) {

how can this patch possibly apply? key_conf->alg hasn't existed in a
LONG time, so I don't see how you can be removing a line containing it?!

johannes

