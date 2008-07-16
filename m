Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:57018 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbYGPT12 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2008 15:27:28 -0400
Received: by qw-out-2122.google.com with SMTP id 3so371451qwe.37
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2008 12:27:26 -0700 (PDT)
Message-ID: <40f31dec0807161227n4254b8adobbbcfdde540704fd@mail.gmail.com> (sfid-20080716_212732_294506_110F610C)
Date: Wed, 16 Jul 2008 22:27:26 +0300
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Jesse Barnes" <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 5/5] Ath5k: suspend/resume fixes
Cc: "Pavel Roskin" <proski@gnu.org>,
	"Jiri Slaby" <jirislaby@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <200807161141.59385.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1216136661-10930-1-git-send-email-jirislaby@gmail.com>
	 <200807160931.11473.jbarnes@virtuousgeek.org>
	 <1216229703.29744.23.camel@dv>
	 <200807161141.59385.jbarnes@virtuousgeek.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/7/16 Jesse Barnes <jbarnes@virtuousgeek.org>:
> On Wednesday, July 16, 2008 10:35 am Pavel Roskin wrote:
>> On Wed, 2008-07-16 at 09:31 -0700, Jesse Barnes wrote:
>> > On Wednesday, July 16, 2008 9:15 am Nick Kossifidis wrote:
>> > > It's ok for now, but have in mind that on my upcoming patch series i'm
>> > > disabling msi (commented out) since it results no interrupts on pci-e
>> > > cards (seems there is a bug in kernel's msi implementation).
>> >
>> > Hm, would be good to get details here.  MSI is being used by other
>> > drivers successfully...
>>
>> That's true, but no driver uses the same interrupt handler with and
>> without MSI.  Either it's different handlers or the handler checks if
>> MSI is enabled and does something differently.
>
> Yeah, using MSI on your device can mean that you have to make some changes
> (like on Intel graphics you have to disable regular interrupts or bad things
> happen), but you can still share the handler or at least most of it in some
> cases.
>

Is there documentation for this somewhere ? Msi documentation
(MSI-HOWTO.txt) doesn't say anything about a different interrupt
handler etc.

>> Checks is any interrupts are pending are different for MSI.  It may be
>> not hard to do (it's probably easier than for real interrupts), but it
>> has to be figured out.  Somebody has to do it right.  Until MSI is
>> supported by the interrupt handler, it should not be enabled by the
>> driver, or we get a non-functioning driver for AR5006.
>
> Sure, that's fine.  I just wanted to make sure that there weren't some weird
> generic MSI problems.
>

I was referring to this post...
http://lkml.org/lkml/2008/6/24/150


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
