Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42525 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757916Ab3FLSzg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jun 2013 14:55:36 -0400
Message-ID: <51B8C41E.7050907@candelatech.com> (sfid-20130612_205541_242190_6456A845)
Date: Wed, 12 Jun 2013 11:55:26 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@adurom.com>
CC: Bing Zhao <bzhao@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Paul Stewart <pstew@chromium.org>
Subject: Re: [PATCH] mwifiex: Add module parameter for regdomain
References: <1370904007-10959-1-git-send-email-bzhao@marvell.com> <877ghz3il6.fsf@purkki.adurom.net> <477F20668A386D41ADCC57781B1F70430EA268B457@SC-VEXCH1.marvell.com> <8738sn2mcf.fsf@purkki.adurom.net>
In-Reply-To: <8738sn2mcf.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/12/2013 11:52 AM, Kalle Valo wrote:
> Bing Zhao <bzhao@marvell.com> writes:
>
>> Hi Kalle,
>>
>>>> From: Avinash Patil <patila@marvell.com>
>>>>
>>>> Allow a regulatory domain country code to be specified at boot
>>>> using a module argument.  This overrides the firmware regulatory
>>>> mode.
>>>>
>>>> This patch also enables uAP to operate in 11a mode with hostapd.
>>>>
>>>> Signed-off-by: Avinash Patil <patila@marvell.com>
>>>> Signed-off-by: Paul Stewart <pstew@chromium.org>
>>>> Signed-off-by: Bing Zhao <bzhao@marvell.com>
>>>
>>> This looks ugly. Why can't you use the proper nl80211 interface and
>>> instead want to add a driver specific hack?
>>
>> "iw reg set XX" or "country_code=XX" in hostapd.conf is a *user* hint.
>>
>> What we need here is a *driver* hint. Furthermore, with a driver
>> regulatory hint, the passive-scan and no-ibss flags are cleared so we
>> can start AP with hostapd on 5G band.
>
> So it's a driver hint which is coming from user space via a module
> parameter. IMHO you are abusing interfaces here. Is there any better way
> to solve your problem?

It would be nice to have some way to do this for ath9k and other NICs
as well.  Best I could come up with is a similar hack for ath9k.

I think part of the problem is that this config info needs to be
available very early in the module loading/init logic, so it's
too late to be configured using 'iw' or similar.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

