Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.182]:61535 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519AbYITU5l (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Sep 2008 16:57:41 -0400
Received: by el-out-1112.google.com with SMTP id z25so227890ele.1
        for <linux-wireless@vger.kernel.org>; Sat, 20 Sep 2008 13:57:38 -0700 (PDT)
Message-ID: <43e72e890809201357y1413a151r85aad7cc16440cf4@mail.gmail.com> (sfid-20080920_225745_416096_AAE736FF)
Date: Sat, 20 Sep 2008 13:57:37 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Steven Noonan" <steven@uplinklabs.net>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27 (rc5, rc6, probably others)
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"Senthilkumar Balasubramanian"
	<Senthilkumar.Balasubramanian@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	"Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <f488382f0809200821m6fe355feu2d9fb99ac3c7f712@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <f488382f0809181604l105535bkceecd44c590bc88b@mail.gmail.com>
	 <alpine.LNX.2.00.0809190934001.22989@alcarin.uplinklabs.net>
	 <20080919175824.GA5626@senthil-lnx.users.atheros.com>
	 <20080919182322.GB7027@tesla>
	 <alpine.LNX.2.00.0809191630090.14961@alcarin.uplinklabs.net>
	 <20080919235305.GD11665@tesla>
	 <f488382f0809191701u2dbf8d22n6015c9f1f23c73be@mail.gmail.com>
	 <43e72e890809191813n95579f5h83e92b0ba1f95a44@mail.gmail.com>
	 <f488382f0809192029w601e0e72x5c3affc3dbe65118@mail.gmail.com>
	 <f488382f0809200821m6fe355feu2d9fb99ac3c7f712@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 20, 2008 at 8:21 AM, Steven Noonan <steven@uplinklabs.net> wrote:
> On Fri, Sep 19, 2008 at 8:29 PM, Steven Noonan <steven@uplinklabs.net> wrote:
>> And here's the change as I unload and reload ath9k:
>>
>> [...]
>> 20:21:38          sum  20138.83
>> 20:21:40          sum  21576.09
>> 20:21:41          sum  17678.38
>> 20:21:42          sum  19834.34
>> 20:21:43          sum  19845.10
>> 20:21:44          sum  19470.00
>> 20:21:45          sum   9273.00  <--- ath9k unloaded/reloaded
>> 20:21:46          sum    187.00
>> 20:21:47          sum   1066.00
>> 20:21:48          sum    610.00
>> 20:21:49          sum    106.93
>> 20:21:50          sum    670.00
>> 20:21:51          sum    742.00
>> 20:21:52          sum    781.00
>> Average:          sum  19562.56
>>
>
> I think it might help if you can see the .sar file yourself. I've
> uploaded a gzipped copy (great compression ratio in this case for
> merely using gzip!).
>
> http://www.uplinklabs.net/~tycho/linux/irqlog-storm.sar.gz

mcgrof@tesla ~/tmp/irq $ sar -f irqlog-storm.sar -A
Invalid system activity file: irqlog-storm.sar

Perhaps we its a different format than what my sar can read...

So here's what we need to do -- try to zero on in what causes this IRQ
storm. Most likely its some strange event that triggers it, perhaps
some sort of noise which makes the device try to adapt and hits a path
we are not handling correctly yet. Can you provide the initial log of
when ath9k gets loaded? This tells us what card it is, like AR5416 or
AR9280, etc.

  Luis
