Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:58691 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135Ab3IMOMD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Sep 2013 10:12:03 -0400
Received: by mail-ie0-f180.google.com with SMTP id u16so2543002iet.39
        for <linux-wireless@vger.kernel.org>; Fri, 13 Sep 2013 07:12:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87d2ogtv57.fsf@purkki.adurom.net>
References: <CAFSJ42bTQkQO+yugN7BBjygQd7LY9H0bPBoPfoH7yyfyMzuGqA@mail.gmail.com>
	<87ppshu5mr.fsf@purkki.adurom.net>
	<CAFSJ42b_jOJA7ABK7GqDi0KO-Nnv-8CvhMC6ysTicPhe00kS=w@mail.gmail.com>
	<87d2ogtv57.fsf@purkki.adurom.net>
Date: Fri, 13 Sep 2013 16:12:02 +0200
Message-ID: <CAFSJ42Z6Y4vG6LzB6=1L60beMx8Do+iq6RQW_U=z+kXSv0HooA@mail.gmail.com> (sfid-20130913_161208_601595_90B0A664)
Subject: Re: regulatory will stuck when cfg80211 is built-in
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Let me try to describe the problem in more details:

1) When user space is calling "iw reg set <contry_code>" iw utility
will send NL80211_CMD_REQ_SET_REG through nl80211 to cfg80211.
2) cfg80211 will process this call in reg_todo work that is defined
here https://git.kernel.org/cgit/linux/kernel/git/linville/wireless.git/tree/net/wireless/reg.c#n1621
3) reg_todo work is calling reg_process_pending_hints to process the
call from user space where it checks if last request was
processed(https://git.kernel.org/cgit/linux/kernel/git/linville/wireless.git/tree/net/wireless/reg.c#n1576).
But last request is still there! This last request is
"NL80211_REGDOM_SET_BY_CORE" request that cfg80211 sent on init for
first regulatory domain initialization.
So the problem is that the first request that is sent by inbuilt
cfg80211 will be never process and will always stay in last_request
variable(https://git.kernel.org/cgit/linux/kernel/git/linville/wireless.git/tree/net/wireless/reg.c#n91)

Kalle, did you ever tried inbuilt into kernel cfg80211? This problem
is 100% reproducible because inbuilt modules will be always initialize
before user space.


2013/9/10 Kalle Valo <kvalo@adurom.com>:
> Eugene Krasnikov <k.eugene.e@gmail.com> writes:
>
>> No, the flag CONFIG_CFG80211_INTERNAL_REGDB  does not help and it should not.
>>
>> The problem is that cfg80211 will stuck in situation when cfg80211 is
>> initialized before user space. One way to get cfg80211 out of this
>> state is to run crda once right after user space is up and running.
>> But again is this intentional? Or it is more like a workaround?
>
> With the internal regdb you do not need crda anymore, so why does it still
> get stuck? Where does it exactly get stuck?
>
> --
> Kalle Valo



-- 
Best regards,
Eugene
