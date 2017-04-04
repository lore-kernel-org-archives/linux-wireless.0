Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:33965 "EHLO
        mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753243AbdDDSbV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Apr 2017 14:31:21 -0400
Received: by mail-oi0-f54.google.com with SMTP id d2so40475438oig.1
        for <linux-wireless@vger.kernel.org>; Tue, 04 Apr 2017 11:31:21 -0700 (PDT)
Subject: Re: [PATCH] staging: Add rtl8723bs sdio wifi driver
To: Hans de Goede <hdegoede@redhat.com>
References: <20170329174751.13184-1-hdegoede@redhat.com>
Cc: Bastien Nocera <hadess@hadess.net>,
        Jes Sorensen <jes.sorensen@gmail.com>,
        linux-wireless@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <4d1d3c02-eff6-0410-cee0-9360ec645e13@lwfinger.net> (sfid-20170404_203125_477077_2E313055)
Date: Tue, 4 Apr 2017 13:31:19 -0500
MIME-Version: 1.0
In-Reply-To: <20170329174751.13184-1-hdegoede@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/29/2017 12:47 PM, Hans de Goede wrote:
> The rtl8723bs is found on quite a few systems used by Linux users,
> such as on Atom systems (Intel Computestick and various other
> Atom based devices) and on many (budget) ARM boards such as
> the CHIP.
>
> The plan moving forward with this is for the new clean,
> written from scratch, rtl8xxxu driver to eventually gain
> support for sdio devices. But there is no clear timeline
> for that, so lets add this driver included in staging for now.

Hans,

I started looking at the Smatch errors. This one may be the result of a serious 
problem:

   CHECK   drivers/staging/rtl8723bs/core/rtw_debug.c
drivers/staging/rtl8723bs/core/rtw_debug.c:454 proc_get_survey_info() error: we 
previously assumed 'phead' could be null (see line 453)
drivers/staging/rtl8723bs/core/rtw_debug.c:455 proc_get_survey_info() warn: 
variable dereferenced before check 'phead' (see line 454)

A snippet of the code in question is as follows:

         spin_lock_bh(&(pmlmepriv->scanned_queue.lock));
         phead = get_list_head(queue);
         plist = phead ? get_next(phead) : NULL;
         plist = get_next(phead);
         if ((!phead) || (!plist)) {
                 spin_unlock_bh(&(pmlmepriv->scanned_queue.lock));
                 return 0;
         }

This code comes directly from the hadess repo, but I am suspicious of the double 
call to get_next(phead). I cannot imagine any valid reason to skip every other 
entry on that list.

Larry
