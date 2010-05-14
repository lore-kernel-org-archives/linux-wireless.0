Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:53968 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab0ENFH1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 01:07:27 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTim7fnKebMoEu1DjD3S-15ZqlTUez3Lpp0wGVJQ6@mail.gmail.com>
References: <4BEC7A84.3010503@gmail.com> <AANLkTim7B5z76zJ33by6SGMgSy1gZF6qiwhEhAQ3NUtG@mail.gmail.com>
	<AANLkTim7fnKebMoEu1DjD3S-15ZqlTUez3Lpp0wGVJQ6@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 13 May 2010 22:07:06 -0700
Message-ID: <AANLkTimmctk1GWOTlW8Han7E3gJVgqJjUAMeqYnvyuHn@mail.gmail.com>
Subject: Re: ath9k: BUG kmalloc-8192: Poison overwritten
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
	linux-wireless@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 13, 2010 at 9:55 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Hi Luis,
>
> On Fri, May 14, 2010 at 2:01 AM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
>> On Thu, May 13, 2010 at 3:17 PM, Justin P. Mattock
>> <justinmattock@gmail.com> wrote:
>>> not sure what this is, but while at a convention
>>> I was trying to access the internet and(below is
>>> full dmesg) this showed up.
>>>
>>> After receiving this, I sat and tried to re-create
>>> my steps to reproduce but had no luck(was even going
>>> todo a bisect n the spot if I could re-create).
>>
>> OK this stuff is hard to reproduce it seems.. you have an Atheros
>> AR5418 MAC/BB Rev:2 AR5133 RF Rev:81, what kconfig option do you use
>> to get the poison stuff? I am just surprised we haven't seen it
>> ourselves yet. Let me make sure all of us get this kconfig option
>> enabled.
>
> CONFIG_SLUB_DEBUG and then either CONFIG_SLUB_DEBUG_ON or pass
> 'slub_debug' as kernel parameter.

Ah OK I had CONFIG_SLUB_DEBUG but not  CONFIG_SLUB_DEBUG_ON, will
enable it from here on.

  Luis
