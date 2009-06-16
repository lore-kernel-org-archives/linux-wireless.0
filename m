Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:47965 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751755AbZFPUJn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 16:09:43 -0400
Received: by gxk10 with SMTP id 10so8155374gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2009 13:09:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1245182222.28992.19.camel@130.81.190.10.in-addr.arpa>
References: <1245104960-2199-1-git-send-email-andrey@cozybit.com>
	 <1245182222.28992.19.camel@130.81.190.10.in-addr.arpa>
Date: Tue, 16 Jun 2009 13:09:45 -0700
Message-ID: <45e8e6c40906161309t27825adchc6d281a8be7ae33f@mail.gmail.com>
Subject: Re: [PATCH] libertas: Fix interface driver unload with PS mode
From: Andrey Yurovsky <andrey@cozybit.com>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 16, 2009 at 12:57 PM, Dan Williams<dcbw@redhat.com> wrote:
> On Mon, 2009-06-15 at 15:29 -0700, Andrey Yurovsky wrote:
>> When IEEE PS mode is enabled, lbs_remove_card needs to exit PS mode
>> before returning.  It will then set surpriseremoved=1, which blocks any
>> further attempts to issue commands.  In the SDIO, SPI, and USB drivers,
>> lbs_remove_card is called with surpriseremoved already set, which makes
>> it impossible to exit PS mode.  As a result, reloading the driver while
>> PS mode is enabled does not work.
>>
>> This patch removes the setting of surpriseremoved in the interface
>> drivers and corrects the order in which lbs_stop_card and
>> lbs_remove_card are called.  Tested on SPI with V9 firmware.
>
> Makes me a bit nervious; any chance you can test with usb8388 or SDIO
> firmware and hot-unplug or rmmod?


I'll comment on these separately:

- For USB, we hit the case where if_usb.c doesn't like the response
for CMD_802_11_FW_WAKE_METHOD and therefore decides that PS mode isn't
supported even though it is.  I suspect the IEEE PS would work
otherwise but I haven't had a chance to try it and I don't want to
cause a regression for whoever needed this wake-method check unless
it's really irrelevant.
- I've tested with SDIO, however reloading the module doesn't work due
to the other known issues being discussed and I don't have an '8688 to
try where it might work.  That said, with this patch SDIO does the
right thing in turning off IEEE PS, so I should have said that it has
been tested on SDIO as well.  On SPI I can also say that I can then
load the driver again and things work properly.

The setting of surpriseremoved=1 before calling lbs_remove_card is
wrong regardless because lbs_remove_card is then unable to actually
send commands.

 -Andrey

>> Signed-off-by: Andrey Yurovsky <andrey@cozybit.com>
>> ---
>>  drivers/net/wireless/libertas/if_sdio.c |    2 --
>>  drivers/net/wireless/libertas/if_spi.c  |    4 ++--
>>  drivers/net/wireless/libertas/if_usb.c  |    1 -
>>  3 files changed, 2 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/wireless/libertas/if_sdio.c b/drivers/net/wireless/libertas/if_sdio.c
>> index 8cdb88c..6bb95ce 100644
>> --- a/drivers/net/wireless/libertas/if_sdio.c
>> +++ b/drivers/net/wireless/libertas/if_sdio.c
>> @@ -1096,8 +1096,6 @@ static void if_sdio_remove(struct sdio_func *func)
>>                       lbs_pr_alert("CMD_FUNC_SHUTDOWN cmd failed\n");
>>       }
>>
>> -     card->priv->surpriseremoved = 1;
>> -
>>       lbs_deb_sdio("call remove card\n");
>>       lbs_stop_card(card->priv);
>>       lbs_remove_card(card->priv);
>> diff --git a/drivers/net/wireless/libertas/if_spi.c b/drivers/net/wireless/libertas/if_spi.c
>> index 923ed58..757352c 100644
>> --- a/drivers/net/wireless/libertas/if_spi.c
>> +++ b/drivers/net/wireless/libertas/if_spi.c
>> @@ -1171,12 +1171,12 @@ static int __devexit libertas_spi_remove(struct spi_device *spi)
>>
>>       lbs_deb_spi("libertas_spi_remove\n");
>>       lbs_deb_enter(LBS_DEB_SPI);
>> -     priv->surpriseremoved = 1;
>>
>>       lbs_stop_card(priv);
>> +     lbs_remove_card(priv); /* will call free_netdev */
>> +
>>       free_irq(spi->irq, card);
>>       if_spi_terminate_spi_thread(card);
>> -     lbs_remove_card(priv); /* will call free_netdev */
>>       if (card->pdata->teardown)
>>               card->pdata->teardown(spi);
>>       free_if_spi_card(card);
>> diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
>> index ea3dc03..7e03f0e 100644
>> --- a/drivers/net/wireless/libertas/if_usb.c
>> +++ b/drivers/net/wireless/libertas/if_usb.c
>> @@ -357,7 +357,6 @@ static void if_usb_disconnect(struct usb_interface *intf)
>>       cardp->surprise_removed = 1;
>>
>>       if (priv) {
>> -             priv->surpriseremoved = 1;
>>               lbs_stop_card(priv);
>>               lbs_remove_card(priv);
>>       }
>
>
