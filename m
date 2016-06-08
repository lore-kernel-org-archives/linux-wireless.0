Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:33238 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161912AbcFHOfQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2016 10:35:16 -0400
MIME-Version: 1.0
In-Reply-To: <87wplzkbd9.fsf@kamboji.qca.qualcomm.com>
References: <1465388474-20503-1-git-send-email-prasunmaiti87@gmail.com> <87wplzkbd9.fsf@kamboji.qca.qualcomm.com>
From: Prasun Maiti <prasunmaiti87@gmail.com>
Date: Wed, 8 Jun 2016 20:05:15 +0530
Message-ID: <CAEO8o4=DnEfXQAnAOxugC9TngbhvgV9DXz0HOVHNLk0B2fAXQA@mail.gmail.com> (sfid-20160608_163535_306196_16E29F8B)
Subject: Re: [PATCH] Add .set_antenna callback in ath6kl driver to remove
 wireless core warns
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
	"ath6kl@lists.infradead.org" <ath6kl@lists.infradead.org>,
	Linux Next <linux-next@vger.kernel.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Linux Kernel <prasunmaii87@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No. I did not any test for that case.
This driver create a new wiphy for use with cfg80211 through
"wiphy_new_nm" api, but in this api, I found that more warnings for
inconsistent ops are added there. e.g; "WARN_ON(ops->set_antenna &&
!ops->get_antenna);"
So, warning comes during creation of a new wiphy. That's why It is needed.

On Wed, Jun 8, 2016 at 7:53 PM, Valo, Kalle <kvalo@qca.qualcomm.com> wrote:
> Prasun Maiti <prasunmaiti87@gmail.com> writes:
>
>> Since add more warnings for inconsistent ops in cfg80211, the wireless
>> core warns if a driver implements a cfg80211 callback but doesn't
>> implements the inverse operation. The ath6kl driver implements a cfg80211
>> .get_antenna operation handler but doesn't have the inverse .set_antenna
>> callback. So, it makes warning.
>>
>> To remove this warning, add .set_antenna callback in ath6kl driver and
>> also send a cmd to firmware with it's values.
>>
>> Signed-off-by: Prasun Maiti <prasunmaiti87@gmail.com>
>
> Did you test this? What hardware and firmware version?
>
> --
> Kalle Valo



-- 
Thanks,
Prasun
