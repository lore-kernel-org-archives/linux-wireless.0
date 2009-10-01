Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f227.google.com ([209.85.219.227]:42390 "EHLO
	mail-ew0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbZJATzH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2009 15:55:07 -0400
Received: by ewy27 with SMTP id 27so629251ewy.40
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2009 12:55:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1254422380.3959.23.camel@johannes.local>
References: <57b62e7d0909291754x352ae254sa33ee7efb430d497@mail.gmail.com>
	 <1254341787.3959.11.camel@johannes.local>
	 <57b62e7d0910010732m38ab57k916662f9047fcc91@mail.gmail.com>
	 <57b62e7d0910010740t67a96d88h59b10161844f2836@mail.gmail.com>
	 <1254422380.3959.23.camel@johannes.local>
Date: Thu, 1 Oct 2009 21:55:10 +0200
Message-ID: <57b62e7d0910011255r2ecf2bbex37422204add9a2b0@mail.gmail.com>
Subject: Re: VLAN traffic appearing on the wrong iface
From: =?UTF-8?B?Qmxhxb4gQmHEjW5paw==?= <bacnik@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 1, 2009 at 8:39 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> Thanks for looking into the crash -- I can't explain it.
>
>> -     if (ieee80211_vif_is_mesh(&sdata->vif)) {
>> +     if (ieee80211_vif_is_mesh(&(*sta)->sdata->vif)) {
>
> However, that doesn't make any sense, given
>
>        struct ieee80211_sub_if_data *sdata = (*sta)->sdata;
>
> Could the compiler be playing tricks on us?

There's the sdata = container_of(sdata->bss, struct ieee80211_sub_if_data, u.ap)
in if-clause right in front of the ieee80211_vif_is_mesh and since
this is a vlan
interface that if-clause gets executed. This is done because we need to tell the
real, non-vlan interface what is going on. It changes sdata which is
understandable.
But I've really no idea why the new sdata (of non-vlan ap subiface)
does not have initialized vif member. Since this is the reason behind the oops:
trying to dereference a vif->type member of AP/VLAN's AP iface.

Basically, that if-clause changes sdata if iface type is AP/VLAN
(which it is), then tries
to do some stuff on the new sdata. And I think it should be doing it
on the old sdata --
this is what this patch does.

Regards, Blaz
