Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:36043 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1423469AbdKRAWr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Nov 2017 19:22:47 -0500
Received: by mail-wr0-f171.google.com with SMTP id y42so3475194wrd.3
        for <linux-wireless@vger.kernel.org>; Fri, 17 Nov 2017 16:22:46 -0800 (PST)
Subject: Re: rtl8723be on Fedora27
To: Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org
References: <f5876284-360c-e6bf-01c8-ed95c4298647@gmail.com>
 <3a1fc541-9104-2d13-409f-c8e64845a86d@lwfinger.net>
From: =?UTF-8?Q?R=c3=a1kosi_Gergely?= <rakosi.gergely@gmail.com>
Message-ID: <c6662534-db2f-61dc-142e-8015984c6813@gmail.com> (sfid-20171118_012255_765789_950256F6)
Date: Sat, 18 Nov 2017 01:22:43 +0100
MIME-Version: 1.0
In-Reply-To: <3a1fc541-9104-2d13-409f-c8e64845a86d@lwfinger.net>
Content-Type: text/plain; charset=iso-8859-2
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Larry,

First of all, thanks your help.
Lets see...here is the kernel version: 4.13.12-300
The machine is an Asus ROG 553VE

The firmware which loading in the dmesg is : rtlwifi/rtl8723befw_36.bin
The output of md5sum is : 1850c1308fbcd95e9f6a7f58ede1e35f

Thanks again,
Best Regards,
Gergely


2017-11-17 16:51 keltezéssel, Larry Finger írta:
> On 11/17/2017 02:16 AM, Rákosi Gergely wrote:
>> Hello,
>>
>> I'm trying to use rtl8723be wifi on Fedora27 but I still get continuosly
>> disconnection. The error in the dmesg is "Init MAC failed"
>> I tried with the following module options too : "fwlps=0 swlps=0" and
>> the variant of "ant_sel=1 or 2 or 0"
>> I downloaded the git files from your repo, and do the usual make,make
>> install, and modprobe stuffs, and then restart the notebook, but I get
>> the same result.
>
> I know from the E-mail you sent to me privately that you are new to
> this process, thus I am going to give you some pointers. It is
> important for you to give your kernel version. Yes, for devoted Fedora
> users, saying that you are using F27 might be sufficient; however, I
> am not one of them. You should always supply the output of the command
> 'uname -r'.
>
> On the RTL8723BE, "Init MAC failed" is not the dmesg that is expected
> from either the HP ant_sel problem, or a power-save problem.
> Incidentally, although there are many "fixes" that require modifying
> the XXps options, the underlying cause of that issue was fixed almost
> one year ago.
>
> The main software component that might be wrong is the firmware.
> Please find the name of the firmware file that is being loaded from
> the dmesg output. It will be rtlwifi/... Once you locate that name,
> run the command
>
> md5sum /lib/firmware/rtlwifi/xxx
>
> Substitute the actual name for the xxx. Post the output of the md5sum.
>
> Larry
