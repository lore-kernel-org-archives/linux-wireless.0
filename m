Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f193.google.com ([209.85.221.193]:38898 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbZGHRKz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2009 13:10:55 -0400
Received: by qyk31 with SMTP id 31so5493924qyk.33
        for <linux-wireless@vger.kernel.org>; Wed, 08 Jul 2009 10:10:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090708125727.GC4253@tuxdriver.com>
References: <4A49EEC3.3060108@mrs.ro> <43e72e890906300920j1963ae07v800468db9a908a1@mail.gmail.com>
	<4A4B056B.9000602@mrs.ro> <43e72e890907011033r52c4256dtecf603f56213a825@mail.gmail.com>
	<4A530131.9050207@mrs.ro> <4A532D3C.5060601@antacs.com> <20090707144851.GA2768@tuxdriver.com>
	<43e72e890907070915y5fd131b7l6aa845a0785f8c76@mail.gmail.com>
	<4A544B15.8030106@mrs.ro> <20090708125727.GC4253@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 8 Jul 2009 10:10:34 -0700
Message-ID: <43e72e890907081010v2d778dceub521f9f14c801800@mail.gmail.com>
Subject: Re: mac80211 and broadcast frames
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Valentin Manea <linux-wireless@mrs.ro>,
	David Ross <dave@antacs.com>, linux-wireless@vger.kernel.org,
	"Jouni.Malinen" <Jouni.Malinen@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 8, 2009 at 5:57 AM, John W. Linville<linville@tuxdriver.com> wrote:
> On Wed, Jul 08, 2009 at 10:30:29AM +0300, Valentin Manea wrote:
>>
>>
>> On 07/07/2009 07:15 PM, Luis R. Rodriguez wrote:
>>> On Tue, Jul 7, 2009 at 7:48 AM, John W. Linville<linville@tuxdriver.com>  wrote:
>>>> On Tue, Jul 07, 2009 at 09:10:52PM +1000, David Ross wrote:
>>>>> Actually it is required to be a mutual BASIC rate (not extended rates) -
>>>>> not necessarily the "lowest possible" - David.
>>>> True, but FWIW I think all of our rate scaling algorithms choose the
>>>> lowest rate.
>>>
>>> And then iwlwifi and ath9k have their own rate control algo, and at
>>> least ath9k uses the lowest valid rate IIRC.
>>>
>>>    Luis
>>
>>
>>   I've found the code in ath9k and you are right, it always chooses the
>> lowest rate.
>>   So, basically to transmit multicast frames at a better bitrate I have
>> to hack the rate control algorithm, right?
>
> Yes.  Feel free to suggest patches for all of the available (i.e. both
> generic and device-dependent) algorithms as well.

BTW all this code is very generic between all drivers right now. The
rate control patches I sent a while back generalize all this and add
*one helper* routine which is used by all drivers for figuring the
rate for broadcasts. Once those patches are applied you can then just
focus on improving that one helper and then *every* driver will
benefit from your work.

The reason for this being a common helper instead of just embedded
directly into mac80211 was that in the future some rate control
algorithms may want to user higher rates for broadcast later. If there
is a way to make this generic and still use a higher rate the generic
helper can be extended. If rate control algorithms disagree with that
implementation or want to change it they can simply drop the helper
and implement their own solution.

  Luis
