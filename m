Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f49.google.com ([209.85.213.49]:33903 "EHLO
        mail-vk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932233AbdBVMYd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Feb 2017 07:24:33 -0500
Received: by mail-vk0-f49.google.com with SMTP id r136so528465vke.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Feb 2017 04:24:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <3fa1e3ac-5722-c46d-acc1-62407f4eef07@broadcom.com>
References: <20170221100957.30965-1-johannes@sipsolutions.net>
 <231f969e-eac1-3196-07c2-80e37e6dda55@broadcom.com> <1487673603.2215.3.camel@sipsolutions.net>
 <c38019e8-32b5-5fa2-1da7-8022cbb62b13@broadcom.com> <1487680651.2215.5.camel@sipsolutions.net>
 <3fa1e3ac-5722-c46d-acc1-62407f4eef07@broadcom.com>
From: Jithu Jance <jithu.jance@broadcom.com>
Date: Wed, 22 Feb 2017 17:54:31 +0530
Message-ID: <CA+gyVQ11yZjkJXjiVoMVijs=_K8itZMQrces9XQha_bT4=H-DA@mail.gmail.com> (sfid-20170222_132438_056382_9C66BE75)
Subject: Re: [PATCH] cfg80211: support 4-way handshake offloading for WPA/WPA2-PSK
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, Eliad Peller <eliad@wizery.com>,
        Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jouni, Johannes et al.,

On Wed, Feb 22, 2017 at 1:27 AM, Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 21-2-2017 13:37, Johannes Berg wrote:
>>
>>> What I am also missing is how to deal with NL80211_CMD_CONNECTED
>>> event signalling. Should that be given after (un)successful
>>> completion of the 4-way handshake or should we have a separate event
>>> for that?
>>
>> That's a good point. I don't think a new event really works well, but
>> perhaps we should extend the NL80211_TIMEOUT_* values with this? It's
>> not strictly a timeout, I guess, but it's not a direct rejection of the
>> association either.
>>
>> Any thoughts?
>
> I discussed about the event mechanism with Jithu which is who asked me
> to look at their patches for this feature. His suggestion was to have a
> "port authorized" event after successful handshake as it will help in
> key mgmt offload cases. He gave the following example: Suppose you are
> doing a fresh 8021x followed by 4way handshake offload. Right now there
> is no event to indicate to the upper layer that the 4way handshake have
> been completed successfully. So the only thing to do in wpa_supplicant
> is to consider it completed and if not be hit with deauth.

In wpa_supplicant terms, I was looking for an event notification to move the
wpa_state from WPA_ASSOCIATED to WPA_COMPLETED.  :)

Thanks,

-- 

Jithu Jance
