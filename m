Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from jenny.ondioline.org ([66.220.1.122]:46764 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477AbZGDGjN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jul 2009 02:39:13 -0400
From: Paul Collins <paul@burly.ondioline.org>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlagn: possible regressions from 2.6.29 in 2.6.30
References: <874oty9tlf.fsf@bulky.wgtn.ondioline.org>
	<1246378651.17896.523.camel@rc-desk>
	<87k52t9ynp.fsf@jenny.ondioline.org>
Date: Sat, 04 Jul 2009 18:39:11 +1200
In-Reply-To: <87k52t9ynp.fsf@jenny.ondioline.org> (Paul Collins's message of
	"Wed, 01 Jul 2009 09:53:14 +1200")
Message-ID: <87tz1thrzk.fsf@bulky.wgtn.ondioline.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Paul Collins <paul@burly.ondioline.org> writes:

> reinette chatre <reinette.chatre@intel.com> writes:
>>> When I say "packets > 250 bytes" I mean 250-byte packets as claimed by
>>> "ping -s 222 mygateway":
>>> 
>>>         PING cornelius.lan (10.2.4.1) 222(250) bytes of data.
>>> 
>>> The above will work, but "ping -s 223 cornelius" yields no replies.
>>
>> Are you saying this works before suspend, but not after resume? What do
>> you usually do to get this working again?
>
> Yes, normally it works great; I can ping with packet sizes up to the
> MTU.  However, after suspend/resume and reassociation, "ping -s 223" or
> greater does not work.  I get replies with "-s 222" or less,
> i.e. packets of 250 bytes or less.
>
> To get it working again I do "ifdown wlan0" followed by "ifup wlan0",
> which does the equivalent of "ip set link wlan0 down/up" and applying
> the network configuration.
>
> I will give the patch a shot when I get home.

I thought at first that the patch had moved the problem from reliably
reproducible to intermittently reproducible, but it looks like it was
simply intermittently reproducible the whole time.  So, no change with
the patch applied.

-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
