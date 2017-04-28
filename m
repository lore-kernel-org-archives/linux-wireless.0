Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f177.google.com ([209.85.216.177]:35190 "EHLO
        mail-qt0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030460AbdD1Mqm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Apr 2017 08:46:42 -0400
Received: by mail-qt0-f177.google.com with SMTP id y33so48881557qta.2
        for <linux-wireless@vger.kernel.org>; Fri, 28 Apr 2017 05:46:42 -0700 (PDT)
Subject: Re: [RFC] cfg80211: add control port state to struct
 cfg80211_connect_resp_params
To: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>
References: <1492808507-31224-1-git-send-email-arend.vanspriel@broadcom.com>
 <1493131210.2609.2.camel@sipsolutions.net>
 <b4dc7a6d-7865-1fb5-849a-0ead03a080c3@broadcom.com>
 <1493145418.2609.5.camel@sipsolutions.net>
 <af48efa4-3774-8d8b-ff45-760e558aa681@broadcom.com>
 <1493191249.2464.6.camel@sipsolutions.net>
 <c0b5817a-c4fa-8f7c-2632-cf22aa09d71b@broadcom.com>
 <1493380923.2431.13.camel@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <49ec312c-6a2f-1bfe-820e-c14f1fa4baba@broadcom.com> (sfid-20170428_144706_940260_951BE5E6)
Date: Fri, 28 Apr 2017 14:46:37 +0200
MIME-Version: 1.0
In-Reply-To: <1493380923.2431.13.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 28-4-2017 14:02, Johannes Berg wrote:
> 
>> I tested the 4-way-hs (both Personal and 802.1X) with boolean
>> parameter similar to what is proposed in the patch for roaming
>> "cfg80211/nl80211: add authorized flag to roaming event" and it works
>> fine. So I can extend it for use in connect result. Just had one
>> issue regarding the type, ie. flag vs. u8 because of how things are
>> done in wpa_supplicant supporting QCA roam+auth vendor-specific
>> event.
> 
> Ok.
> 
> We have lots of related but somewhat conflicting things in flight right
> now, and we need somebody to go collect them all into a consistent
> patchset, preferably even with the 4-way-HS offload [1] thrown in. That
> needs rebasing anyway because it introduces the _PMK attribute that
> Jouni already added for FILS now.

I already have the 4-way-hs stuff rebased with modified ATTR_PMK
description and additional length check in nl80211 for it. Jouni
commented on that already in 4-way-hs patch.

> Do you want to pick that up? I probably can't do it soon - I'm likely
> busy with other things the next week or two, then travel again, ...

That is my plan.

Regards,
Arend
