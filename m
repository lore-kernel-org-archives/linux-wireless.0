Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:46644 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab2H0Ojo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Aug 2012 10:39:44 -0400
Received: by pbbrr13 with SMTP id rr13so7536881pbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Aug 2012 07:39:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1346063887-29078-1-git-send-email-yeohchunyeow@gmail.com>
References: <1346063887-29078-1-git-send-email-yeohchunyeow@gmail.com>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Mon, 27 Aug 2012 07:39:22 -0700
Message-ID: <CAG6hwVMQckH9KYp=OZorb2Q__91VrC-V5MNqE+zXsCTN4B5=dg@mail.gmail.com> (sfid-20120827_163948_112182_29ED34C8)
Subject: Re: [PATCH] cfg80211: allow software encryption of aes cmac in mesh
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Chun-Yeow,

On Mon, Aug 27, 2012 at 3:38 AM, Chun-Yeow Yeoh <yeohchunyeow@gmail.com> wrote:
> Secured mesh requires the key installation using cipher
> suite AES CMAC for multicast management frame. This patch
> will allow the key installation to proceed. Otherwise, it
> will be rejected due to hw encryption is not supported.

So what does this patch fix, exactly? mac80211 already advertises
support for AES CMAC if the hardware is MFP capable.

> -       if (!cfg80211_supported_cipher_suite(&rdev->wiphy, params->cipher))
> +       if (!cfg80211_supported_cipher_suite(&rdev->wiphy, params->cipher) &&
> +           !(params->cipher == WLAN_CIPHER_SUITE_AES_CMAC &&
> +             (rdev->wiphy.flags & WIPHY_FLAG_MESH_AUTH)))
>                 return -EINVAL;
