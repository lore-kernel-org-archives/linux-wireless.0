Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34472 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751329AbeDFJRY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Apr 2018 05:17:24 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH v12] ath10k: add LED and GPIO controlling support for various chipsets
References: <20180226084406.2093-1-s.gottschall@dd-wrt.com>
        <871sftemru.fsf@kamboji.qca.qualcomm.com>
        <c4a1313a-73d2-a028-4fca-09f6fb6e56bd@dd-wrt.com>
        <de9c007f-26e3-a511-e944-91e90aac7787@dd-wrt.com>
        <1d917688-9f59-39ad-46a6-527d9e3dec03@dd-wrt.com>
        <87d0zcsqmv.fsf@codeaurora.org>
        <41fa794e-d5d5-004e-5403-1e14c77a567a@dd-wrt.com>
        <87sh88rbba.fsf@codeaurora.org>
        <f3617290-34d5-0cca-6442-4a37c06701b1@dd-wrt.com>
Date: Fri, 06 Apr 2018 12:17:17 +0300
In-Reply-To: <f3617290-34d5-0cca-6442-4a37c06701b1@dd-wrt.com> (Sebastian
        Gottschall's message of "Fri, 6 Apr 2018 10:27:26 +0200")
Message-ID: <87sh88d78i.fsf@kamboji.qca.qualcomm.com> (sfid-20180406_111728_810903_97D67F10)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(adding back lists)

Sebastian Gottschall <s.gottschall@dd-wrt.com> writes:

> Am 06.04.2018 um 10:25 schrieb Kalle Valo:
>> Sebastian Gottschall <s.gottschall@dd-wrt.com> writes:
>>
>>> Am 06.04.2018 um 10:09 schrieb Kalle Valo:
>>>> (adding back the lists, please don't top post and trim your quotes)
>>>>
>>>> Sebastian Gottschall <s.gottschall@dd-wrt.com> writes:
>>>>
>>>>> okay. ath10k-check is buggy and doesnt work. so it doesnt help much
>>>>> with code styles
>>>>>
>>>>> root@seg-desktop:/xfs/ath10k/ath.gpio# ./ath10k-check
>>>>> global: 'drivers/net/wireless/ath/ath10k/Kconfig' is not a source fil=
e.
>>>>> Traceback (most recent call last):
>>>>>   =C2=A0 File "./ath10k-check", line 461, in <module>
>>>>>   =C2=A0=C2=A0=C2=A0 main()
>>>>>   =C2=A0 File "./ath10k-check", line 455, in main
>>>>>   =C2=A0=C2=A0=C2=A0 ret =3D run_checkpatch(args)
>>>>>   =C2=A0 File "./ath10k-check", line 275, in run_checkpatch
>>>>>   =C2=A0=C2=A0=C2=A0 output =3D subprocess.check_output(cmd, shell=3D=
True)
>>>>>   =C2=A0 File "/usr/lib/python2.7/subprocess.py", line 219, in check_=
output
>>>>>   =C2=A0=C2=A0=C2=A0 raise CalledProcessError(retcode, cmd, output=3D=
output)
>>>>> subprocess.CalledProcessError: Command 'global -f
>>>>> drivers/net/wireless/ath/ath10k/Kconfig' returned non-zero exit statu=
s 1
>>>> You are missing gtags, see 'ath10k-check --help' for how to install:
>>>>
>>>> Requirements (all available in $PATH):
>>>>
>>>> * gcc
>>>> * sparse
>>>> * checkpatch.pl
>>>> * gtags (from package global)
>>> ahm i did read this and this was all installed. but ath10k-check
>>> refuses to work
>>>
>>> root@seg-desktop:/home/seg/DEV# gtags --version
>>> gtags (GNU GLOBAL) 6.5.7
>>> Copyright (c) 1996-2017 Tama Communications Corporation
>>> License GPLv3+: GNU GPL version 3 or later
>>> <http://www.gnu.org/licenses/gpl.html>
>>> This is free software; you are free to change and redistribute it.
>>> There is NO WARRANTY, to the extent permitted by law.
>> Damn, I guess something has changed in gtags as I use older version:
>>
>> gtags - GNU GLOBAL 5.7.1
>
> okay. i will try to use a older version and see what happens

You can also run checkpatch manually (sorry for the long line):

checkpatch.pl --strict -q --terse --no-summary --max-line-length=3D90 --sho=
w-types --ignore MSLEEP,USLEEP_RANGE,PRINTK_WITHOUT_KERN_LEVEL,NETWORKING_B=
LOCK_COMMENT_STYLE,LINUX_VERSION_CODE,COMPLEX_MACRO,PREFER_DEV_LEVEL,PREFER=
_PR_LEVEL,COMPARISON_TO_NULL,BIT_MACRO,CONSTANT_COMPARISON,MACRO_WITH_FLOW_=
CONTROL,CONST_STRUCT,MACRO_ARG_REUSE,MACRO_ARG_PRECEDENCE foo.patch

I modified ath10k-check --help to print the full commandline, just
haven't pushed it out yet.

--=20
Kalle Valo
