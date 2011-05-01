Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55493 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab1EAH4F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 May 2011 03:56:05 -0400
Received: by wya21 with SMTP id 21so3624569wya.19
        for <linux-wireless@vger.kernel.org>; Sun, 01 May 2011 00:56:03 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 1 May 2011 00:56:03 -0700
Message-ID: <BANLkTikqoWm0gk4Bo1Wr7JP3c=x4YLxB2A@mail.gmail.com> (sfid-20110501_095611_775725_8072B160)
Subject: Re: (no subject)
From: Dan Carpenter <error27@gmail.com>
To: Naveen Singh <sningh@atheros.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/30/11, Naveen Singh <sningh@atheros.com> wrote:
> --- a/drivers/staging/ath6kl/os/linux/cfg80211.c
> +++ b/drivers/staging/ath6kl/os/linux/cfg80211.c
> @@ -1455,6 +1455,11 @@ ar6k_cfg80211_init(struct device *dev)
>      wdev->wiphy->cipher_suites = cipher_suites;
>      wdev->wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites);
>
> +    /*Support the seprate keys for unicast and multicast packets
> +     *This flag is needed because because nl80211 checks for this
> +     *flag before calling cfg ops for setting the key.*/
> +    wdev->wiphy->flags |= WIPHY_FLAG_SUPPORTS_SEPARATE_DEFAULT_KEYS;
> +

No subject.  Comment style wrong.  Please read CodingStyle and resend.

regards,
dan carpenter
