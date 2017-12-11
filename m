Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.uni-rostock.de ([139.30.22.71]:58948 "EHLO
        mx1.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752984AbdLKMxn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 07:53:43 -0500
Subject: Re: [PATCH v2 1/5] mac80211_hwsim: wait for deferred radio deletion
 on mod unload
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
References: <20171121121744.23422-1-benjamin.beichler@uni-rostock.de>
 <3a182eff-3f00-49bb-94ac-ec371ff1c26e@MAIL2.uni-rostock.de>
 <1512992771.26976.73.camel@sipsolutions.net>
From: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>
Message-ID: <d61a234d-6072-1714-0674-7981ef20b33a@uni-rostock.de> (sfid-20171211_135348_007232_5C97FD82)
Date: Mon, 11 Dec 2017 13:54:02 +0100
MIME-Version: 1.0
In-Reply-To: <1512992771.26976.73.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 11.12.2017 um 12:46 schrieb Johannes Berg:
>
>> +	spin_lock_bh(&hwsim_delete_lock);
>> +	while (!list_empty(&delete_radios)) {
>> +		pr_debug("mac80211_hwsim: wait for deferred radio remove\n");
>> +		spin_unlock_bh(&hwsim_delete_lock);
>> +		flush_work(&list_entry(&delete_radios,
>> +				       struct mac80211_hwsim_data, list)
>> +			   ->destroy_work);
> This can't possibly be right ... you're locking the list_empty which is=

> a trivial pointer comparison, but not the actual list_entry() ...
Maybe the first spin_lock is not needed, but since flush_work wait for
the completion of the task, which at the end also deletes the item from
the list, holding any spin_lock would be wrong.
>
> I'd also prefer you actually didn't leave the problem in part as you
> describe - and a new workqueue probably isn't that much overhead and
> should introduce *less* new code than this, so IMHO that's worth it.
I totally agree with you, but I don't know the actual policy for
creating workqeues. I could also simply call flush_scheduled_work,
because we may have enough time at module unload. Some modules also do
it, but the description an some mailing threads mark it like
evil/deprecated. Which solution do you prefer?

kind regards

Benjamin

--=20
M.Sc. Benjamin Beichler

Universit=C3=A4t Rostock, Fakult=C3=A4t f=C3=BCr Informatik und Elektrote=
chnik
Institut f=C3=BCr Angewandte Mikroelektronik und Datentechnik

University of Rostock, Department of CS and EE
Institute of Applied Microelectronics and CE

Richard-Wagner-Stra=C3=9Fe 31
18119 Rostock
Deutschland/Germany

phone: +49 (0) 381 498 - 7278
email: Benjamin.Beichler@uni-rostock.de
www: http://www.imd.uni-rostock.de/
