Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:35105 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754421AbeBGTfH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Feb 2018 14:35:07 -0500
Received: by mail-qk0-f193.google.com with SMTP id c4so324818qkm.2
        for <linux-wireless@vger.kernel.org>; Wed, 07 Feb 2018 11:35:07 -0800 (PST)
Subject: Re: [PATCH v2] ieee80211: Increase the PMK maximum length to 64 bytes
To: Srinivas Dasari <dasaris@codeaurora.org>, johannes@sipsolutions.net
References: <1518020451-8743-1-git-send-email-dasaris@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, jouni@codeaurora.org
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5A7B54E9.8070805@broadcom.com> (sfid-20180207_203517_509069_A58F62A1)
Date: Wed, 7 Feb 2018 20:35:05 +0100
MIME-Version: 1.0
In-Reply-To: <1518020451-8743-1-git-send-email-dasaris@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/7/2018 5:20 PM, Srinivas Dasari wrote:
> This is needed to cover the case of DPP with the NIST P-521 and
> brainpoolP512r1 curves which derive a PMK that is longer than the
> previously used limit.

So how are driver supposed to deal with this longer PMK. Maybe if you 
could elaborate on what DPP stands for in this context it would become 
more clear. Can we stick with PMK_MAX_LEN or does it need to be more 
fine-grained per use-case? If existing drivers only support 48 bytes PMK 
and trust nl80211 code to check that limit it may screw them up. Not? If 
this is preparation for subsequent patches I would put it all in one 
patch series.

Regards,
Arend

> Signed-off-by: Srinivas Dasari <dasaris@codeaurora.org>
> ---
>   include/linux/ieee80211.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
