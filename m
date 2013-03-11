Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37624 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab3CKWAn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Mar 2013 18:00:43 -0400
Message-ID: <513E5401.8030607@candelatech.com> (sfid-20130311_230047_916309_E54CE551)
Date: Mon, 11 Mar 2013 15:00:33 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k: Allow over-riding reg-domain.
References: <1363020306-924-1-git-send-email-greearb@candelatech.com> <20130311190537.GB32171@tuxdriver.com> <513E35CD.3010006@candelatech.com> <513E3BE8.1000909@openwrt.org> <513E4617.2020906@candelatech.com> <513E4E76.2000000@openwrt.org> <513E5057.4030601@candelatech.com> <513E51F5.6080005@openwrt.org>
In-Reply-To: <513E51F5.6080005@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/11/2013 02:51 PM, Felix Fietkau wrote:
> On 2013-03-11 10:44 PM, Ben Greear wrote:
>> On 03/11/2013 02:36 PM, Felix Fietkau wrote:
>>> On 2013-03-11 10:01 PM, Ben Greear wrote:
>>>> On 03/11/2013 01:17 PM, Felix Fietkau wrote:
>>
>>>> I am not sure what you are suggesting.  I enabled this override
>>>> only when ONUS is selected because I wanted it clear that users
>>>> were taking their regulatory compliance into their own hands.
>>> And as far as I understand, CONFIG_CFG80211_CERTIFICATION_ONUS already
>>> enables some code in cfg80211 that allows a special type of regulatory
>>> change request from user space that bypasses intersection.
>>>
>>>> I always want the module option at least visible so that
>>>> you don't have to muck with modprobe.conf just to get ath9k.ko
>>>> to load when it's compiled differently.
>>>>
>>>> For the second part, you want the ability to set the regdomain
>>>> be a compile-time option like CONFIG_ATH9K_OVERRIDE_REGDOMAIN
>>>> or something like that?
>>> Something like that, yes. It should depend on
>>> CONFIG_CFG80211_CERTIFICATION_ONUS and should contain a help text that
>>> strongly discourages any distribution from enabling it in their kernel
>>> builds.
>>
>> It seems to me that this doesn't gain much.  The ONUS configuration is already
>> strongly discouraged from vendor kernels.  If you are already compiling
>> with ONUS set, is there any reason you'd care to disable the override
>> module option?  When you don't set the module option, nothing happens
>> anyway...
> I'd like to avoid accumulating more hackish driver specific module
> options for working around a generic issue.

I don't think I'm up for any significant re-write of the
regdomain logic, and I'm not sure it's worth the effort
of anyone doing this for code that will be compiled out
of all vendor kernels anyway...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

