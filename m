Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:42634 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbYLSGVZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 01:21:25 -0500
Received: by bwz14 with SMTP id 14so3078449bwz.13
        for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2008 22:21:24 -0800 (PST)
Message-ID: <8e92b4100812182221n747661b5pe4d18e8c564f871b@mail.gmail.com> (sfid-20081219_072129_373186_A115EF74)
Date: Fri, 19 Dec 2008 11:51:24 +0530
From: "Vivek Natarajan" <vivek.natraj@gmail.com>
To: "Kalle Valo" <kalle.valo@nokia.com>
Subject: Re: [PATCH v6 3/3] mac80211: implement dynamic power save
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <8e92b4100812182217q6f8e6014s3f28ab79c5bc2ba3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20081218213306.7248.64398.stgit@tikku>
	 <20081218213527.7248.65697.stgit@tikku>
	 <8e92b4100812182217q6f8e6014s3f28ab79c5bc2ba3@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 19, 2008 at 11:47 AM, Vivek Natarajan
<vivek.natraj@gmail.com> wrote:
> On Fri, Dec 19, 2008 at 3:05 AM, Kalle Valo <kalle.valo@nokia.com> wrote:
>> @@ -872,6 +878,9 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
>>        local->oper_channel_type = NL80211_CHAN_NO_HT;
>>        config_changed |= IEEE80211_CONF_CHANGE_HT;
>>
>> +       del_timer_sync(&local->dynamic_ps_timer);
>> +       cancel_work_sync(&local->dynamic_ps_enable_work);
>
> In addition, shouldn't we have this 'cancel_work'  in ieee80211_stop
> or where ever in the stop/detach path since the ps timer may be
> triggered even after the interface is brought down.

Sorry, ieee80211_set_disassoc is called from ieee80211_stop too...


Vivek.
