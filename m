Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33452 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752095AbdJPNHx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Oct 2017 09:07:53 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: Pkshih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        =?utf-8?B?6I6K5b2l5a6j?= <yhchuang@realtek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        "devel\@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "kernel-janitors\@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: Two rtlwifi drivers?
References: <20170824100832.lcmbwcjhzwlgozeh@mwanda>
        <87h8wxw4bq.fsf@kamboji.qca.qualcomm.com>
        <652d42ad-a077-530b-743f-d38ddf3ff677@lwfinger.net>
        <87k202qcjr.fsf@kamboji.qca.qualcomm.com>
        <20171011131310.GF32250@kroah.com>
        <87h8v4pxqp.fsf@kamboji.qca.qualcomm.com>
        <20171012103450.GA24647@kroah.com>
        <5B2DA6FDDF928F4E855344EE0A5C39D10581FF70@RTITMBSV07.realtek.com.tw>
        <ed361ae7-864e-1179-c7da-3ff10f4c73e2@rempel-privat.de>
Date: Mon, 16 Oct 2017 16:07:47 +0300
In-Reply-To: <ed361ae7-864e-1179-c7da-3ff10f4c73e2@rempel-privat.de> (Oleksij
        Rempel's message of "Mon, 16 Oct 2017 08:46:10 +0200")
Message-ID: <87fuajmeak.fsf@kamboji.qca.qualcomm.com> (sfid-20171016_150756_898029_2E776171)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oleksij Rempel <linux@rempel-privat.de> writes:

>> 4) As Kalle mentioned, rtlwifi contains many magic numbers, and I 
>>    plan to fix them after rtl8723de and rtl8821ce. Because the drivers
>>    are developing, the changes will make us hard to integrate. However,
>>    I don't have plan to process the magic numbers in the module phydm,
>>    because the most of BB/RF registers contain many functions. And
>>    it doesn't have a register name but a bit field name instead.
>>    Our BB team guys say the use of enumeration or defined name will
>>    be unreadable, and the name is meaningless for most people.
>
> Experience with ath9k driver showed, that development was kind of
> balanced between two groups, QCA and Community (Other companies,
> researches, education and so on.). Saying: "you will not understand it
> any way" is nor really helpful :)
> Please don't repeat bad experience of Broadcom.

I agree with Oleksij here, but I want to still point out that there are
cases when using magic numbers are ok, for example look at
ar5008_initvals.h from ath9k. So it depends on case by case.

-- 
Kalle Valo
