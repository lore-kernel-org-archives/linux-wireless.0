Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:51689 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754641Ab2DCQG1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Apr 2012 12:06:27 -0400
References: <1333399292-23231-1-git-send-email-greearb@candelatech.com> <4F7AF81F.30903@openwrt.org> <4F7B0CE6.9020300@candelatech.com>
In-Reply-To: <4F7B0CE6.9020300@candelatech.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <298BE6B2-A128-4CA7-BAD1-56E1073A2847@nbd.name> (sfid-20120403_180631_040464_C510AACC)
Cc: Felix Fietkau <nbd@openwrt.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] ath9k:  Don't delete key from hw if using sw-crypt.
Date: Tue, 3 Apr 2012 18:05:57 +0200
To: Ben Greear <greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 03.04.2012, at 16:44, Ben Greear <greearb@candelatech.com> wrote:

> On 04/03/2012 06:16 AM, Felix Fietkau wrote:
>> On 2012-04-02 10:41 PM, greearb@candelatech.com wrote:
>>> From: Ben Greear<greearb@candelatech.com>
>>> 
>>> This spams logs if we are using large numbers of stations,
>>> for instance:
>>> 
>>> ath: wiphy0: keyreset: keycache entry 228 out of range
>>> ath: wiphy0: keyreset: keycache entry 228 out of range
>>> 
>>> Signed-off-by: Ben Greear<greearb@candelatech.com>
>>> ---
>>> :100644 100644 917032a... 65e7281... M    drivers/net/wireless/ath/ath9k/main.c
>>>  drivers/net/wireless/ath/ath9k/main.c |    3 +++
>>>  1 files changed, 3 insertions(+), 0 deletions(-)
>>> 
>>> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
>>> index 917032a..65e7281 100644
>>> --- a/drivers/net/wireless/ath/ath9k/main.c
>>> +++ b/drivers/net/wireless/ath/ath9k/main.c
>>> @@ -1771,6 +1771,9 @@ static void ath9k_del_ps_key(struct ath_softc *sc,
>>>      if (!an->ps_key)
>>>          return;
>>> 
>>> +    if (ath9k_modparam_nohwcrypt)
>>> +        return;
>>> +
>> This looks wrong to me. ps_key is used for better powersave handling of
>> both unencrypted and encrypted stations (using the keycache only for tx
>> filtering on unencrypted stations).
> 
> Ok..should we just remove the spammy printk when the keycache entry
> is out of range then?
I'd say we should figure out why it triggers at all.

- Felix