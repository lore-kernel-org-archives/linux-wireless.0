Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:51226 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbaCLIrg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2014 04:47:36 -0400
Received: by mail-la0-f42.google.com with SMTP id ec20so6555581lab.29
        for <linux-wireless@vger.kernel.org>; Wed, 12 Mar 2014 01:47:35 -0700 (PDT)
Message-ID: <53201F25.30200@27m.se> (sfid-20140312_094743_308852_EDC5D4BF)
Date: Wed, 12 Mar 2014 09:47:33 +0100
From: Jones Desougi <jones.desougi@27m.se>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Kalle Valo <kvalo@qca.qualcomm.com>
CC: ath6kl@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/6] ath6kl: use braces on both arms of if statement
References: <20140309065606.10793.67068.stgit@x230>	 <20140309065717.10793.76274.stgit@x230> <1394401348.6972.50.camel@joe-AO722>
In-Reply-To: <1394401348.6972.50.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

That inverts the meaning of the condition though.


On 03/09/2014 10:42 PM, Joe Perches wrote:
...
> -	if (bss == NULL) {
...
> -	} else
> +	if (!bss) {

        if (bss) {

>  		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "cfg80211 already has a bss\n");
> +		return NULL;
> +	}
...

