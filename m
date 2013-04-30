Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51176 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760834Ab3D3SZl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Apr 2013 14:25:41 -0400
Message-ID: <51800C9A.2090404@candelatech.com> (sfid-20130430_202545_819798_E12C294C)
Date: Tue, 30 Apr 2013 11:25:30 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH] ath9k: Allow over-riding reg-domain.
References: <1363020306-924-1-git-send-email-greearb@candelatech.com> <20130311190537.GB32171@tuxdriver.com> <513E35CD.3010006@candelatech.com> <513E3BE8.1000909@openwrt.org>
In-Reply-To: <513E3BE8.1000909@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/11/2013 01:17 PM, Felix Fietkau wrote:
> On 2013-03-11 8:51 PM, Ben Greear wrote:
>> On 03/11/2013 12:05 PM, John W. Linville wrote:
>>> On Mon, Mar 11, 2013 at 09:45:06AM -0700, greearb@candelatech.com wrote:
>>>> From: Ben Greear <greearb@candelatech.com>
>>>>
>>>> Otherwise, can't get the Sparklan AR9380 NICs to be
>>>> 5Ghz APs, since they are in world-roaming domain by
>>>> default.  Add this to /etc/modprobe.d/ath9k.conf:
>>>>
>>>> options ath9k override_eeprom_regdomain=0
>>>>
>>>> Signed-off-by: Ben Greear <greearb@candelatech.com>
>>>
>>> Why "=0" to enable it?  Just to make it more confusing?
>>
>> You are just setting the country code...and country-code 0 seems
>> to at least open up the US regulatory domain so we use it
>> by default.
>>
>> You can use any country code you wish here.
> I'd like to have less fugly module parameter hackery please. How about
> either using CONFIG_CFG80211_CERTIFICATION_ONUS the way it was intended,
> or adding another config option that makes it bail out of
> ath_regd_init_wiphy() early, thus still processing the EEPROM regdomain
> hint and not making it binding.


I get lost in the weeds when trying to understand that code, and I'm
not sure where it should bail out early to accomplish the suggestion
above.

If by chance you have time & interest to put together a patch
to handle the code changes, I'll be happy to test it.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

