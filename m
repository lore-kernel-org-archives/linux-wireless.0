Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44155 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796Ab1ECGS1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 02:18:27 -0400
Received: by gyd10 with SMTP id 10so2133839gyd.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 May 2011 23:18:27 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <861v0igqhn.fsf@coulee.tdb.com>
References: <861v0igqhn.fsf@coulee.tdb.com>
Date: Tue, 3 May 2011 14:18:25 +0800
Message-ID: <BANLkTi=mK9dh5AAQtqKVWvTjXfLS-y=7Ng@mail.gmail.com> (sfid-20110503_081831_119700_A317B1B5)
Subject: Re: kernel panic on MIPS + ath5k + Wistron CM9 radio
From: Adrian Chadd <adrian@freebsd.org>
To: Russell Senior <seniorr@aracnet.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Well, I see the same on FreeBSD/MIPS whenever an Atheros device is
fondled incorrectly. Either because the chip isn't yet fully awake or
the register plainly doesn't exist.

See if you can add some debugging in ath5k_hw_reset_tx_queue() to see
which register is being read/written before the PCI bus error occurs.

I have that hardware (routerstation/rspro) and the CM-9 card but I
don't currently have any spare time to run it up and test, sorry.


Adrian

On 2 May 2011 03:39, Russell Senior <seniorr@aracnet.com> wrote:
>
> Recently trying to abandon madwifi for good on some embedded devices
> with OpenWrt, encountered kernel panics.  Same radio on an x86
> platform (Soekris net4826), no kernel panic.  Different atheros radio,
> no kernel panic.  Tried two different MIPS boards (Netgear WGT634U and
> Ubiquiti RouterStation), both panic'd.
>
> Netgear WGT634U:  http://pastebin.ca/2051127
> Ubiquiti RouterStation: http://pastebin.ca/2052610
>
> Both cases were firmwares built from r26771 of OpenWrt, and both seem
> to have panic'd from hostapd.  While researching this, I encountered a
> similar report from last June:
>
>  http://www.mail-archive.com/openwrt-users@lists.openwrt.org/msg01001.html
>  http://www.spinics.net/lists/linux-wireless/msg52502.html
>
> Another person reported some issues with the CM9 earlier this year in
> client mode:
>
>  http://permalink.gmane.org/gmane.linux.drivers.ath5k.devel/4722
>
> I am happy to do some leg work on getting this fixed, if someone can
> provide some guidance.  Thanks!
>
>
> --
> Russell Senior         ``I have nine fingers; you have ten.''
> seniorr@aracnet.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
