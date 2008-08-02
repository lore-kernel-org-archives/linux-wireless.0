Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.227]:59485 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbYHBVVq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Aug 2008 17:21:46 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1568594rvb.1
        for <linux-wireless@vger.kernel.org>; Sat, 02 Aug 2008 14:21:46 -0700 (PDT)
Message-ID: <1ba2fa240808021421h421fc362ib92660f7be4727f8@mail.gmail.com> (sfid-20080802_232152_761444_AD6C01B4)
Date: Sun, 3 Aug 2008 00:21:45 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: [PATCH 8/8] rfkill: add support for wake-on-wireless-packet
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, "Ivo van Doorn" <ivdoorn@gmail.com>
In-Reply-To: <20080802192704.GB24253@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br>
	 <1217700664-20792-9-git-send-email-hmh@hmh.eng.br>
	 <1217703723.8621.50.camel@johannes.berg>
	 <20080802192704.GB24253@khazad-dum.debian.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 2, 2008 at 10:27 PM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> Hi Johannes!
>
> On Sat, 02 Aug 2008, Johannes Berg wrote:
>
>> On Sat, 2008-08-02 at 15:11 -0300, Henrique de Moraes Holschuh wrote:
>> > Currently, rfkill would stand in the way of properly supporting wireless
>> > devices that are capable of waking the system up from sleep or hibernation
>> > when they receive a special wireless message.
>> >
>> > Since rfkill attempts to soft-block any transmitters during class suspend,
>>
>> why does it interfere with suspend anyway?
>
> The class makes sure that all transmitters are blocked on suspend.  You'd
> have to ask Ivo for the reason, but AFAIK, it is for both safety and to help
> conserve power.

This one is also on my list to remove. Suspend/Hibernate Resume
definitelly doesn't mean to rfkill radio on and off.. Driver should
bring down the NIC up and down. anyway nless it supports some D3
working condition as iwlwiifi HW )not enabled under Linux).
This only creates conflicts as both driver and rfkill system are
trying to bring radio down
RFKILL  IMHO shell track rfkill switches states and not to invent
them. If the radio was SW switched  off before NIC was suspend it
shell be switched off also in resume. That's should be role of rfkill
system, probably with some help from user space.

Tomas

Tomas
