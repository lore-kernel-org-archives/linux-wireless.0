Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44075 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046Ab3FMRgh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Jun 2013 13:36:37 -0400
Message-ID: <51BA031C.8080909@candelatech.com> (sfid-20130613_193643_006595_662CAC8C)
Date: Thu, 13 Jun 2013 10:36:28 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Bing Zhao <bzhao@marvell.com>, Kalle Valo <kvalo@adurom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Paul Stewart <pstew@chromium.org>
Subject: Re: [PATCH] mwifiex: Add module parameter for regdomain
References: <1370904007-10959-1-git-send-email-bzhao@marvell.com> <877ghz3il6.fsf@purkki.adurom.net> <477F20668A386D41ADCC57781B1F70430EA268B457@SC-VEXCH1.marvell.com> <8738sn2mcf.fsf@purkki.adurom.net> <51B8C41E.7050907@candelatech.com> <477F20668A386D41ADCC57781B1F70430EA268B4A3@SC-VEXCH1.marvell.com> <20130613173002.GC3246@tuxdriver.com>
In-Reply-To: <20130613173002.GC3246@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/13/2013 10:30 AM, John W. Linville wrote:
> On Wed, Jun 12, 2013 at 12:01:23PM -0700, Bing Zhao wrote:
>>
>>>>> "iw reg set XX" or "country_code=XX" in hostapd.conf is a *user* hint.
>>>>>
>>>>> What we need here is a *driver* hint. Furthermore, with a driver
>>>>> regulatory hint, the passive-scan and no-ibss flags are cleared so we
>>>>> can start AP with hostapd on 5G band.
>>>>
>>>> So it's a driver hint which is coming from user space via a module
>>>> parameter. IMHO you are abusing interfaces here. Is there any better way
>>>> to solve your problem?
>>>
>>> It would be nice to have some way to do this for ath9k and other NICs
>>> as well.  Best I could come up with is a similar hack for ath9k.
>>>
>>> I think part of the problem is that this config info needs to be
>>> available very early in the module loading/init logic, so it's
>>> too late to be configured using 'iw' or similar.
>>
>> Exactly. regulatory_hint () needs to be called right after wiphy registration.
>
> It does seem a bit ugly.  But if Marvell wants it, I don't see any
> "regulatory" argument to disallow something like this.
>
> Does anyone have a better suggestion for a user interface for such
> a feature?

Maybe a global over-ride module-option in cfg80211 module so that
we wouldn't have to have an individual module-option hack for
each driver?

But, then again, maybe we would still want individual driver
config options....

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

