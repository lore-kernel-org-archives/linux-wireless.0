Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:34074 "EHLO
        mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750944AbdBWLFG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Feb 2017 06:05:06 -0500
Received: by mail-vk0-f41.google.com with SMTP id r136so17752148vke.1
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2017 03:04:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1248c04b-a643-9254-383c-707ab68c0815@broadcom.com>
References: <20170221100957.30965-1-johannes@sipsolutions.net>
 <231f969e-eac1-3196-07c2-80e37e6dda55@broadcom.com> <1487673603.2215.3.camel@sipsolutions.net>
 <c38019e8-32b5-5fa2-1da7-8022cbb62b13@broadcom.com> <1487680651.2215.5.camel@sipsolutions.net>
 <3fa1e3ac-5722-c46d-acc1-62407f4eef07@broadcom.com> <CA+gyVQ11yZjkJXjiVoMVijs=_K8itZMQrces9XQha_bT4=H-DA@mail.gmail.com>
 <9b6de09f-d872-fd67-971a-6da369fefe1a@broadcom.com> <1248c04b-a643-9254-383c-707ab68c0815@broadcom.com>
From: Jithu Jance <jithu.jance@broadcom.com>
Date: Thu, 23 Feb 2017 16:26:31 +0530
Message-ID: <CA+gyVQ24qDqpOBKPjVaZ_BFAJa9kLMjA=nD8FF8V7HvxUkWb=w@mail.gmail.com> (sfid-20170223_120509_812051_CF6A8B21)
Subject: Re: [PATCH] cfg80211: support 4-way handshake offloading for WPA/WPA2-PSK
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
        Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 23, 2017 at 4:10 PM, Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:
>
> Ehm. Looking at the code in wpa_supplicant_event_assoc() it would be
> better to use NL80211_CMD_EAPOL_PORT_VALID event to cover both
> WPA/WPA2-PSK and 8021X.
Yes. IMHO, the assoc/reassoc ind should move the state to WPA_ASSOCIATED
and a separate event like NL80211_CMD_EAPOL_PORT_VALID/AUTHORIZED should
move the connection state to WPA_COMPLETED.


Thanks,
-- 

Jithu Jance
