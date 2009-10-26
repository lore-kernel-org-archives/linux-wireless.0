Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:52981 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470AbZJZQiM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 12:38:12 -0400
Received: by iwn10 with SMTP id 10so6066816iwn.4
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2009 09:38:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <200910261729.38199.mb@bu3sch.de>
References: <1256567941-26859-1-git-send-email-lrodriguez@atheros.com>
	<87hbtmgmj6.fsf@purkki.valot.fi> <43e72e890910260921h91c4cb5u5a2fc81e73377055@mail.gmail.com>
	<200910261729.38199.mb@bu3sch.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 26 Oct 2009 09:37:56 -0700
Message-ID: <43e72e890910260937v571e7b56h2453c5735f129f1b@mail.gmail.com>
Subject: Re: [PATCH 2/4] ath9k_hw: distinguish single-chip solutions on
	initial probe print
To: Michael Buesch <mb@bu3sch.de>
Cc: Kalle Valo <kalle.valo@iki.fi>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 26, 2009 at 9:29 AM, Michael Buesch <mb@bu3sch.de> wrote:
> On Monday 26 October 2009 17:21:40 Luis R. Rodriguez wrote:
>> >> --- a/drivers/net/wireless/ath/ath9k/pci.c
>> >> +++ b/drivers/net/wireless/ath/ath9k/pci.c
>> >> @@ -114,6 +114,7 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>> >>       u32 val;
>> >>       int ret = 0;
>> >>       struct ath_hw *ah;
>> >> +     char hw_name[1024];
>> >
>> > Ditto.
>>
>> We use this for debugfs, so I went with that as an upper limit, given
>> that we just use it a probe it seemed sane.
>
> I think it's completely insane, because you effectively use 25% of the available stack.
> Why is a hardware name 1024 chars (max) long anyway?
>
> xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
> xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
> xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
> xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
> xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
> xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
> xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
> xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
> xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
> xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
> xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
> xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
> xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
> xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
>
> I would be pissed off after reading the first line already ;)

Heh alright, I'll go reduce this, thanks.

  Luis
