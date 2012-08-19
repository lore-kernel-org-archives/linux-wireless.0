Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f46.google.com ([209.85.212.46]:35845 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab2HSJgu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2012 05:36:50 -0400
MIME-Version: 1.0
In-Reply-To: <1345325159-7365-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1345325159-7365-1-git-send-email-Julia.Lawall@lip6.fr>
Date: Sun, 19 Aug 2012 13:36:49 +0400
Message-ID: <CA++WF2MmTe6WP6MQRV-v1VwkpcUrw4hU6yh79NdG-K4snzQkbg@mail.gmail.com> (sfid-20120819_113709_521063_41D617A4)
Subject: Re: [PATCH 1/5] drivers/net/wireless/ipw2x00/ipw2100.c: introduce
 missing initialization
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Julia,

On 19 August 2012 01:25, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> -       ipw2100_get_ordinal(priv, IPW_ORD_STAT_ASSN_AP_BSSID, &bssid, &len);
> +       ret = ipw2100_get_ordinal(priv, IPW_ORD_STAT_ASSN_AP_BSSID, &bssid,
> +                                 &len);

This is correct, but this line has one more typo. It should be

-&bssid
+bssid

according to the bssid definition in the beginning of the function:

u8 bssid[ETH_ALEN];

Could you fix this as well?

Thanks!
Stanislav.
