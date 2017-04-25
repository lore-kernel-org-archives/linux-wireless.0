Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:33649 "EHLO
        mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1950274AbdDYSeq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 14:34:46 -0400
Received: by mail-qk0-f171.google.com with SMTP id h123so67227931qke.0
        for <linux-wireless@vger.kernel.org>; Tue, 25 Apr 2017 11:34:40 -0700 (PDT)
Subject: Re: [RFC] cfg80211: add control port state to struct
 cfg80211_connect_resp_params
To: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>
References: <1492808507-31224-1-git-send-email-arend.vanspriel@broadcom.com>
 <1493131210.2609.2.camel@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <b4dc7a6d-7865-1fb5-849a-0ead03a080c3@broadcom.com> (sfid-20170425_203621_213812_8E7C1405)
Date: Tue, 25 Apr 2017 20:34:31 +0200
MIME-Version: 1.0
In-Reply-To: <1493131210.2609.2.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25-4-2017 16:40, Johannes Berg wrote:
> On Fri, 2017-04-21 at 22:01 +0100, Arend van Spriel wrote:
> 
>> I have been working on 4-way handshake offloading and one of the
>> things discussed was the addition of PORT_AUTHORIZED flag. So
>> this is what I came up with, but I suppose wpa_supplicant wants
>> to know whether it can expect this attribute or not. One option
>> is to have PORT_UNAUTHORIZED flag instead. Another option would
>> be introducing it as nl80211 protocol feature although not sure
>> if it could be considered as such. What do you guys think?
> 
> I think it could be, but I'm not really sure it matters?
> 
>> +	    (cr->port_state != CONTROL_PORT_STATE_UNAUTHORIZED &&
>> +	     nla_put_flag(msg, NL80211_ATTR_PORT_AUTHORIZED)) ||
>>  	    (cr->req_ie &&
>>
> This doesn't really make sense - why does unspecified equal authorized?

I was considering default behavior here for drivers that do not provide
this information, ie. drivers not supporting 4-way handshake offload. So
wpa_supplicant just looks for the PORT_AUTHORIZED attribute and deals
with it without need for checking 4-way handshake offload is supported.

Regards,
Arend
