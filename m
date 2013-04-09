Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:58677 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639Ab3DISD2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 14:03:28 -0400
Received: by mail-oa0-f50.google.com with SMTP id n1so7836177oag.9
        for <linux-wireless@vger.kernel.org>; Tue, 09 Apr 2013 11:03:28 -0700 (PDT)
Message-ID: <516457ED.2070406@lwfinger.net> (sfid-20130409_200332_691689_04E49D6D)
Date: Tue, 09 Apr 2013 13:03:25 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Vincent Brillault <gentoo@lerya.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: Warnings with ASUS PCE-N15 (RTL8188CE)
References: <513B7E58.9000505@lwfinger.net> <20130311183825.GG3009@Fea.lerya.net> <20130313080048.GB3484@Fea.lerya.net> <20130317141201.GA2557@Fea.lerya.net> <20130325182910.GA10274@Fea.lerya.net> <5150A15F.20600@lwfinger.net> <20130325195104.GA11212@Fea.lerya.net> <5150AE0F.2040306@lwfinger.net> <20130409094542.GA26503@Fea.lerya.net> <51643491.80302@lwfinger.net> <20130409160431.GA13599@Fea.lerya.net>
In-Reply-To: <20130409160431.GA13599@Fea.lerya.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/09/2013 11:04 AM, Vincent Brillault wrote:
> On Tue  9.Apr'13 at 10:32:33 -0500, Larry Finger wrote:
>> On 04/09/2013 04:47 AM, Vincent Brillault wrote:
>>> I still have the deconnection/reconnection issue. After looking on the
>>> reason, I think I have found a bug. Please look at the patched included
>>> in this mail: I think the rtlpriv->link_info.num_rx_inperiod is set to 0
>>> too early, as the '/* <4> roaming */' part uses it to see if the AP is
>>> still alive. What do you think ?
>>
>> Does that change help your issue?
> I cannot say for sure that it helped. I have now disactivated the
> powersave features of the driver and all my problems disappeared.
> The only thing I can say for sure is that my deconnections were detected
> by this part of the code, as the error message was
> "rtlwifi:rtl_watchdog_wq_callback():<0-0> AP off, try to reconnect now",
> and that this bugs seems to increase the probability to take the 'wrong'
> branch.
>
> Anyway, I think this line is missplaced: why would lines 1433-1434 use
> rtlpriv->link_info.num_rx_inperiod if its value is always 0 ?

As all of the disconnects disappeared in my system with the latest fixes that 
will be in kernel 3.10, I am reluctant to make any changes in the code *unless* 
you can prove that they fix a particular issue.

I agree that the code looks strange, but I did not write it.

In any case, it seems that power save is your problem.

Larry


