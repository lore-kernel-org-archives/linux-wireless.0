Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41445 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab0IIFta convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 01:49:30 -0400
Received: by qyk36 with SMTP id 36so5618210qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 22:49:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimTgYmdrytn6_wdx_7HVX20nurdsJ=OqiSoGJLs@mail.gmail.com>
References: <1283988329-44549-1-git-send-email-steve@cozybit.com>
	<1283988329-44549-6-git-send-email-steve@cozybit.com>
	<AANLkTimTgYmdrytn6_wdx_7HVX20nurdsJ=OqiSoGJLs@mail.gmail.com>
Date: Wed, 8 Sep 2010 22:49:29 -0700
Message-ID: <AANLkTikgQHk8OCMqd5VerKwG9J2p5R35=Q_YxoWGQa_v@mail.gmail.com>
Subject: Re: [PATCH 5/9] libertas_tf: Moved firmware loading to probe in order
 to fetch MAC address
From: Steve deRosier <steve@cozybit.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, javier@cozybit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 8, 2010 at 7:06 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
> More nits:
>
>
> Are these changes really necessary here? - It'd probably be cleaner to
> change the initial functions to just take the card struct instead? (as
> it's always available as priv->card)
>
> I'm guessing you're going to do something with the _* versions of
> these functions later, so should this change be there instead?
>

Yes, these changes are necessary.  The enable and disable interrupt
calls are called both from main.c as well as sdio.c.  main.c has
access to and needs to call with a priv, while at least one of the
calls from sdio.c happens before priv exists.  I could have changed
the stuff in main.c to call with priv->card, but alas at the time I
was still trying to minimize structural changes main.c and avoiding
changes to the USB driver.

>> @@ -187,7 +201,6 @@ static int if_sdio_handle_cmd(struct if_sdio_card *card,
>>        struct lbtf_private *priv = card->priv;
>>        int ret;
>>        unsigned long flags;
>> -       u8 i;
>>
>>        lbtf_deb_enter(LBTF_DEB_SDIO);
>>
>
> Shouldn't this be elsewhere (maybe rolled into patch #1?)
>

It could be, but I didn't do this cleanup till now, some 20 commits
later.  Not that easy to pick and choose which lines from an atomic
commit go to which patch some weeks later.

>> @@ -709,7 +726,6 @@ static int if_sdio_prog_firmware(struct if_sdio_card *card)
>>                if( lbtf_reset_fw == 0 ) {
>>                        goto success;
>>                } else {
>> -                       int i = 0;
>>                        lbtf_deb_sdio("attempting to reset and reload firmware\n");
>>
>>                        if_sdio_reset_device(card);
>
> Ditto.
Ditto.  And so on...

>> diff --git a/drivers/net/wireless/libertas_tf/main.c b/drivers/net/wireless/libertas_tf/main.c
>> index 119d625..14ce1bc 100644
>> --- a/drivers/net/wireless/libertas_tf/main.c
>> +++ b/drivers/net/wireless/libertas_tf/main.c
>> @@ -150,14 +150,15 @@ static int lbtf_setup_firmware(struct lbtf_private *priv)
>>        int ret = -1;
>>
>>        lbtf_deb_enter(LBTF_DEB_FW);
>> +
>>        /*
>>         * Read priv address from HW
>>         */
>>        memset(priv->current_addr, 0xff, ETH_ALEN);
>>        ret = lbtf_update_hw_spec(priv);
>>        if (ret) {
>> -               ret = -1;
>> -               goto done;
>> +                  ret = -1;
>> +                  goto done;
>>        }
>>
>>        lbtf_set_mac_control(priv);
>
> Whitespace change noise.

Well, perhaps.  On the other hand, it made it more readable to me (the
first one, the newline.  The indentation change is actually incorrect,
no doubt about it).  Have you ever worked with a codebase for 3 some
months and not incidentally or accidentally changed some whitespace?
If this patch was just to change whitespace, then I'd agree with you
and wouldn't have wasted time bothering to submit it, but the patch as
a whole adds necessary functionality.

If you want me to fix the whitespace, I can.

Thanks,
- Steve
