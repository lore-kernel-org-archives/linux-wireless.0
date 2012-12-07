Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59446 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424123Ab2LGUq0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 15:46:26 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so607934pbc.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Dec 2012 12:46:26 -0800 (PST)
Message-ID: <50C255A0.7070306@cozybit.com> (sfid-20121207_214630_430216_646701FB)
Date: Fri, 07 Dec 2012 12:46:24 -0800
From: Marco Porsch <marco@cozybit.com>
MIME-Version: 1.0
To: devel@lists.open80211s.org
CC: Thomas Pedersen <thomas@cozybit.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] {nl, cfg, mac}80211: set beacon interval and DTIM period
 on mesh join
References: <1354745174-2941-1-git-send-email-marco.porsch@etit.tu-chemnitz.de> <CAG6hwVOc=E67ZxuFZnk3goM8VVEOqSWOi6dn63L2rmEyWOfG1g@mail.gmail.com> <1354791010.10150.1.camel@jlt4.sipsolutions.net> <CAG6hwVMkhScnykjjzzDExo_vcPUWcAopZQn4s8rjC_6LH4g58w@mail.gmail.com>
In-Reply-To: <CAG6hwVMkhScnykjjzzDExo_vcPUWcAopZQn4s8rjC_6LH4g58w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/07/2012 12:25 PM, Thomas Pedersen wrote:
> On Thu, Dec 6, 2012 at 2:50 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> On Wed, 2012-12-05 at 14:57 -0800, Thomas Pedersen wrote:
>>> On Wed, Dec 5, 2012 at 2:06 PM, Marco Porsch
>>> <marco.porsch@etit.tu-chemnitz.de> wrote:
>>>> Move the default mesh beacon interval and DTIM period to cfg80211 and
>>>> make it accessible to nl80211. This enables setting both values when joining
>>>> an MBSS.
>>>>
>>>> NOTE: In a mesh with links in PS mode it is not advised to use the default
>>>> parameters 1000:4, as these cause excessive buffering delays that exceed
>>>> various timeouts (e.g. HWMP path request).
>>>
>>> Then make the default parameters reasonable? How is 1000:2?
>>
>> That's still ~2 seconds, no?
>
> Yeah I guess those would both be unsuitable for PS anyway, so it's fine as is.

Snap, I just see carl9170 has a check for beacon interval and DTIM 
period [1].

I'll change the DTIM period default value.
To my best knowledge, it does not do any difference out of powersave 
mode, and for powersave DTIM period 1 is favourable. Any objections?

--Marco


[1]
/*
  * Therefore a hard limit for the broadcast traffic should
  * prevent false alarms.
  */
if (vif->type != NL80211_IFTYPE_STATION &&
     (bss_conf->beacon_int * bss_conf->dtim_period >=
      (CARL9170_QUEUE_STUCK_TIMEOUT / 2))) {
	err = -EINVAL;
	goto out;
}

(CARL9170_QUEUE_STUCK_TIMEOUT is 5500.)

