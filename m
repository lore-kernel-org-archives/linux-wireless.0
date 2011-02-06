Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55007 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab1BFQR4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Feb 2011 11:17:56 -0500
Received: by qwa26 with SMTP id 26so2960355qwa.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Feb 2011 08:17:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20110131214515.GC6368@thinkpad-t410>
References: <20110131214515.GC6368@thinkpad-t410>
Date: Sun, 6 Feb 2011 17:17:55 +0100
Message-ID: <AANLkTikYS1EUdTc9mo2kvoR-S1Cv+WcKqkGaFDA8fR+0@mail.gmail.com>
Subject: Re: Missing skb_pad() return value checks in rt2x00 driver
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Wolfgang Kufner <wolfgang.kufner@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> I noticed that the skb_pad() calls it introduces are not being checked
> for failure. I don't know whether or not it's possible for these calls
> to fail in this context; would it make sense to incorporate the patch
> below?

The suggested change sounds good, however I'm a bit worried
about the relocation of the padding.

> --- a/drivers/net/wireless/rt2x00/rt2800lib.c
> +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
> @@ -776,6 +776,17 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
>        u32 reg;
>
>        /*
> +        * Pad out the beacon to a 32-bit boundary
> +        */
> +       padding_len = roundup(entry->skb->len, 4) - entry->skb->len;
> +       if (padding_len && skb_pad(entry->skb, padding_len)) {
> +               dev_err(rt2x00dev->dev, "Failure padding beacon, aborting\n");
> +               /* skb freed by skb_pad() on failure */
> +               entry->skb = NULL;
> +               return;
> +       }
> +
> +       /*
>         * Disable beaconing while we are reloading the beacon data,
>         * otherwise we might be sending out invalid data.
>         */
> @@ -809,8 +820,6 @@ void rt2800_write_beacon(struct queue_entry *entry, struct txentry_desc *txdesc)
>        /*
>         * Write entire beacon with TXWI and padding to register.
>         */
> -       padding_len = roundup(entry->skb->len, 4) - entry->skb->len;
> -       skb_pad(entry->skb, padding_len);
>        beacon_base = HW_BEACON_OFFSET(entry->entry_idx);
>        rt2800_register_multiwrite(rt2x00dev, beacon_base, entry->skb->data,
>                                   entry->skb->len + padding_len);

Between here and where you added the padding are a couple of function
calls which use the skb->len field. So this patch would change the value what
they expect. Have you checked the possible impact?

Ivo
