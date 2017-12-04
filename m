Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:32877 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751982AbdLDW3F (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Dec 2017 17:29:05 -0500
Received: by mail-ot0-f195.google.com with SMTP id h9so16210272oti.0
        for <linux-wireless@vger.kernel.org>; Mon, 04 Dec 2017 14:29:04 -0800 (PST)
Subject: Re: [PATCH] rtl8187: add master mode
To: Gabriele Gristina <gabriele.gristina@gmail.com>
Cc: Hin-Tak Leung <htl10@users.sourceforge.net>,
        Herton Ronaldo Krzesinski <herton@canonical.com>,
        linux-wireless@vger.kernel.org
References: <1990723570.2726060.1512424959242.ref@mail.yahoo.com>
 <1990723570.2726060.1512424959242@mail.yahoo.com>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <12302480-a14d-d542-d3b3-50e69664a8d6@lwfinger.net> (sfid-20171204_232908_887147_9B4D6572)
Date: Mon, 4 Dec 2017 16:29:03 -0600
MIME-Version: 1.0
In-Reply-To: <1990723570.2726060.1512424959242@mail.yahoo.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/04/2017 04:02 PM, Hin-Tak Leung wrote:
> --------------------------------------------
> On Mon, 4/12/17, Gabriele Gristina <gabriele.gristina@gmail.com> wrote:
>   
>> I use these few
>> byte from years and hostapd work like a charm.I
>> don't understand why you write "completely
>> wrong" but you are free to refuse this
>> patch.
>> Have a nice
>> day,Gabriele
> 
> I think the issue was to do with hardware support of certain features - power-management (allowing the clients to sleep) and maintaining states across low-power states, and somewhat large number of clients. That it can work to some extent, and even to a very good extent, to serve a small number of clients - at full power, without power managrment - is not a surprise.
> 
> My impression that software (i.e. non-hardware) support was to improve to make it possible. Larry and others can comment on the current state.

Gabriele,

I agree that merely informing mac80211 that you support AP mode is unlikely to 
provide full support for master mode, but I have not looked at that code for 
many years.

If you can show that your "fix" does support many clients, and that it does not 
go belly-up when one of them tries to go to low power, then I will agree to 
merge your patch. Until then, merging it now would suggest that we are offering 
a service that the driver does not really support.

BTW, why are you trying to create an AP with a 802.11G device? The performance 
will be on par with what was expected 10 or 12 years ago.

Larry
