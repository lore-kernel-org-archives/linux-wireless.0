Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:33916 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbcFHPUm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2016 11:20:42 -0400
MIME-Version: 1.0
In-Reply-To: <87porrkaax.fsf@kamboji.qca.qualcomm.com>
References: <1465388474-20503-1-git-send-email-prasunmaiti87@gmail.com>
 <87wplzkbd9.fsf@kamboji.qca.qualcomm.com> <CAEO8o4=DnEfXQAnAOxugC9TngbhvgV9DXz0HOVHNLk0B2fAXQA@mail.gmail.com>
 <87porrkaax.fsf@kamboji.qca.qualcomm.com>
From: Prasun Maiti <prasunmaiti87@gmail.com>
Date: Wed, 8 Jun 2016 20:50:40 +0530
Message-ID: <CAEO8o4kD7MU09o+xOwPLn-PAgcuMExQ0MbNWgqv0fOs61rG8Xw@mail.gmail.com> (sfid-20160608_172048_815603_1B532A9D)
Subject: Re: [PATCH] Add .set_antenna callback in ath6kl driver to remove
 wireless core warns
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	"ath6kl@lists.infradead.org" <ath6kl@lists.infradead.org>,
	Linux Next <linux-next@vger.kernel.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am not sure it works fine. Like ath6kl driver send another cmd to
firmare, I have just filled up the cmd buffer with "tx_ant", and
"rx_ant" values, then use "ath6kl_wmi_cmd_send()" api to send the cmd
buffer to firmware.
I have resend the patch as there are some errors in the previous patch.
Let me know if any modifications are needed?


On Wed, Jun 8, 2016 at 8:16 PM, Valo, Kalle <kvalo@qca.qualcomm.com> wrote:
> Prasun Maiti <prasunmaiti87@gmail.com> writes:
>
>> No. I did not any test for that case.
>> This driver create a new wiphy for use with cfg80211 through
>> "wiphy_new_nm" api, but in this api, I found that more warnings for
>> inconsistent ops are added there. e.g; "WARN_ON(ops->set_antenna &&
>> !ops->get_antenna);"
>> So, warning comes during creation of a new wiphy. That's why It is needed.
>
> I'm confused. Are you really saying that you added a new firmware
> command (WMI_SET_ANTENNA_CMDID) to ath6kl but you didn't test it in any
> way? How do you know that it works then?
>
> --
> Kalle Valo



-- 
Thanks,
Prasun
