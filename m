Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:35189 "EHLO
        mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753759AbdERK3I (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 May 2017 06:29:08 -0400
Received: by mail-wm0-f46.google.com with SMTP id b84so196368615wmh.0
        for <linux-wireless@vger.kernel.org>; Thu, 18 May 2017 03:29:08 -0700 (PDT)
Subject: Re: [PATCH V2 0/9] nl80211: add support for PTK/GTK handshake offload
To: Johannes Berg <johannes@sipsolutions.net>
References: <1493808134-4074-1-git-send-email-arend.vanspriel@broadcom.com>
 <1495030794.2442.21.camel@sipsolutions.net>
 <1de42f39-1912-349b-e20d-4b5c3c44909f@broadcom.com>
 <1495099355.2553.1.camel@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        "hostap@lists.infradead.org" <hostap@lists.infradead.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <4e0672aa-51bc-115f-32b7-b1a8eb747e5b@broadcom.com> (sfid-20170518_122912_858528_27558AAB)
Date: Thu, 18 May 2017 12:29:04 +0200
MIME-Version: 1.0
In-Reply-To: <1495099355.2553.1.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 18-5-2017 11:22, Johannes Berg wrote:
> On Thu, 2017-05-18 at 10:18 +0200, Arend Van Spriel wrote:
>>
>>> We should therefore probably set the expectation that wpa_s - if
>>> it's new enough - always uses the offloaded functionality and
>>> always sets the WANT_1X. Then this is even better with such
>>> drivers, since they can immediately reject the connect() command if
>>> want_1x isn't set.

Getting back at this. With "always" you mean for every connect()
regardless whether it is using 1X or PSK?

>> Personally I am fine with this and it is how I tested it. So no
>> network configuration or driver parameter in wpa_s.conf (mainly
>> because I am lazy ;-) ). However, if the driver supports both offload
>> and non-offload why not leave it up to user-space. Might be useful if
>> people can try either way for example when debugging connection
>> issues.
> 
> If that should be possible though, then we'd probably want to have
> feature bit both ways, otherwise we'll probably get hard-to-debug
> failures at some point with this?

You mean adding a nl80211 command in which user-space can indicate what
features it supports? Do you want to use the same feature bits on both
sides to easily determine the combined feature set? ext_feature does not
really have much overlapping so not sure if it adds value.

Regards,
Arend
