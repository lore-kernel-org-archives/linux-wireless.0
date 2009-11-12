Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:60467 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbZKLTfn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 14:35:43 -0500
Received: by iwn8 with SMTP id 8so2033394iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2009 11:35:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1258054304.3899.36.camel@johannes.local>
References: <f74418680911120331w1ea31a68y56440dc0fbd253bb@mail.gmail.com>
	<40101cc30911120618m5d9acd34pf6aa9ec89c6c40b8@mail.gmail.com>
	<20091112154440.GD19349@tux> <43e72e890911120749n72360f0btfb058ab3a521eabb@mail.gmail.com>
	<40101cc30911121118h17db32a1y61edac1a4c0aec24@mail.gmail.com>
	<1258054304.3899.36.camel@johannes.local>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 12 Nov 2009 11:35:29 -0800
Message-ID: <43e72e890911121135v150e33cbwcaa284ba998d2656@mail.gmail.com>
Subject: Re: [ath9k-devel] Possible memory leak in ath9k monitor mode
	injection
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Matteo Croce <technoboy85@gmail.com>,
	Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 12, 2009 at 11:31 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2009-11-12 at 20:18 +0100, Matteo Croce wrote:
>
>> # echo scan >/sys/kernel/debug/kmemleak ; cat
>> /sys/kernel/debug/kmemleak
>> kmemleak: 197 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
>> unreferenced object 0xc5cfea80 (size 192):
>>   comm "softirq", pid 0, jiffies 14191
>>   backtrace:
>>     [<ffffffff>] 0xffffffff
>
> that's kinda useless, can you run

But if you insist on using kmemleak, try clearing the list

echo clear > kmemleak

Then scan

echo scan > kmemleak

then run your frame injection tests and then re-run scan.

echo scan > kmemleak

Then paste the output here.

  Luis
