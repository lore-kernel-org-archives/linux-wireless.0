Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f175.google.com ([209.85.223.175]:40755 "EHLO
	mail-iw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934385AbZIDWlA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Sep 2009 18:41:00 -0400
Received: by iwn5 with SMTP id 5so376660iwn.4
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2009 15:41:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1252103579.21380.10.camel@pc1117.cambridge.arm.com>
References: <43e72e890909041515s38e7c502kf552a5cf90e99d94@mail.gmail.com>
	<1252103579.21380.10.camel@pc1117.cambridge.arm.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 4 Sep 2009 15:40:43 -0700
Message-ID: <43e72e890909041540l5aa6aa2dn403efe4451ecc6e6@mail.gmail.com>
Subject: Re: kmemleak reports on wireless-testing master-2009-09-04 + kmemleak
	tree
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 4, 2009 at 3:32 PM, Catalin Marinas<catalin.marinas@arm.com> wrote:
> On Fri, 2009-09-04 at 15:15 -0700, Luis R. Rodriguez wrote:
>> I get these with today's wireless-testing + pulling Catalin's kmemleak
>> tree. I nothing upon bootup, and then after a while I force a scan and
>> get (besides some other acpi stuff):
>>
>> unreferenced object 0xffff880039c7d700 (size 256):
>>   comm "events/1", pid 10, jiffies 4295050369
>>   hex dump (first 32 bytes):
>>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>>   backtrace:
>>     [<ffffffff814e9d55>] kmemleak_alloc+0x25/0x60
>>     [<ffffffff81118a83>] kmem_cache_alloc_node+0x193/0x200
>>     [<ffffffff8141dc6a>] __alloc_skb+0x4a/0x180
>>     [<ffffffff814ddb82>] wireless_send_event+0x1f2/0x410
>>     [<ffffffffa01b7084>] ___cfg80211_scan_done+0xe4/0x110 [cfg80211]
>>     [<ffffffffa01b70d6>] __cfg80211_scan_done+0x26/0x50 [cfg80211]
>>     [<ffffffff8106de80>] worker_thread+0x1d0/0x380
>>     [<ffffffff81073266>] kthread+0xa6/0xb0
>>     [<ffffffff810130ca>] child_rip+0xa/0x20
>>     [<ffffffffffffffff>] 0xffffffffffffffff
>
> If you force a few scans, do we still get the same objects reported as
> leaks?

Just tried it, and yes.

  Luis
