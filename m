Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:35920 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751150AbdFCIIk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Jun 2017 04:08:40 -0400
Received: by mail-wm0-f41.google.com with SMTP id 7so40155035wmo.1
        for <linux-wireless@vger.kernel.org>; Sat, 03 Jun 2017 01:08:40 -0700 (PDT)
Subject: Re: [PATCH V2 0/9] nl80211: add support for PTK/GTK handshake offload
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        "hostap@lists.infradead.org" <hostap@lists.infradead.org>
References: <1493808134-4074-1-git-send-email-arend.vanspriel@broadcom.com>
 <1495030794.2442.21.camel@sipsolutions.net>
 <1de42f39-1912-349b-e20d-4b5c3c44909f@broadcom.com>
 <1495099355.2553.1.camel@sipsolutions.net>
 <4e0672aa-51bc-115f-32b7-b1a8eb747e5b@broadcom.com>
 <1495104012.2553.3.camel@sipsolutions.net>
 <adcf52eb-cc8f-82de-3820-3f96a0d1f8d3@broadcom.com>
 <1495189263.3274.4.camel@sipsolutions.net>
 <c3c14002-c9c5-490a-2e8f-826d601d0d84@broadcom.com>
 <1495448886.2653.12.camel@sipsolutions.net>
 <29d43b7d-6cb6-0734-6a52-31fa98e9c1bc@broadcom.com>
 <1496050303.2467.3.camel@sipsolutions.net>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <d41f58e9-b12e-9e52-a0fb-b674d278353b@broadcom.com> (sfid-20170603_100844_609947_E0C81620)
Date: Sat, 3 Jun 2017 10:08:38 +0200
MIME-Version: 1.0
In-Reply-To: <1496050303.2467.3.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29-05-17 11:31, Johannes Berg wrote:
> So if something supports the following:
> 
>  * client: offloaded 4-way-HS only
>  * AP: not offloaded 4-way-HS only
> 
> Then you have to support NEW_KEY (AP case) and then using NEW_KEY to
> detect whether or not a wpa_s configuration option to not use offloaded
> 4-way-HS can be used will not work correctly.
> 
> I don't really see that this is a sensible configuration, but I could
> imagine it existing if somebody "bolted on" AP functionality for a
> client-side chipset or something like that.

Hi Johannes,

So I want to get back to this as to assure we have the same
understanding. First off, the proposed offloads are STA-only. So if a
driver supports STA and AP mode and the 4-way-HS offload, we could
already have the case you describe here. So not really a "bolted on"
scenario I would say. It does raise the question whether or not we want
similar offloads for AP.

Regards,
Arend
