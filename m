Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:55676 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752802AbeDEUAw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Apr 2018 16:00:52 -0400
Subject: Re: [PATCH v12] ath10k: add LED and GPIO controlling support for
 various chipsets
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Sebastian Gottschall <s.gottschall@newmedia-net.de>,
        ath10k@lists.infradead.org
References: <20180226084406.2093-1-s.gottschall@dd-wrt.com>
 <871sftemru.fsf@kamboji.qca.qualcomm.com>
 <c4a1313a-73d2-a028-4fca-09f6fb6e56bd@dd-wrt.com>
Message-ID: <de9c007f-26e3-a511-e944-91e90aac7787@dd-wrt.com> (sfid-20180405_220102_974695_E141E73B)
Date: Thu, 5 Apr 2018 22:00:43 +0200
MIME-Version: 1.0
In-Reply-To: <c4a1313a-73d2-a028-4fca-09f6fb6e56bd@dd-wrt.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

i have some comments about your check warnings.
some of them are bogus. for instance they advise to use "unsigned int" 
instead of "unsigned". this might be better, but
the original kernel header uses "unsigned" as api definition. so i 
decided to use the same declarations here.
for the rest like whitespaces i will make a new version and remove them

Am 05.04.2018 um 20:01 schrieb Sebastian Gottschall:
> Am 05.04.2018 um 16:44 schrieb Kalle Valo:
>> s.gottschall@dd-wrt.com writes:
>>
>>> Adds LED and GPIO Control support for 988x, 9887, 9888, 99x0, 9984
>>> based chipsets with on chipset connected led's using WMI Firmware API.
>>> The LED device will get available named as "ath10k-phyX" at sysfs and
>>> can be controlled with various triggers. adds also debugfs interface
>>> for gpio control.
>>>
>>> Signed-off-by: Sebastian Gottschall <s.gottschall@dd-wrt.com>
>> [...]
>>
>>> @@ -1034,7 +1068,7 @@ ath10k_wmi_pdev_get_temperature(struct ath10k 
>>> *ar)
>>>       if (IS_ERR(skb))
>>>           return PTR_ERR(skb);
>>>   -    return ath10k_wmi_cmd_send(ar, skb,
>>> +    return ath10k_wmi_cmd_send_nowait(ar, skb,
>>> ar->wmi.cmd->pdev_get_temperature_cmdid);
>>>   }
>> This looks odd, I don't think it belongs to this patch.
> thats true. but due the nature of this function i found it better to 
> use nowait here. better if i split it up?
>>
>> Also you made a some sort of record, your patch had 181 checkpatch
>> warnings! Do you use Word as your editor or what? But please do check
>> your editor settings and read the coding style documents.
> no? i use midnight commander for all of my code since more than 20 years
> and its the first time that i see such warnings. is there any special 
> coding rule for ath10k which differs from the kernel rules?
> and where is ath10k-check located?
>>
>> https://wireless.wiki.kernel.org/en/users/drivers/ath10k/codingstyle
>>
>> I'll send v13.
>>
>> Here are the warnings from ath10k-check:
>>
>> drivers/net/wireless/ath/ath10k/gpio.c:19: Please don't use multiple 
>> blank lines
>> drivers/net/wireless/ath/ath10k/gpio.c:30: Please don't use multiple 
>> blank lines
>> drivers/net/wireless/ath/ath10k/gpio.c:36: Prefer 'unsigned int' to 
>> bare use of 'unsigned'
>> drivers/net/wireless/ath/ath10k/gpio.c:38: line over 90 characters
>> drivers/net/wireless/ath/ath10k/gpio.c:39: line over 90 characters
>> drivers/net/wireless/ath/ath10k/gpio.c:39: Missing a blank line after 
>> declarations
>> drivers/net/wireless/ath/ath10k/gpio.c:45: Prefer 'unsigned int' to 
>> bare use of 'unsigned'
>> drivers/net/wireless/ath/ath10k/gpio.c:46: Alignment should match 
>> open parenthesis
>> drivers/net/wireless/ath/ath10k/gpio.c:48: line over 90 characters
>> drivers/net/wireless/ath/ath10k/gpio.c:50: line over 90 characters
>> drivers/net/wireless/ath/ath10k/gpio.c:58: Prefer 'unsigned int' to 
>> bare use of 'unsigned'
>> drivers/net/wireless/ath/ath10k/gpio.c:60: line over 90 characters
>> drivers/net/wireless/ath/ath10k/gpio.c:66: Prefer 'unsigned int' to 
>> bare use of 'unsigned'
>> drivers/net/wireless/ath/ath10k/gpio.c:68: line over 90 characters
>> drivers/net/wireless/ath/ath10k/gpio.c:74: Prefer 'unsigned int' to 
>> bare use of 'unsigned'
>> drivers/net/wireless/ath/ath10k/gpio.c:75: Alignment should match 
>> open parenthesis
>> drivers/net/wireless/ath/ath10k/gpio.c:77: line over 90 characters
>> drivers/net/wireless/ath/ath10k/gpio.c:86: trailing whitespace
>> drivers/net/wireless/ath/ath10k/gpio.c:86: please, no spaces at the 
>> start of a line
>> drivers/net/wireless/ath/ath10k/gpio.c:86: Blank lines aren't 
>> necessary after an open brace '{'
>> drivers/net/wireless/ath/ath10k/gpio.c:88: Missing a blank line after 
>> declarations
>> drivers/net/wireless/ath/ath10k/gpio.c:88: braces {} are not 
>> necessary for single statement blocks
>> drivers/net/wireless/ath/ath10k/gpio.c:113: trailing whitespace
>> drivers/net/wireless/ath/ath10k/gpio.c:114: Missing a blank line 
>> after declarations
>> drivers/net/wireless/ath/ath10k/gpio.c:114: braces {} are not 
>> necessary for single statement blocks
>> drivers/net/wireless/ath/ath10k/gpio.c:121: line over 90 characters
>> drivers/net/wireless/ath/ath10k/gpio.c:130: Please don't use multiple 
>> blank lines
>> drivers/net/wireless/ath/ath10k/gpio.c:132: Alignment should match 
>> open parenthesis
>> drivers/net/wireless/ath/ath10k/gpio.c:134: line over 90 characters
>> drivers/net/wireless/ath/ath10k/gpio.c:136: Missing a blank line 
>> after declarations
>> drivers/net/wireless/ath/ath10k/gpio.c:145: trailing whitespace
>> drivers/net/wireless/ath/ath10k/gpio.c:146: Missing a blank line 
>> after declarations
>> drivers/net/wireless/ath/ath10k/gpio.c:159: trailing whitespace
>> drivers/net/wireless/ath/ath10k/gpio.c:160: Missing a blank line 
>> after declarations
>> drivers/net/wireless/ath/ath10k/gpio.c:166: trailing whitespace
>> drivers/net/wireless/ath/ath10k/gpio.c:169: trailing whitespace
>> drivers/net/wireless/ath/ath10k/gpio.c:170: line over 90 characters
>> drivers/net/wireless/ath/ath10k/gpio.c:178: Missing a blank line 
>> after declarations
>> drivers/net/wireless/ath/ath10k/gpio.c:181: Prefer 
>> kzalloc(sizeof(*gpio)...) over kzalloc(sizeof(struct 
>> ath10k_gpiocontrol)...)
>> drivers/net/wireless/ath/ath10k/gpio.c:182: braces {} are not 
>> necessary for single statement blocks
>> drivers/net/wireless/ath/ath10k/gpio.c:192: trailing whitespace
>> drivers/net/wireless/ath/ath10k/gpio.c:194: line over 90 characters
>> drivers/net/wireless/ath/ath10k/gpio.c:196: trailing whitespace
>> drivers/net/wireless/ath/ath10k/core.h:865: trailing whitespace
>> drivers/net/wireless/ath/ath10k/core.h:865: line over 90 characters
>> drivers/net/wireless/ath/ath10k/core.h:871: trailing whitespace
>> drivers/net/wireless/ath/ath10k/core.h:890: Blank lines aren't 
>> necessary after an open brace '{'
>> drivers/net/wireless/ath/ath10k/core.h:891: Blank lines aren't 
>> necessary before a close brace '}'
>> drivers/net/wireless/ath/ath10k/core.h:892: Please use a blank line 
>> after function/struct/union/enum declarations
>> drivers/net/wireless/ath/ath10k/core.h:894: Blank lines aren't 
>> necessary after an open brace '{'
>> drivers/net/wireless/ath/ath10k/core.h:895: Blank lines aren't 
>> necessary before a close brace '}'
>> drivers/net/wireless/ath/ath10k/core.h:896: Please use a blank line 
>> after function/struct/union/enum declarations
>> drivers/net/wireless/ath/ath10k/core.h:905: trailing whitespace
>> drivers/net/wireless/ath/ath10k/core.h:907: Blank lines aren't 
>> necessary after an open brace '{'
>> drivers/net/wireless/ath/ath10k/core.h:908: Blank lines aren't 
>> necessary before a close brace '}'
>> drivers/net/wireless/ath/ath10k/core.c:29: Please don't use multiple 
>> blank lines
>> drivers/net/wireless/ath/ath10k/core.c:74: trailing whitespace
>> drivers/net/wireless/ath/ath10k/core.c:105: trailing whitespace
>> drivers/net/wireless/ath/ath10k/core.c:136: trailing whitespace
>> drivers/net/wireless/ath/ath10k/core.c:282: trailing whitespace
>> drivers/net/wireless/ath/ath10k/core.c:318: trailing whitespace
>> drivers/net/wireless/ath/ath10k/core.c:359: trailing whitespace
>> drivers/net/wireless/ath/ath10k/core.c:2396: trailing whitespace
>> drivers/net/wireless/ath/ath10k/core.c:2396: Please don't use 
>> multiple blank lines
>> drivers/net/wireless/ath/ath10k/core.c:2403: trailing whitespace
>> drivers/net/wireless/ath/ath10k/debug.c:1089: Alignment should match 
>> open parenthesis
>> drivers/net/wireless/ath/ath10k/debug.c:1092: trailing whitespace
>> drivers/net/wireless/ath/ath10k/debug.c:1095: Missing a blank line 
>> after declarations
>> drivers/net/wireless/ath/ath10k/debug.c:1098: line over 90 characters
>> drivers/net/wireless/ath/ath10k/debug.c:1103: Please don't use 
>> multiple blank lines
>> drivers/net/wireless/ath/ath10k/debug.c:1105: Alignment should match 
>> open parenthesis
>> drivers/net/wireless/ath/ath10k/debug.c:1109: trailing whitespace
>> drivers/net/wireless/ath/ath10k/debug.c:1113: Missing a blank line 
>> after declarations
>> drivers/net/wireless/ath/ath10k/debug.c:1130: Please don't use 
>> multiple blank lines
>> drivers/net/wireless/ath/ath10k/debug.c:1133: Please don't use 
>> multiple blank lines
>> drivers/net/wireless/ath/ath10k/debug.c:1149: Alignment should match 
>> open parenthesis
>> drivers/net/wireless/ath/ath10k/debug.c:1152: trailing whitespace
>> drivers/net/wireless/ath/ath10k/debug.c:1155: Missing a blank line 
>> after declarations
>> drivers/net/wireless/ath/ath10k/debug.c:1163: Please don't use 
>> multiple blank lines
>> drivers/net/wireless/ath/ath10k/debug.c:1165: Alignment should match 
>> open parenthesis
>> drivers/net/wireless/ath/ath10k/debug.c:1169: trailing whitespace
>> drivers/net/wireless/ath/ath10k/debug.c:1173: Missing a blank line 
>> after declarations
>> drivers/net/wireless/ath/ath10k/debug.c:1188: Please don't use 
>> multiple blank lines
>> drivers/net/wireless/ath/ath10k/debug.c:1191: Please don't use 
>> multiple blank lines
>> drivers/net/wireless/ath/ath10k/debug.c:1375: Please don't use 
>> multiple blank lines
>> drivers/net/wireless/ath/ath10k/wmi-ops.h:211: Please don't use 
>> multiple blank lines
>> drivers/net/wireless/ath/ath10k/wmi-ops.h:986: trailing whitespace
>> drivers/net/wireless/ath/ath10k/wmi-ops.h:986: Please use a blank 
>> line after function/struct/union/enum declarations
>> drivers/net/wireless/ath/ath10k/wmi-ops.h:987: line over 90 characters
>> drivers/net/wireless/ath/ath10k/wmi-ops.h:1001: trailing whitespace
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3340: line over 90 characters
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3342: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3343: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3344: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3345: trailing whitespace
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3345: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3346: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3348: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3349: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3350: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3353: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3354: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3355: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3356: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3358: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3359: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3360: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3361: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3362: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3364: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3365: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3367: line over 90 characters
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3367: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3368: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3374: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3375: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3376: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3377: trailing whitespace
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3377: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3378: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3380: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3381: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3382: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3385: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3386: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3387: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3388: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3390: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3391: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3392: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3394: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3395: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3397: line over 90 characters
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3397: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3398: please, no spaces at 
>> the start of a line
>> drivers/net/wireless/ath/ath10k/wmi-tlv.c:3401: Please don't use 
>> multiple blank lines
>> drivers/net/wireless/ath/ath10k/mac.c:4622: trailing whitespace
>> drivers/net/wireless/ath/ath10k/mac.c:4623: line over 90 characters
>> drivers/net/wireless/ath/ath10k/mac.c:4625: trailing whitespace
>> drivers/net/wireless/ath/ath10k/mac.c:4626: trailing whitespace
>> drivers/net/wireless/ath/ath10k/wmi.h:2934: please, no spaces at the 
>> start of a line
>> drivers/net/wireless/ath/ath10k/wmi.h:2935: please, no spaces at the 
>> start of a line
>> drivers/net/wireless/ath/ath10k/wmi.h:2936: please, no spaces at the 
>> start of a line
>> drivers/net/wireless/ath/ath10k/wmi.h:2940: please, no spaces at the 
>> start of a line
>> drivers/net/wireless/ath/ath10k/wmi.h:2941: please, no spaces at the 
>> start of a line
>> drivers/net/wireless/ath/ath10k/wmi.h:2942: please, no spaces at the 
>> start of a line
>> drivers/net/wireless/ath/ath10k/wmi.h:2943: please, no spaces at the 
>> start of a line
>> drivers/net/wireless/ath/ath10k/wmi.h:2944: please, no spaces at the 
>> start of a line
>> drivers/net/wireless/ath/ath10k/wmi.h:2945: please, no spaces at the 
>> start of a line
>> drivers/net/wireless/ath/ath10k/wmi.h:2950: please, no spaces at the 
>> start of a line
>> drivers/net/wireless/ath/ath10k/wmi.h:2951: please, no spaces at the 
>> start of a line
>> drivers/net/wireless/ath/ath10k/wmi.h:2952: please, no spaces at the 
>> start of a line
>> drivers/net/wireless/ath/ath10k/wmi.h:2953: please, no spaces at the 
>> start of a line
>> drivers/net/wireless/ath/ath10k/wmi.h:2958: please, no spaces at the 
>> start of a line
>> drivers/net/wireless/ath/ath10k/wmi.h:2959: please, no spaces at the 
>> start of a line
>> drivers/net/wireless/ath/ath10k/wmi.h:2964: please, no spaces at the 
>> start of a line
>> drivers/net/wireless/ath/ath10k/wmi.h:2967: Please don't use multiple 
>> blank lines
>> drivers/net/wireless/ath/ath10k/wmi.c:6957: line over 90 characters
>> drivers/net/wireless/ath/ath10k/wmi.c:6959: please, no spaces at the 
>> start of a line
>> drivers/net/wireless/ath/ath10k/wmi.c:6960: please, no spaces at the 
>> start of a line
>> drivers/net/wireless/ath/ath10k/wmi.c:6962: please, no spaces at the 
>> start of a line
>> drivers/net/wireless/ath/ath10k/wmi.c:6963: please, no spaces at the 
>> start of a line
>> drivers/net/wireless/ath/ath10k/wmi.c:6965: please, no spaces at the 
>> start of a line
>> drivers/net/wireless/ath/ath10k/wmi.c:6966: please, no spaces at the 
>> start of a line
>> drivers/net/wireless/ath/ath10k/wmi.c:6967: please, no spaces at the 
>> start of a line
>> drivers/net/wireless/ath/ath10k/wmi.c:6968: please, no spaces at the 
>> start of a line
>> drivers/net/wireless/ath/ath10k/wmi.c:6969: please, no spaces at the 
>> start of a line
>> drivers/net/wireless/ath/ath10k/wmi.c:6971: line over 90 characters
>> drivers/net/wireless/ath/ath10k/wmi.c:6971: please, no spaces at the 
>> start of a line
>> drivers/net/wireless/ath/ath10k/wmi.c:6972: please, no spaces at the 
>> start of a line
>> drivers/net/wireless/ath/ath10k/wmi.c:6978: please, no spaces at the 
>> start of a line
>> drivers/net/wireless/ath/ath10k/wmi.c:6979: please, no spaces at the 
>> start of a line
>> drivers/net/wireless/ath/ath10k/wmi.c:6981: please, no spaces at the 
>> start of a line
>> drivers/net/wireless/ath/ath10k/wmi.c:6982: please, no spaces at the 
>> start of a line
>> drivers/net/wireless/ath/ath10k/wmi.c:6984: please, no spaces at the 
>> start of a line
>> drivers/net/wireless/ath/ath10k/wmi.c:6985: please, no spaces at the 
>> start of a line
>> drivers/net/wireless/ath/ath10k/wmi.c:6986: please, no spaces at the 
>> start of a line
>> drivers/net/wireless/ath/ath10k/wmi.c:6987: line over 90 characters
>> drivers/net/wireless/ath/ath10k/wmi.c:6987: please, no spaces at the 
>> start of a line
>> drivers/net/wireless/ath/ath10k/wmi.c:6988: please, no spaces at the 
>> start of a line
>> drivers/net/wireless/ath/ath10k/wmi.c:8583: trailing whitespace
>>
>

-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
