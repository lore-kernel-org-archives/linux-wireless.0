Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:62070 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbaDGFAV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Apr 2014 01:00:21 -0400
Received: by mail-la0-f49.google.com with SMTP id mc6so4281282lab.36
        for <linux-wireless@vger.kernel.org>; Sun, 06 Apr 2014 22:00:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140407003648.GA19740@earth.li>
References: <20140407003648.GA19740@earth.li>
Date: Mon, 7 Apr 2014 08:00:19 +0300
Message-ID: <CANUX_P3H=F1C1H6NvdvpTHQh1JqvPjvyUjAygSQgeNyZ-q6=ZQ@mail.gmail.com> (sfid-20140407_070025_542927_949ADE3B)
Subject: Re: Intel 7260 not working in 802.11n mode
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Jonathan McDowell <noodles@earth.li>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Intel Linux Wireless <ilw@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,


On Mon, Apr 7, 2014 at 3:36 AM, Jonathan McDowell <noodles@earth.li> wrote:
> Hi.
>
> I have an Intel 7260 that fails to associate correctly in 802.11n mode.
> Unfortunately I don't have any access to the AP in question, but I
> believe it is an ASUS based device. This is on the 5GHz band; there is
> some odd configuration with the router that results in the driver
> refusing to associate on the 2.4GHz setup with the following error:
>
> [  507.495986] iwlwifi 0000:02:00.0: AP 30:00:da:b1:da:d0 beacon interval is 7, refusing due to firmware bug!

Ok - this is an interesting settings.
I'll check with our firmware team what can be done here, but beacon
interval=7 is really insane. I can't find what the spec defines as
legal values right now.

>
> On the 5GHz band the driver attempts to associate, but never seems to
> actually fully associate to the point of getting an IP. If I pass the
> 11n_disable=1 parameter to the driver then things work fine.
>

This is surprising - can you share your logs?

> I've put a debug log of the failure to associate (kernel 3.14 but this
> has happened with all the version I've tried) up at:
>
> http://the.earth.li/~noodles/iwlwifi-fail.log
>

I can't access: Access forbidden.

> If there is more information I should be providing please let me know.
> I'm sure it's related to the AP in question as I've had successful 11n
> associations with other setups, but it's annoying to have to explicitly
> disable 11n when in this location and then not in others.
>
