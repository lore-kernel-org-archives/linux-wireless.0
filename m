Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:35203 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1951920AbdDYS4H (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 14:56:07 -0400
Received: by mail-wm0-f47.google.com with SMTP id w64so30995998wma.0
        for <linux-wireless@vger.kernel.org>; Tue, 25 Apr 2017 11:56:07 -0700 (PDT)
Subject: Re: [RFC] cfg80211: add control port state to struct
 cfg80211_connect_resp_params
To: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>
References: <1492808507-31224-1-git-send-email-arend.vanspriel@broadcom.com>
 <1493131210.2609.2.camel@sipsolutions.net>
 <b4dc7a6d-7865-1fb5-849a-0ead03a080c3@broadcom.com>
 <1493145418.2609.5.camel@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <af48efa4-3774-8d8b-ff45-760e558aa681@broadcom.com> (sfid-20170425_205704_455520_6098118A)
Date: Tue, 25 Apr 2017 20:56:04 +0200
MIME-Version: 1.0
In-Reply-To: <1493145418.2609.5.camel@sipsolutions.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25-4-2017 20:36, Johannes Berg wrote:
> On Tue, 2017-04-25 at 20:34 +0200, Arend Van Spriel wrote:
> 
>>>> +	    (cr->port_state != CONTROL_PORT_STATE_UNAUTHORIZED
>>>> &&
>>>> +	     nla_put_flag(msg, NL80211_ATTR_PORT_AUTHORIZED)) ||
>>>>  	    (cr->req_ie &&
>>>>
>>>
>>> This doesn't really make sense - why does unspecified equal
>>> authorized?
>>
>> I was considering default behavior here for drivers that do not
>> provide this information, ie. drivers not supporting 4-way handshake
>> offload. So wpa_supplicant just looks for the PORT_AUTHORIZED
>> attribute and deals with it without need for checking 4-way handshake
>> offload is supported.
> 
> There are two such cases - the driver is old and doesn't provide it,
> but of course once you see the attribute you know that's not the case.
> And the case that the driver doesn't support 4-way-HS.
> 
> Can you really distinguish these though if you *don't* see the
> attribute?
> 
> But anyway, if it's like mac80211 not providing the data at all, then
> it would say authorized, which seems wrong since that's clearly not the
> case for mac80211?
> 
> Or maybe I'm just confused.

You might, but not about this ;-) The other approach I had in mind is to
only pass the flag for drivers with 4-way-hs support. In that case
wpa_supp also has to check that to determine whether the flag should be
taken into account. Assuming the driver supporting 4-way-hs can provide
the port state info. Otherwise, a new ext_feature flag would be needed.

Regards,
Arend
