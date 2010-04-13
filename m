Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:38548 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752888Ab0DMWEA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Apr 2010 18:04:00 -0400
Received: by bwz19 with SMTP id 19so36141bwz.21
        for <linux-wireless@vger.kernel.org>; Tue, 13 Apr 2010 15:03:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <877hobnqs1.fsf@purkki.valot.fi>
References: <1271110918-18599-1-git-send-email-notasas@gmail.com>
	 <87k4sbnvgo.fsf@purkki.valot.fi>
	 <g2lb6c5339f1004131056v597857c0qf0da0dd093d6dbfa@mail.gmail.com>
	 <877hobnqs1.fsf@purkki.valot.fi>
Date: Wed, 14 Apr 2010 01:03:57 +0300
Message-ID: <i2u6ed0b2681004131503p4a584365j76a39f25ae395731@mail.gmail.com>
Subject: Re: [PATCH] wl1251: register platform_device to pass board data
From: Grazvydas Ignotas <notasas@gmail.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Bob Copeland <me@bobcopeland.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 13, 2010 at 7:55 PM, Kalle Valo <kvalo@adurom.com> wrote:
>> +struct wl12xx_platform_data *wl12xx_board_data;
>
> Shouldn't this be static? Also I assume that there is no way to
> allocate this dynamically, am I correct?

Yes, it should be static. Could not think if a way to avoid global
pointer though..

On Tue, Apr 13, 2010 at 9:36 PM, Kalle Valo <kvalo@adurom.com> wrote:
> Bob Copeland <me@bobcopeland.com> writes:
>
>> On Tue, Apr 13, 2010 at 12:55 PM, Kalle Valo <kvalo@adurom.com> wrote:
>>>> However there is no way to pass this data through SDIO subsystem, so
>>>> this patch registers dummy platform_device to allow that.
>>
>> No objection to the patch, platforms like android want this so
>> you can set the gpio for irq handling instead of using the
>> SDIO interrupts.
>
> I talked with TI about the interrupts. They say SDIO interrupt should
> not be used, instead we should always the external gpio line for the
> interrupt.

I've got some patches for this in the pipeline, just need a way to
pass platform_data..

>> But maybe we should invent a way to send it through the SDIO
>> subsystem?
>
> I agree, that is the best option.

Well there are even more problems with this particular chip as it's
missing essential SDIO registers like CIS and CCCR and can't even
probe without some additional kernel hacks..

>> My hope was that device trees on ARM would solve the issue
>> eventually.
>
> But no luck yet?

There is lot of talk but it's not there yet, and I'm not sure it will
suit this case even. I think we can use my hack for the time being.
