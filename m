Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f173.google.com ([209.85.161.173]:33363 "EHLO
        mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751507AbdASNGV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Jan 2017 08:06:21 -0500
Received: by mail-yw0-f173.google.com with SMTP id l75so31889823ywb.0
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jan 2017 05:05:30 -0800 (PST)
Subject: Re: [PATCH] nl80211: fix validation of scheduled scan info for wowlan
 netdetect
To: Luca Coelho <luca@coelho.fi>,
        Johannes Berg <johannes@sipsolutions.net>
References: <1484820088-24448-1-git-send-email-arend.vanspriel@broadcom.com>
 <1484827206.2774.12.camel@coelho.fi>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <bde55d09-6f3e-1f90-4aef-0e1169c11cf6@broadcom.com> (sfid-20170119_140624_769549_F97FC8DD)
Date: Thu, 19 Jan 2017 14:08:44 +0100
MIME-Version: 1.0
In-Reply-To: <1484827206.2774.12.camel@coelho.fi>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 19-1-2017 13:00, Luca Coelho wrote:
> On Thu, 2017-01-19 at 10:01 +0000, Arend van Spriel wrote:
>> For wowlan netdetect a separate limit is defined for the number of
>> matchsets. Currently, this limit is ignored and the regular limit
>> for scheduled scan matchsets, ie. struct wiphy::max_match_sets, is
>> used for the net-detect case as well.
>>
>> Cc: Luciano Coelho <luciano.coelho@intel.com>
>> Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>> ---
> 
> What?! You don't have the same number of matchsets for both? :P

Actually I have, but your comment mentioned they do not have to be the
same. brcmfmac actually did not set max_nd_match_sets so I was surprised
it worked. That said this patch will result in regression in brcmfmac
:-p Not sure about other drivers supporting net-detect.

Regards,
Arend

> Looks good.
> 
> Reviewed-by: Luca Coelho <luciano.coelho@intel.com>
> 
> --
> Luca.
> 
