Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36507 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754615Ab1BNOGV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 09:06:21 -0500
Message-ID: <4D593295.6060800@openwrt.org>
Date: Mon, 14 Feb 2011 14:48:05 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Mohammed Shafi <mshajakhan@atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH] ath9k: make use of slot time macros
References: <1297407704-4029-1-git-send-email-mshajakhan@atheros.com> <4D553107.3020402@openwrt.org> <20110211161551.GA2224@tuxdriver.com> <4D5561F2.3050404@openwrt.org> <20110211162944.GD2224@tuxdriver.com> <4D58B25D.4040507@atheros.com> <4D58B39B.9040207@atheros.com>
In-Reply-To: <4D58B39B.9040207@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-02-14 5:46 AM, Mohammed Shafi wrote:
> On Monday 14 February 2011 10:11 AM, Mohammed Shafi wrote:
>> On Friday 11 February 2011 09:59 PM, John W. Linville wrote:
>>> On Fri, Feb 11, 2011 at 05:21:06PM +0100, Felix Fietkau wrote:
>>>> On 2011-02-11 5:15 PM, John W. Linville wrote:
>>>>> On Fri, Feb 11, 2011 at 01:52:23PM +0100, Felix Fietkau wrote:
>>>>>> On 2011-02-11 8:01 AM, Mohammed Shafi Shajakhan wrote:
>>>>>>> From: Mohammed Shafi Shajakhan<mshajakhan@atheros.com>
>>>>>>>
>>>>>>> Instead of using raw numbers to assign slot time it would be 
>>>>>>> better to
>>>>>>> make use of predefined slot time macros
>>>>>> How does this make it better?
>>>>> Maybe if it was ATH9K_SHORT_SLOT_TIME it would make more sense?
>>>> Well, neither the unit of this variable, nor the values that can be 
>>>> used
>>>> are ath9k specific.
> Felix  then I don't know why these macros are used here and I followed 
> the same thing:
> 
> htc_drv_beacon.c 242 if (ah->slottime == ATH9K_SLOT_TIME_20)
> init.c           517 sc->beacon.slottime = ATH9K_SLOT_TIME_9;
Just because the macros are there doesn't mean that it was a good idea
to use them. As far as I know, these were simply inherited from the
Atheros codebase that ath9k was based on.
I actually consider the code more readable without the redundant
"ATH9K_SLOT_TIME_" part.

- Felix
