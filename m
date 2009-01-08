Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:65145 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567AbZAHRm2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2009 12:42:28 -0500
Received: by bwz14 with SMTP id 14so27681764bwz.13
        for <linux-wireless@vger.kernel.org>; Thu, 08 Jan 2009 09:42:26 -0800 (PST)
Message-ID: <314b98fa0901080942w67e16b0ex14bafac2d6d511d6@mail.gmail.com> (sfid-20090108_184233_460733_9499E50F)
Date: Thu, 8 Jan 2009 09:42:26 -0800
From: "Colin McCabe" <colin@cozybit.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: [PATCH v2 3/3] libertas: if_spi, driver for libertas GSPI devices
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	"Andrey Yurovsky" <andrey@cozybit.com>
In-Reply-To: <1231435046.21643.53.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1230951623-26998-1-git-send-email-colin@cozybit.com>
	 <1230951623-26998-2-git-send-email-colin@cozybit.com>
	 <1230951623-26998-3-git-send-email-colin@cozybit.com>
	 <1230951623-26998-4-git-send-email-colin@cozybit.com>
	 <1231435046.21643.53.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 8, 2009 at 9:17 AM, Dan Williams <dcbw@redhat.com> wrote:
> On Fri, 2009-01-02 at 19:00 -0800, Colin McCabe wrote:
>> Add initial support for libertas devices using a GSPI interface.  This has
>> been tested with the 8686.  At this time, as far as we know, GSPI firmware for
>> this device is not publicly distributable, but we expect this to change.
>>
>> GSPI is intended to be used on embedded systems. Board-specific parameters are
>> required (see libertas_spi.h).
>
> One thing we found we *really* wanted with SDIO was the ability to reset
> the card completely, is there any ability to do that with the SPI
> interface, or do you need to rely on board-specific methods to do that?

I've been looking at the SPU specification, and I can't see any way to
reset the whole module (i.e. power cycle) through the SPU.

>> +
>> +     /* Handles all SPI communication (except for FW load) */
>> +     struct task_struct              *spi_thread;
>> +     int                             run_thread;
>> +
>> +     /* Used to wake up the spi_thread */
>> +     struct semaphore                spi_ready;
>> +     struct semaphore                spi_thread_terminated;
>
> Are these really using semaphore semantics, or would a mutex be more
> appropriate here?  A ton of stuff got converted to mutexes a while back,
> so if you don't actually need the specific semaphore behavior mutexes
> might be a clearer choice.

We want semaphore semantics here, because (to quote mutex.c),
"Unlocking of a not locked mutex is not allowed."
This is important because an interrupt could come in just after
hw_host_to_card is called (for example).

>> +     int n, err = 0;
>> +     u16 zero = 0;
>> +     u16 reg_out = reg | IF_SPI_READ_OPERATION_MASK;
>> +
>> +     /* You must take an even number of bytes from the SPU, even if you
>> +      * don't care about the last one.  */
>> +     BUG_ON(len & 0x1);
>> +
>> +     spu_transaction_init(card);
>> +
>> +     /* write SPU register index */
>> +     err = spi_write(card->spi, (u8 *)&reg_out, sizeof(u16));
>> +     if (err)
>
> Do you really want 'goto out' here instead of 'return' so that
> spu_transaction_finish() gets called?

Hmm, good call.

>> +static int if_spi_calculate_fw_names(u16 card_id,
>> +                           char *helper_fw, char *main_fw)
>> +{
>> +     int i;
>> +     for (i = 0; i < ARRAY_SIZE(chip_id_to_device_name); ++i) {
>> +             if (card_id == chip_id_to_device_name[i].chip_id)
>> +                     break;
>> +     }
>> +     if (i == ARRAY_SIZE(chip_id_to_device_name)) {
>> +             lbs_pr_err("Unsupported chip_id: 0x%02x\n", card_id);
>> +             return -EAFNOSUPPORT;
>> +     }
>> +     snprintf(helper_fw, FIRMWARE_NAME_MAX, "spi%d_helper.bin",
>> +              chip_id_to_device_name[i].name);
>> +     snprintf(main_fw, FIRMWARE_NAME_MAX, "spi%d.bin",
>> +              chip_id_to_device_name[i].name);
>
> Could you look for firmware in the "libertas/" directory, and could we
> make the prefix of the firmware be "gspi" to match the actual Marvell
> firmware names?
>
> The firmware (at least for gspi8686) is in the process of getting pushed
> to the linux-firmware tree, and I'd like to consolidate libertas
> firmware into the libertas/ subdirectory for all libertas interface
> drivers.
>
> Dan

Ok, sounds good.

Colin
