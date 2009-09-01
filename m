Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:45188 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202AbZIAVlU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Sep 2009 17:41:20 -0400
Received: by fg-out-1718.google.com with SMTP id 22so214976fge.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 Sep 2009 14:41:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A9D7E79.6090000@csail.mit.edu>
References: <4A9D7E79.6090000@csail.mit.edu>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Tue, 1 Sep 2009 23:41:02 +0200
Message-ID: <69e28c910909011441l411bc8a1xcc968ce8c220b422@mail.gmail.com>
Subject: Re: phy0: release an RX reorder frame due to timeout on earlier
	frames
To: Michael Kaminsky <kaminsky@csail.mit.edu>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 1, 2009 at 10:05 PM, Michael Kaminsky<kaminsky@csail.mit.edu> wrote:
> I'm running a git checkout of iwlwifi-2.6.git from around Aug. 10
> (d229b68..).  I filed a bug report at
>
>  http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2076
>
> and I was asked to post my situation to this list.
>
> I'm seeing regular "outages" when using 11n where no packets seem to go
> through (card is an Intel 5300).  When this happens, I see the following
> in my dmesg output:
>
>  phy0: release an RX reorder frame due to timeout on earlier frames
>
> (To see this message, you need to compile with CONFIG_MAC80211_HT_DEBUG.
> The message comes from net/mac80211/rx.c.)
>
> There's dmesg log attached to the above bug report which gives a
> high-level picture (no extra debugging) of what happens.  I associate
> (with HT), things work for a little while, and then this message is
> printed out (at which point the network stops working).  If I manually
> re-associate, things work again.  If I do nothing, eventually the driver
> re-associates by itself, and things also work again.  Letting the driver
> re-associate automatically, though, can take a while (e.g, sometimes
> close to a minute).  Note that in my environment, there are multiple APs
> serving the same ESSID.  This error seems to happen quite regularly.
>
> Thanks,
>
> Michael
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Try also enabling iwlwifi debugging - enable CONFIG_IWLWIFI_DEBUG,
then load iwlagn with modparam "debug=0x43fff".

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
