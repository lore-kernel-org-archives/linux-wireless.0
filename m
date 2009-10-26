Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:64763 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbZJZQVz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 12:21:55 -0400
Received: by iwn10 with SMTP id 10so6056077iwn.4
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2009 09:22:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87hbtmgmj6.fsf@purkki.valot.fi>
References: <1256567941-26859-1-git-send-email-lrodriguez@atheros.com>
	<1256567941-26859-3-git-send-email-lrodriguez@atheros.com>
	<87hbtmgmj6.fsf@purkki.valot.fi>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 26 Oct 2009 09:21:40 -0700
Message-ID: <43e72e890910260921h91c4cb5u5a2fc81e73377055@mail.gmail.com>
Subject: Re: [PATCH 2/4] ath9k_hw: distinguish single-chip solutions on
	initial probe print
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 26, 2009 at 9:14 AM, Kalle Valo <kalle.valo@iki.fi> wrote:
> "Luis R. Rodriguez" <lrodriguez@atheros.com> writes:
>
>> Devices with external radios have revisions which we can count on.
>> On single chip solutions these EEPROM values for these radio revision
>> also exist but are not meaningful as the radios are embedded onto the
>> same chip. Each single-chip device evolves together as one device.
>>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> ---
>>  drivers/net/wireless/ath/ath9k/ahb.c |   11 ++++-------
>>  drivers/net/wireless/ath/ath9k/hw.c  |   27 +++++++++++++++++++++++----
>>  drivers/net/wireless/ath/ath9k/hw.h  |    3 +--
>>  drivers/net/wireless/ath/ath9k/pci.c |   11 ++++-------
>>  4 files changed, 32 insertions(+), 20 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
>> index 41422c4..925818c 100644
>> --- a/drivers/net/wireless/ath/ath9k/ahb.c
>> +++ b/drivers/net/wireless/ath/ath9k/ahb.c
>> @@ -69,6 +69,7 @@ static int ath_ahb_probe(struct platform_device *pdev)
>>       int irq;
>>       int ret = 0;
>>       struct ath_hw *ah;
>> +     char hw_name[1024];
>
> This is a bit too large to allocate from stack IMHO.
>
>
> [...]
>
>> --- a/drivers/net/wireless/ath/ath9k/pci.c
>> +++ b/drivers/net/wireless/ath/ath9k/pci.c
>> @@ -114,6 +114,7 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>>       u32 val;
>>       int ret = 0;
>>       struct ath_hw *ah;
>> +     char hw_name[1024];
>
> Ditto.

We use this for debugfs, so I went with that as an upper limit, given
that we just use it a probe it seemed sane.

  Luis
