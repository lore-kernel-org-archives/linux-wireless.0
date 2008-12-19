Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:63066 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700AbYLSHhc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 02:37:32 -0500
To: "Vivek Natarajan" <vivek.natraj@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v6 3/3] mac80211: implement dynamic power save
References: <20081218213306.7248.64398.stgit@tikku>
	<20081218213527.7248.65697.stgit@tikku>
	<8e92b4100812182217q6f8e6014s3f28ab79c5bc2ba3@mail.gmail.com>
	<8e92b4100812182221n747661b5pe4d18e8c564f871b@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Fri, 19 Dec 2008 09:37:20 +0200
In-Reply-To: <8e92b4100812182221n747661b5pe4d18e8c564f871b@mail.gmail.com> (ext Vivek Natarajan's message of "Fri\, 19 Dec 2008 11\:51\:24 +0530")
Message-ID: <87r644y5sf.fsf@nokia.com> (sfid-20081219_083737_513372_3637B381)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan <vivek.natraj@gmail.com> writes:

> On Fri, Dec 19, 2008 at 11:47 AM, Vivek Natarajan
> <vivek.natraj@gmail.com> wrote:
>> On Fri, Dec 19, 2008 at 3:05 AM, Kalle Valo <kalle.valo@nokia.com> wrote:
>>> @@ -872,6 +878,9 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
>>>        local->oper_channel_type = NL80211_CHAN_NO_HT;
>>>        config_changed |= IEEE80211_CONF_CHANGE_HT;
>>>
>>> +       del_timer_sync(&local->dynamic_ps_timer);
>>> +       cancel_work_sync(&local->dynamic_ps_enable_work);
>>
>> In addition, shouldn't we have this 'cancel_work'  in ieee80211_stop
>> or where ever in the stop/detach path since the ps timer may be
>> triggered even after the interface is brought down.
>
> Sorry, ieee80211_set_disassoc is called from ieee80211_stop too...

Yeah, I got lucky. John fixed this a while ago.

-- 
Kalle Valo
