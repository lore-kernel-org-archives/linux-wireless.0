Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48889 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753587Ab1GCBYF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jul 2011 21:24:05 -0400
Received: by iyb12 with SMTP id 12so3681882iyb.19
        for <linux-wireless@vger.kernel.org>; Sat, 02 Jul 2011 18:24:04 -0700 (PDT)
Message-ID: <4E0FC4B1.7080909@lwfinger.net> (sfid-20110703_032417_132257_EC5B11C1)
Date: Sat, 02 Jul 2011 20:24:01 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: ali@internetdog.org
CC: linux-wireless@vger.kernel.org
Subject: Re: r8712u driver for the rtl8192su chip.
References: <BANLkTikxS_2wJEpijmYQy3nPy2-9pykxdA@mail.gmail.com> <4DC06BF3.6070208@lwfinger.net> <20110621124954.GA8462@internetdog.org> <4E011644.3070906@lwfinger.net> <20110622010057.GA12123@internetdog.org> <4E0154B7.2000204@lwfinger.net> <20110622025623.GC12547@internetdog.org> <4E015CE8.3000304@lwfinger.net> <20110627072351.GA4251@internetdog.org> <4E0F50B4.3080805@lwfinger.net> <20110703010605.GA3736@internetdog.org>
In-Reply-To: <20110703010605.GA3736@internetdog.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/02/2011 08:06 PM, Ali Bahar wrote:
> Hi Larry,
>
> On Sat, Jul 02, 2011 at 12:09:08PM -0500, Larry Finger wrote:
>> On 06/27/2011 02:23 AM, Ali Bahar wrote:
>
>>> The cause is that the driver's handler for the Set expects that the
>>> interface is Up. In my case, it was not, and so it returns a -1. This
>>> pops back up the call-chain until it gets misinterpreted as an EPERM.
>
>> The attached patch has been floating around for a while. Does it help?
>
> Of course, it will, but the general problem with the -1 return-values
> (and any other Up assumptions) will remain.
>
> As I'd indicated earlier, I have no interest in, or use for, this
> device. I dug into it because there seemed to be a need within this
> ML (and I was already looking for an 802.11 project anyway.)
>
> If that is the case, I can implement the changes, merge recent Realtek
> changes, and determine how much nl80211 interface is needed.
> On the other hand, if changes are on-hold, then I'll focus elsewhere.
>
> regards,
> ali
>
>
>> Index: linux-2.6/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
>> ===================================================================
>> --- linux-2.6.orig/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
>> +++ linux-2.6/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
>> @@ -990,8 +990,6 @@ static int r8711_wx_set_wap(struct net_d
>>   	struct wlan_network *pnetwork = NULL;
>>   	enum NDIS_802_11_AUTHENTICATION_MODE	authmode;
>>
>> -	if (padapter->bup == false)
>> -		return -1;
>>   	if (check_fwstate(pmlmepriv, _FW_UNDER_SURVEY) == true)
>>   		return -1;
>>   	if (check_fwstate(pmlmepriv, _FW_UNDER_LINKING) == true)
>> @@ -1182,8 +1180,6 @@ static int r8711_wx_set_essid(struct net
>>   	struct list_head *phead;
>>   	u32 len;
>>
>> -	if (padapter->bup == false)
>> -		return -1;
>>   	if (check_fwstate(pmlmepriv, _FW_UNDER_SURVEY))
>>   		return -1;
>>   	if (check_fwstate(pmlmepriv, _FW_UNDER_LINKING))

If you want to work on it, I will review and test the patches. It will be a long 
time until I get to it.

Larry
