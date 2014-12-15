Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:38863 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878AbaLOXBm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2014 18:01:42 -0500
Received: by mail-lb0-f169.google.com with SMTP id p9so9957329lbv.14
        for <linux-wireless@vger.kernel.org>; Mon, 15 Dec 2014 15:01:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <wrfjbnn4vrqa.fsf@redhat.com>
References: <1418596754-24735-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20141215103117.GC4856@mwanda> <wrfjbnn4vrqa.fsf@redhat.com>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Tue, 16 Dec 2014 00:01:20 +0100
Message-ID: <CAFo99gZOr=1z8J_gNNRLXnKNBEiPCE_G3=ryaN5hAHvewHf0_w@mail.gmail.com> (sfid-20141216_000208_663951_E06466BE)
Subject: Re: [PATCH] staging: rtl8723au: os_dep: usb_intf.c: Fix for possible
 null pointer dereference
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	devel@driverdev.osuosl.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

No the rtw_hw_resume23a() is not used anywhere.
I also do a check of all functions that are not used, but not in the
drivers/staging, I suspected that these might be under development and
used in the future.

What do you want to do, who decides?


Kind regards
Rickard Strandqvist


2014-12-15 16:48 GMT+01:00 Jes Sorensen <Jes.Sorensen@redhat.com>:
> Dan Carpenter <dan.carpenter@oracle.com> writes:
>> On Sun, Dec 14, 2014 at 11:39:14PM +0100, Rickard Strandqvist wrote:
>>> There is otherwise a risk of a possible null pointer dereference.
>>>
>>> Was largely found by using a static code analysis program called cppcheck.
>>>
>>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>>> ---
>>>  drivers/staging/rtl8723au/os_dep/usb_intf.c |    3 ++-
>>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/staging/rtl8723au/os_dep/usb_intf.c
>>> b/drivers/staging/rtl8723au/os_dep/usb_intf.c
>>> index 865743e..71a6330 100644
>>> --- a/drivers/staging/rtl8723au/os_dep/usb_intf.c
>>> +++ b/drivers/staging/rtl8723au/os_dep/usb_intf.c
>>> @@ -351,10 +351,11 @@ error_exit:
>>>  int rtw_hw_resume23a(struct rtw_adapter *padapter)
>>
>> That's weird.  Is this function even called?
>
> [jes@ultrasam jes.git]$ find drivers/staging/rtl8723au -name \*.[ch] |xargs grep rtw_hw_resume
> drivers/staging/rtl8723au/include/osdep_intf.h:int rtw_hw_resume23a(struct rtw_adapter *padapter);
> drivers/staging/rtl8723au/os_dep/usb_intf.c:int rtw_hw_resume23a(struct rtw_adapter *padapter)
> drivers/staging/rtl8723au/os_dep/usb_intf.c:            DBG_8723A("==> rtw_hw_resume23a\n");
> [jes@ultrasam jes.git]$ find drivers/staging/rtl8723au -name \*.[ch] |xargs grep rtw_hw_suspend
> drivers/staging/rtl8723au/include/osdep_intf.h:int rtw_hw_suspend23a(struct rtw_adapter *padapter);
> drivers/staging/rtl8723au/os_dep/usb_intf.c:int rtw_hw_suspend23a(struct rtw_adapter *padapter)
> drivers/staging/rtl8723au/os_dep/usb_intf.c:            DBG_8723A("==> rtw_hw_suspend23a\n");
>
> A more useful patch would be one removing those two functions IMHO.
>
> Jes
