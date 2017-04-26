Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f172.google.com ([209.85.128.172]:32914 "EHLO
        mail-wr0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965352AbdDZSq4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Apr 2017 14:46:56 -0400
Received: by mail-wr0-f172.google.com with SMTP id w50so5109970wrc.0
        for <linux-wireless@vger.kernel.org>; Wed, 26 Apr 2017 11:46:56 -0700 (PDT)
Subject: Re: [RFC] cfg80211: add control port state to struct
 cfg80211_connect_resp_params
To: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>
References: <1492808507-31224-1-git-send-email-arend.vanspriel@broadcom.com>
 <1493131210.2609.2.camel@sipsolutions.net>
 <b4dc7a6d-7865-1fb5-849a-0ead03a080c3@broadcom.com>
 <1493145418.2609.5.camel@sipsolutions.net>
 <af48efa4-3774-8d8b-ff45-760e558aa681@broadcom.com>
 <1493191249.2464.6.camel@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <c0b5817a-c4fa-8f7c-2632-cf22aa09d71b@broadcom.com> (sfid-20170426_204707_490942_E86C2263)
Date: Wed, 26 Apr 2017 20:46:53 +0200
MIME-Version: 1.0
In-Reply-To: <1493191249.2464.6.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26-4-2017 9:20, Johannes Berg wrote:
> On Tue, 2017-04-25 at 20:56 +0200, Arend Van Spriel wrote:
>>
>> You might, but not about this ;-) The other approach I had in mind is
>> to only pass the flag for drivers with 4-way-hs support. In that case
>> wpa_supp also has to check that to determine whether the flag should
>> be taken into account. Assuming the driver supporting 4-way-hs can
>> provide the port state info. Otherwise, a new ext_feature flag would
>> be needed.
> 
> I think it's reasonable to assume 4-way-HS offload drivers can support
> it.

I tested the 4-way-hs (both Personal and 802.1X) with boolean parameter
similar to what is proposed in the patch for roaming "cfg80211/nl80211:
add authorized flag to roaming event" and it works fine. So I can extend
it for use in connect result. Just had one issue regarding the type, ie.
flag vs. u8 because of how things are done in wpa_supplicant supporting
QCA roam+auth vendor-specific event.

Regards,
Arend
