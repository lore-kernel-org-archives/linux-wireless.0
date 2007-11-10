Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from agave.telenet-ops.be ([195.130.137.77]:39500 "EHLO
	agave.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbXKJCSZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2007 21:18:25 -0500
Message-ID: <473514F3.50500@telenet.be> (sfid-20071110_021830_458307_FC97EF62)
Date: Sat, 10 Nov 2007 03:18:27 +0100
From: Ian Schram <ischram@telenet.be>
MIME-Version: 1.0
To: Tomas Winkler <tomasw@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	=?ISO-8859-1?Q?Ismail_D=F6?= =?ISO-8859-1?Q?nmez?=
	<ismail@pardus.org.tr>, Dan Williams <dcbw@redhat.com>,
	Stephen.Clark@seclark.us, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [ipw3945-devel] iwl3945 doesn't work
References: <20071017135452.GJ5043@kernel.dk> <20071017141111.GM5043@kernel.dk>	<1192630733.10567.37.camel@localhost.localdomain>	<20071017142246.GQ5043@kernel.dk>	<1192634183.11584.0.camel@localhost.localdomain>	<20071017163519.GC15552@kernel.dk> <47166B5F.1010804@seclark.us>	<20071018065746.GB5063@kernel.dk> <47175033.1090709@seclark.us>	<1192710788.15285.4.camel@johannes.berg> <1ba2fa240710180602m61ae9478k84791690095e76d@mail.gmail.com>
In-Reply-To: <1ba2fa240710180602m61ae9478k84791690095e76d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I wonder if anybody knows something more about this issue by now,
as it appears to occur to a few people.

I reread the thread (rather quickly) but I do not see many specifications
of driver/mac80211/kernel. The few cases that do contain specs all appear
to be using fedora (don't want to jump to conclusions). But just wondering if
anybody experienced this on any other kernel?

The log that I saw from a person with these symptoms, showed a perfectly normal
booting driver, doing all the initialization identical to my functional card,
except that apparently iwl_mac_open() (which is currently known as iwl3945_mac_start iirc)
is never called.

this callback is conditionally called from mac80211, in on it's turn a callback from
even higher up the kernel stack. Hence my best (uneducated) guess would be that
for some reason mac80211 doesn't call the ops->start(), but the scan (completion)
somehow manages to rectify this

I believe this bug is similar though with older versions of the code
http://bughost.org/bugzilla/show_bug.cgi?id=1452
although back then the scan didn't magically fix it.

Seeing as the driver appears to be functioning normally (it's receiving! and dropping
packages because not open). and my knowledge of mac80211 is very limited i'm hoping
someone here knows:

What could sensibly be causing ops->start() not to be called?

Tomas Winkler wrote:
> On 10/18/07, Johannes Berg <johannes@sipsolutions.net> wrote:
>> On Thu, 2007-10-18 at 08:23 -0400, Stephen Clark wrote:
>>
>>>>> iwlist eth1 scan would report no scan results, I then switched to loading
>>>>> the kernel module with
>>>>> the option that tells  iwl3945 to do software scanning and it works
>>>>> everytime now.
>>> In my modprobe.conf file:
>>> options iwl3945 disable_hw_scan=1
>> Hah. Told you it wasn't mac80211's problem. Can somebody remind me again
>> exactly why we have hardware scan offload when we parse each received
>> packet anyway and the hardware doesn't even batch them so the CPU could
>> wake up less?
>>
> 1. Tuning to each channel is done internally by fw so you don't spend
> cycles and it's is faster to switch channels so overall scanning take
> less time. Sending probe responses is also offloaded.  Returning to
> operational channel is more precisely matched to DTIM period as it is
> handled by RT code.
> 2. There are also more advanced modes of scanning such as during voice
> traffic etc.
> 3. Yes beacon batching will be nice, but there is a memory tradeoff.
> Tomas
> 
>> johannes
>>
>>
> 

