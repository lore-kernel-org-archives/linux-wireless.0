Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from jenny.ondioline.org ([66.220.1.122]:42137 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbZF3VxM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 17:53:12 -0400
From: Paul Collins <paul@burly.ondioline.org>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlagn: possible regressions from 2.6.29 in 2.6.30
References: <874oty9tlf.fsf@bulky.wgtn.ondioline.org>
	<1246378651.17896.523.camel@rc-desk>
Date: Wed, 01 Jul 2009 09:53:14 +1200
In-Reply-To: <1246378651.17896.523.camel@rc-desk> (reinette chatre's message
	of "Tue, 30 Jun 2009 09:17:31 -0700")
Message-ID: <87k52t9ynp.fsf@jenny.ondioline.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

reinette chatre <reinette.chatre@intel.com> writes:

> On Mon, 2009-06-29 at 22:30 -0700, Paul Collins wrote:
>> Two things I liked about iwlagn in 2.6.29 no longer happen with 2.6.30:
>> 
>> 1. reassociation following resume from suspend-to-ram
>> 2. transmission of packets > 250 bytes following resume from suspend-to-ram
>> 
>> I can script around the first problem just by doing "iwconfig wlan0 ap
>> auto" on resume, but the second problem requires me to ifdown/ifup wlan0
>> before I can usefully use my network again, so fixing the first problem
>> doesn't get me very far.
>
> For reliable reassociation you need to use a userspace application like
> wpa_supplicant.

I'm using WEP here, though.  And, as I mentioned, 2.6.29 did seem to
reassociate every time by itself, but maybe I just got lucky.

>> When I say "packets > 250 bytes" I mean 250-byte packets as claimed by
>> "ping -s 222 mygateway":
>> 
>>         PING cornelius.lan (10.2.4.1) 222(250) bytes of data.
>> 
>> The above will work, but "ping -s 223 cornelius" yields no replies.
>
> Are you saying this works before suspend, but not after resume? What do
> you usually do to get this working again?

Yes, normally it works great; I can ping with packet sizes up to the
MTU.  However, after suspend/resume and reassociation, "ping -s 223" or
greater does not work.  I get replies with "-s 222" or less,
i.e. packets of 250 bytes or less.

To get it working again I do "ifdown wlan0" followed by "ifup wlan0",
which does the equivalent of "ip set link wlan0 down/up" and applying
the network configuration.

I will give the patch a shot when I get home.

Regards,

        Paul
