Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37422 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751307AbdABLMS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Jan 2017 06:12:18 -0500
Message-ID: <1483355533.4596.11.camel@sipsolutions.net> (sfid-20170102_121239_821112_5D7AEC4A)
Subject: Re: [PATCH v3] rfkill: Add rfkill-any LED trigger
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Micha=C5=82_K=C4=99pie=C5=84?= <kernel@kempniu.pl>,
        "David S . Miller" <davem@davemloft.net>
Cc: =?UTF-8?Q?=D0=9C=D0=B8=D1=85=D0=B0=D0=B8=D0=BB_?=
         =?UTF-8?Q?=D0=9A=D1=80=D0=B8=D0=BD=D0=BA=D0=B8=D0=BD?=
        <krinkin.m.u@gmail.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 02 Jan 2017 12:12:13 +0100
In-Reply-To: <20161221084533.27006-1-kernel@kempniu.pl> (sfid-20161221_094622_545524_B00A9AE7)
References: <20161221084533.27006-1-kernel@kempniu.pl>
         (sfid-20161221_094622_545524_B00A9AE7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>   - Handle the global mutex properly when rfkill_set_{hw,sw}_state()
> or
>     rfkill_set_states() is called from within an rfkill callback.  v2
>     always tried to lock the global mutex in such a case, which led
> to a
>     deadlock when an rfkill driver called one of the above functions
>     from its query or set_block callback.  This is solved by defining
> a
>     new bitfield, RFKILL_BLOCK_SW_HASLOCK, which is set before the
> above
>     callbacks are invoked and cleared afterwards; the functions
> listed
>     above use this bitfield to tell rfkill_any_led_trigger_event()
>     whether the global mutex is currently held or not.
>     RFKILL_BLOCK_SW_SETCALL cannot be reused for this purpose as
> setting
>     it before invoking the query callback would cause any calls to
>     rfkill_set_sw_state() made from within that callback to work on
>     RFKILL_BLOCK_SW_PREV instead of RFKILL_BLOCK_SW and thus change
> the
>     way rfkill_set_block() behaves.

I'm not super happy with this conditional locking - can't we instead
defer the necessary work to a workqueue, or so, for purposes of the
LED?

johannes
