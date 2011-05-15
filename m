Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:44846 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756507Ab1EOPYC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 May 2011 11:24:02 -0400
Received: by qwk3 with SMTP id 3so1905085qwk.19
        for <linux-wireless@vger.kernel.org>; Sun, 15 May 2011 08:24:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1305277744.3487.8.camel@jlt3.sipsolutions.net>
References: <1305277744.3487.8.camel@jlt3.sipsolutions.net>
Date: Sun, 15 May 2011 17:24:00 +0200
Message-ID: <BANLkTin096zXTpmvNoUj_zJLOmnr3Ft7fQ@mail.gmail.com> (sfid-20110515_172408_455167_81BCD2EF)
Subject: Re: [RFC] rt2x00: advertise interface combinations
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Fri, May 13, 2011 at 11:09 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Make rt2x00 advertise that it potentially supports
> more than one AP interface.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> I don't have any rt2x00 HW so this is completely untested. It compiles
> though ;-)
>
>  drivers/net/wireless/rt2x00/rt2x00.h    |    6 ++++++
>  drivers/net/wireless/rt2x00/rt2x00dev.c |   19 +++++++++++++++++++
>  2 files changed, 25 insertions(+)
>
> --- a/drivers/net/wireless/rt2x00/rt2x00.h      2011-05-13 11:02:38.000000000 +0200
> +++ b/drivers/net/wireless/rt2x00/rt2x00.h      2011-05-13 11:03:28.000000000 +0200
> @@ -960,6 +960,12 @@ struct rt2x00_dev {
>         * Protect the interrupt mask register.
>         */
>        spinlock_t irqmask_lock;
> +
> +       /*
> +        * Interface combinations
> +        */
> +       struct ieee80211_iface_limit ap_limit;
> +       struct ieee80211_iface_combination ap_combination;
>  };
>
>  /*
> --- a/drivers/net/wireless/rt2x00/rt2x00dev.c   2011-05-13 11:00:28.000000000 +0200
> +++ b/drivers/net/wireless/rt2x00/rt2x00dev.c   2011-05-13 11:08:04.000000000 +0200
> @@ -942,6 +942,25 @@ static int rt2x00lib_probe_hw(struct rt2
>  #undef RT2X00_TASKLET_INIT
>
>        /*
> +        * Initialise supported virtual interface combinations
> +        *
> +        * Since currently, max_sta_intf is always 1, ignore it.
> +        */
> +       WARN_ON(rt2x00dev->ops->max_sta_intf != 1);

I don't think this WARN_ON will be needed, but with this entire patch,
I think that our own code for checking the interface limitations are no
longer needed. But I will clean that up later in a separate patch.
So for now:

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
