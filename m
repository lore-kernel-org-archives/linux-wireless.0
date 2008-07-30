Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:58043 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbYG3QIA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jul 2008 12:08:00 -0400
Received: by rv-out-0506.google.com with SMTP id k40so82883rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 30 Jul 2008 09:08:00 -0700 (PDT)
Message-ID: <1ba2fa240807300908x5489e3f8g54ff83e7e5912c0b@mail.gmail.com> (sfid-20080730_180804_419423_0968FCB3)
Date: Wed, 30 Jul 2008 19:08:00 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwlwifi aggregation info
Cc: Friedrich.Beckmann@infineon.com, linux-wireless@vger.kernel.org,
	j@w1.fi
In-Reply-To: <1217431179.10489.134.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1217331138.10489.24.camel@johannes.berg>
	 <1217341293.10489.73.camel@johannes.berg>
	 <1ba2fa240807290855p191eebesb1ecf2314031f688@mail.gmail.com>
	 <1217411631.10489.103.camel@johannes.berg>
	 <8469FC7DDCBE054D9653D8506E1FF0F001F1E7B606@mucse406.eu.infineon.com>
	 <1217423948.10489.121.camel@johannes.berg>
	 <1ba2fa240807300645j654a82b4rb813b71681dfab71@mail.gmail.com>
	 <1217425854.10489.125.camel@johannes.berg>
	 <1ba2fa240807300659p4d743f31se265f550a2da0dd1@mail.gmail.com>
	 <1217431179.10489.134.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 30, 2008 at 6:19 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2008-07-30 at 16:59 +0300, Tomas Winkler wrote:
>
>> > Well qdiscs don't just do that, depending on the configuration, so we
>> > shouldn't rely on them doing just that.
>>
>> I know but this was the primary purpose of MQ to push the scheduling
>> decision to HW if I'm not mistaken.
>
> I thought it was more about the upper level locking, ethernet hw really
> just round-robins most of the time. Although it will, of course, be used
> for scheduling decisions.
>
> Is aggregation really a scheduling decision though?
>
>> We really don't need anything else just queueing.
>
> Exactly, but qdiscs do most definitely not provide just queueing, and we
> should not deprive the user of the ability to use qdiscs on wireless.
>
>>  For example what the
>> prioritization which is done in current wme.c
>> is wrong and it won't pass certification and creates starvation.
>> Tested and proved.
>
> Can you explain how starvation happens? In what scenarios? With or
> without aggregation?

for (queue = 0; queue < QD_NUM(hw); queue++)

This always starts 0  prioritize dequeue the first frame. But what we
need is RR and let HW to prioritize the transmission according AC
Tomas
