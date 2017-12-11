Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.uni-rostock.de ([139.30.22.71]:62226 "EHLO
        mx1.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751956AbdLKNHV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 08:07:21 -0500
Subject: Re: [PATCH v2 1/5] mac80211_hwsim: wait for deferred radio deletion
 on mod unload
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
References: <20171121121744.23422-1-benjamin.beichler@uni-rostock.de>
 <3a182eff-3f00-49bb-94ac-ec371ff1c26e@MAIL2.uni-rostock.de>
 <1512992771.26976.73.camel@sipsolutions.net>
 <d61a234d-6072-1714-0674-7981ef20b33a@uni-rostock.de>
 <1512997053.26976.77.camel@sipsolutions.net>
From: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>
Message-ID: <989966fe-2f61-5e71-5174-cb5d216944a4@uni-rostock.de> (sfid-20171211_140724_792519_3D4F4808)
Date: Mon, 11 Dec 2017 14:07:39 +0100
MIME-Version: 1.0
In-Reply-To: <1512997053.26976.77.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 11.12.2017 um 13:57 schrieb Johannes Berg:
> On Mon, 2017-12-11 at 13:54 +0100, Benjamin Beichler wrote:
>> Am 11.12.2017 um 12:46 schrieb Johannes Berg:
>>>> +	spin=5Flock=5Fbh(&hwsim=5Fdelete=5Flock);
>>>> +	while (!list=5Fempty(&delete=5Fradios)) {
>>>> +		pr=5Fdebug("mac80211=5Fhwsim: wait for deferred radio remove\n");
>>>> +		spin=5Funlock=5Fbh(&hwsim=5Fdelete=5Flock);
>>>> +		flush=5Fwork(&list=5Fentry(&delete=5Fradios,
>>>> +				       struct mac80211=5Fhwsim=5Fdata, list)
>>>> +			   ->destroy=5Fwork);
>>> This can't possibly be right ... you're locking the list=5Fempty which is
>>> a trivial pointer comparison, but not the actual list=5Fentry() ...
>> Maybe the first spin=5Flock is not needed, but since flush=5Fwork wait for
>> the completion of the task, which at the end also deletes the item from
>> the list, holding any spin=5Flock would be wrong.
> But not holding it while taking things that are on the list also seems
> wrong.
Since at this place (Netlink is already unregistered so no new deletion
requests) the only user of the delete list is the code deferred work
items (which take itself the lock). Nonetheless, with a separate
workqueue this is no problem anymore.
>
>>> I'd also prefer you actually didn't leave the problem in part as you
>>> describe - and a new workqueue probably isn't that much overhead and
>>> should introduce *less* new code than this, so IMHO that's worth it.
>> I totally agree with you, but I don't know the actual policy for
>> creating workqeues. I could also simply call flush=5Fscheduled=5Fwork,
>> because we may have enough time at module unload. Some modules also do
>> it, but the description an some mailing threads mark it like
>> evil/deprecated. Which solution do you prefer=3F
> Let's go with a new workqueue.
Ok, I prepare a patch in the next few days.

>
> johannes
>

-- 
M.Sc. Benjamin Beichler

Universit=C3=A4t Rostock, Fakult=C3=A4t f=C3=BCr Informatik und Elektrotechnik
Institut f=C3=BCr Angewandte Mikroelektronik und Datentechnik

University of Rostock, Department of CS and EE
Institute of Applied Microelectronics and CE

Richard-Wagner-Stra=C3=9Fe 31
18119 Rostock
Deutschland/Germany

phone: +49 (0) 381 498 - 7278
email: Benjamin.Beichler@uni-rostock.de
www: http://www.imd.uni-rostock.de/
