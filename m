Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35518 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034492AbcIWSKa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Sep 2016 14:10:30 -0400
Received: by mail-oi0-f68.google.com with SMTP id n202so9330769oig.2
        for <linux-wireless@vger.kernel.org>; Fri, 23 Sep 2016 11:10:30 -0700 (PDT)
Subject: Re: rtl8192ce:rtl92ce_get_hw_reg():<0-0> switch case not processed
To: Jean Delvare <jdelvare@suse.de>
References: <20160922115116.149c599c@endymion>
 <83974845-037d-0cde-00b1-ec7b28eeb15f@lwfinger.net>
 <20160923141618.1fcfd809@endymion>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
        linux-wireless@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <6feb0feb-eb53-8b6b-4c50-e6ace0cc854a@lwfinger.net> (sfid-20160923_201035_442269_55C7F0A2)
Date: Fri, 23 Sep 2016 13:10:28 -0500
MIME-Version: 1.0
In-Reply-To: <20160923141618.1fcfd809@endymion>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/23/2016 07:16 AM, Jean Delvare wrote:
> Hi Larry,
>
> On Thu, 22 Sep 2016 10:09:58 -0500, Larry Finger wrote:
>> Do you build your own kernel, or are you using openSUSE's supplied version? If
>> the latter, I will need to think how we might debug the issue. If the former,
>> please add the attached patch.
>
> Lost network this morning, but no error message. We restarted the
> network service, things were back up and the error message was logged
> then:
>
> rtl8192ce:rtl92ce_get_hw_reg():<0-0> switch case 92 not processed
>
> So I think this is happening when the interface is put down, and is
> probably not related with the loss of connectivity. But it would be
> good to understand and fix it nevertheless.
>
> 92 is HAL_DEF_WOWLAN. I see it is handled differently in 2 other
> rtlwifi drivers: rtl8192cu ignores it, while rtl8821ae processes it:
>
> 	case HAL_DEF_WOWLAN:
> 		if (ppsc->wo_wlan_mode)
> 			*((bool *)(val)) = true;
> 		else
> 			*((bool *)(val)) = false;
> 		break;
>
> I don't know what is the appropriate course of action in the case of
> the rtl8192ce. Let me know if you need anything else from me.

As the RTL8192CE does not support WOWLAN, the correct response is to ignore that 
call. Clearly, it has nothing to do with your network drops. One thing you might 
do is add the appropriate file in /etc/modprobe.d/ so that the module is loaded 
with the "ips=0" option to see if power save is messing up.

I am in the process of fixing all the instances where the log entry for the 
default case does not output the switch variable. With these patches, I will 
also handle the HAL_DEF_WOWLAN case.

I'm sorry about my original comments regarding patching the kernel. I sent that 
E-mail before I even read your name and address. As a long-time openSUSE user, I 
certainly recognize your name and your abilities.

Larry
