Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:64785 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211Ab0KRUP4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 15:15:56 -0500
Received: by gxk23 with SMTP id 23so2153358gxk.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 12:15:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1289604579.21000.5.camel@dcbw.foobar.com>
References: <20101031134012.F21FF9D401B@zog.reactivated.net>
	<1289604579.21000.5.camel@dcbw.foobar.com>
Date: Thu, 18 Nov 2010 20:15:55 +0000
Message-ID: <AANLkTinpvmS1ZH=T5BtA3+qyYLnNijxfjonFMaY8fO4F@mail.gmail.com>
Subject: Re: [PATCH] libertas: don't block usb8388 suspend if no wakeup
 conditions are set
From: Daniel Drake <dsd@laptop.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	akarwar@marvell.com, Dan Williams <dcbw@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John, just a quick ping on this maintainer-acked patch
Thanks :)

On 12 November 2010 23:29, Dan Williams <dcbw@redhat.com> wrote:
> On Sun, 2010-10-31 at 13:40 +0000, Daniel Drake wrote:
>> This hunk added by commit 66fceb69b72f seems erroneous. We don't want to
>> prevent suspend of the whole system if no wakeup params are set.
>>
>> In the case of the usb8388 we do want to keep the card powered up even
>> if there are no wakeup params. This is because it will continue acting
>> as a mesh node.
>>
>> If the mesh is disabled, it would indeed make more sense to power down
>> the card during suspend, as the equivalent hunk does for the SD interface.
>> But that's a separate task; for now just restore the previous behaviour.
>>
>> Signed-off-by: Daniel Drake <dsd@laptop.org>
>
> Acked-by: Dan Williams <dcbw@redhat.com>
>
>> ---
>>  drivers/net/wireless/libertas/if_usb.c |    6 ------
>>  1 files changed, 0 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
>> index efaf850..35931cf 100644
>> --- a/drivers/net/wireless/libertas/if_usb.c
>> +++ b/drivers/net/wireless/libertas/if_usb.c
>> @@ -1090,12 +1090,6 @@ static int if_usb_suspend(struct usb_interface *intf, pm_message_t message)
>>       if (priv->psstate != PS_STATE_FULL_POWER)
>>               return -1;
>>
>> -     if (priv->wol_criteria == EHS_REMOVE_WAKEUP) {
>> -             lbs_pr_info("Suspend attempt without "
>> -                                             "configuring wake params!\n");
>> -             return -ENOSYS;
>> -     }
>> -
>>       ret = lbs_suspend(priv);
>>       if (ret)
>>               goto out;
>
>
>
