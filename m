Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:51507 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaFWM7n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2014 08:59:43 -0400
Received: by mail-wi0-f171.google.com with SMTP id n15so4287056wiw.16
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jun 2014 05:59:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1403526767.4418.24.camel@jlt4.sipsolutions.net>
References: <1400767955-16313-1-git-send-email-michal.kazior@tieto.com>
	<1400767955-16313-3-git-send-email-michal.kazior@tieto.com>
	<1400769683.4174.25.camel@jlt4.sipsolutions.net>
	<CA+BoTQk=DU=-HzVo-XsQTpCt6CS7aXxQMy5hTyQ7qC56ebBLZQ@mail.gmail.com>
	<1403524278.4418.19.camel@jlt4.sipsolutions.net>
	<CA+BoTQ=fpkOZXVgJt-OWdgSFX1_sO1g1E=J-7NnOb+e6a30FVA@mail.gmail.com>
	<1403526767.4418.24.camel@jlt4.sipsolutions.net>
Date: Mon, 23 Jun 2014 14:59:42 +0200
Message-ID: <CA+BoTQnvRgfObtvJcVj3np6LSRSHr_2uEfqRpOw59fuy88xnYQ@mail.gmail.com> (sfid-20140623_145947_390503_764913B9)
Subject: Re: [PATCH 2/2] ath10k: make core registering async
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 23 June 2014 14:32, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2014-06-23 at 14:17 +0200, Michal Kazior wrote:
>
>> > Seems like to fix it we just need to get a module reference though? Can
>> > a module put() itself though? Hmmm.
>>
>> It seems some drivers use module_put(THIS_MODULE) and
>> __module_get(THIS_MODULE), e.g. tun/tap driver.
>
> I don't see how this isn't racy in similar ways though?

I think tun/tap uses it for different purposes.


>> But does this bump up the module refcount in such a way that an
>> in-progress rmmod will wait/block until the refcount reaches 0?
>
> It should, yes, but you race once you do module_put(), no?

It's still racy, I agree.

I don't see how device_release_driver() can be made work synchronously
at all. It should, however, be perfectly fine if this was an async
request to release a device/driver, right?


Michał
