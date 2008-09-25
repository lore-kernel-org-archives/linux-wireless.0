Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:30775 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbYIYVBH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2008 17:01:07 -0400
Received: by nf-out-0910.google.com with SMTP id d3so258028nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 25 Sep 2008 14:01:04 -0700 (PDT)
Message-ID: <48DBFBF9.10809@gmail.com> (sfid-20080925_230111_886517_8DF10592)
Date: Thu, 25 Sep 2008 22:00:41 +0100
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless: consolidate on a single escape_essid implementation
References: <> <1222294536-24367-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1222294536-24367-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> This is also an excuse to create the long rumored lib80211 module...

> +++ b/net/wireless/lib80211.c
> @@ -0,0 +1,58 @@
> +/*
> + * lib80211 -- common bits for IEEE802.11 drivers
> + *
> + * Copyright(c) 2008 John W. Linville <linville@tuxdriver.com>
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/wireless.h>

Alternatively #include <linux/ieee80211.h>, and avoid the WE header/constants? Or would you expect WE helpers in this file as well?

> +const char *escape_essid(const char *essid, u8 essid_len)
> +{
> +	static char escaped[IW_ESSID_MAX_SIZE * 2 + 1];
                           [IEEE80211_SSID_MAX_LEN * 2 + 1]

> +	const char *s = essid;
> +	char *d = escaped;
> +
> +	if (is_empty_essid(essid, essid_len)) {
> +		memcpy(escaped, "<hidden>", sizeof("<hidden>"));
> +		return escaped;
> +	}
> +
> +	essid_len = min(essid_len, (u8) IW_ESSID_MAX_SIZE);
                                        IEEE80211_SSID_MAX_LEN

Also, are we worried about drivers interrupting each other and getting the others SSID? In which case maybe something like print_mac:

/* in lib80211.h */
#define DECLARE_SSID_BUF(x) char x[IEEE80211_SSID_MAX_LEN * 2 + 1]

const char *print_ssid(char *escaped, const char *ssid, u8 ssid_len);



Regards,

Dave.
