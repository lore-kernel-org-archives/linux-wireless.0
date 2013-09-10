Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:54830 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019Ab3IJQXY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 12:23:24 -0400
Received: by mail-ie0-f171.google.com with SMTP id 16so5420922iea.2
        for <linux-wireless@vger.kernel.org>; Tue, 10 Sep 2013 09:23:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87ppshu5mr.fsf@purkki.adurom.net>
References: <CAFSJ42bTQkQO+yugN7BBjygQd7LY9H0bPBoPfoH7yyfyMzuGqA@mail.gmail.com>
	<87ppshu5mr.fsf@purkki.adurom.net>
Date: Tue, 10 Sep 2013 18:23:23 +0200
Message-ID: <CAFSJ42b_jOJA7ABK7GqDi0KO-Nnv-8CvhMC6ysTicPhe00kS=w@mail.gmail.com> (sfid-20130910_182337_195265_1AB642E9)
Subject: Re: regulatory will stuck when cfg80211 is built-in
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No, the flag CONFIG_CFG80211_INTERNAL_REGDB  does not help and it should not.

The problem is that cfg80211 will stuck in situation when cfg80211 is
initialized before user space. One way to get cfg80211 out of this
state is to run crda once right after user space is up and running.
But again is this intentional? Or it is more like a workaround?

2013/9/9 Kalle Valo <kvalo@adurom.com>:
> Eugene Krasnikov <k.eugene.e@gmail.com> writes:
>
>> There is a problem with regulatory part of cfg80211 when cfg80211 is
>> built-in the kernel. On regulatory init cfg80211 will try to notify
>> user space about changing current domain to world regulatory but at
>> that time user space is not up and running yet and uevent message will
>> be lost. So what will happen is that cfg80211 will wait for the
>> response from user space and all requests to set current regulatory
>> will be dropped with the following error: “Pending regulatory request,
>> waiting for it to be processed...”.
>
> Does CONFIG_CFG80211_INTERNAL_REGDB help?
>
> --
> Kalle Valo



-- 
Best regards,
Eugene
