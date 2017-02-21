Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:32835 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753714AbdBUT50 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 14:57:26 -0500
Received: by mail-wm0-f44.google.com with SMTP id t18so31282652wmt.0
        for <linux-wireless@vger.kernel.org>; Tue, 21 Feb 2017 11:57:25 -0800 (PST)
Subject: Re: [PATCH] cfg80211: support 4-way handshake offloading for
 WPA/WPA2-PSK
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20170221100957.30965-1-johannes@sipsolutions.net>
 <231f969e-eac1-3196-07c2-80e37e6dda55@broadcom.com>
 <1487673603.2215.3.camel@sipsolutions.net>
 <c38019e8-32b5-5fa2-1da7-8022cbb62b13@broadcom.com>
 <1487680651.2215.5.camel@sipsolutions.net>
Cc: Eliad Peller <eliad@wizery.com>, Jouni Malinen <j@w1.fi>,
        Jithu Jance <jithu.jance@broadcom.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <3fa1e3ac-5722-c46d-acc1-62407f4eef07@broadcom.com> (sfid-20170221_205730_427316_E4D0C4AA)
Date: Tue, 21 Feb 2017 20:57:22 +0100
MIME-Version: 1.0
In-Reply-To: <1487680651.2215.5.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21-2-2017 13:37, Johannes Berg wrote:
> 
>> What I am also missing is how to deal with NL80211_CMD_CONNECTED
>> event signalling. Should that be given after (un)successful
>> completion of the 4-way handshake or should we have a separate event
>> for that? 
> 
> That's a good point. I don't think a new event really works well, but
> perhaps we should extend the NL80211_TIMEOUT_* values with this? It's
> not strictly a timeout, I guess, but it's not a direct rejection of the
> association either.
> 
> Any thoughts?

I discussed about the event mechanism with Jithu which is who asked me
to look at their patches for this feature. His suggestion was to have a
"port authorized" event after successful handshake as it will help in
key mgmt offload cases. He gave the following example: Suppose you are
doing a fresh 8021x followed by 4way handshake offload. Right now there
is no event to indicate to the upper layer that the 4way handshake have
been completed successfully. So the only thing to do in wpa_supplicant
is to consider it completed and if not be hit with deauth.

Regards,
Arend
