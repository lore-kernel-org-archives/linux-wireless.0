Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yb1-f196.google.com ([209.85.219.196]:35114 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbeIJWWr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Sep 2018 18:22:47 -0400
Received: by mail-yb1-f196.google.com with SMTP id o17-v6so8260763yba.2
        for <linux-wireless@vger.kernel.org>; Mon, 10 Sep 2018 10:27:39 -0700 (PDT)
MIME-Version: 1.0
References: <4922c981d88ab8b16d6ebd130829b6c04d8bbc56.camel@mbuf.com>
In-Reply-To: <4922c981d88ab8b16d6ebd130829b6c04d8bbc56.camel@mbuf.com>
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Date: Mon, 10 Sep 2018 19:27:28 +0200
Message-ID: <CAA2SeNKshXx2e9z+iWf=pbM0SN0teT2cvnye4noEjBxtOo4Vvw@mail.gmail.com> (sfid-20180910_192955_991020_9FFB412B)
Subject: Re: desktop hard lock up (kernel panic) with Alfa AWUSB036ACM and
 wireless-testing 72d1e548defbf
To: davep@mbuf.com
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        dpoole@cradlepoint.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> Start wpa_supplicant
> Attach to a Cisco AP (haven't tried too many other APs yet). Desktop
> locks up hard.  I have some shell scripts I use start wpa_supp and run
> wpa_cli (I'm not going through the GNOME ui or other).
>
> (Occurs to me I need to verify I didn't have the system's
> wpa_supplicant running... I forget to kill the systemd started wpa_supp
> before starting mine.)
>
> Captured a kernel oops (attached) with netconsole. Same kernel with my
> 2nd wifi (an Intel 8265 PCI-e card) works.
>
> Running:
> git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-
> testing.git   72d1e548defbf75c6bb42fc99276cd88fda7dda0
>
>
> I can 'iw dev scan' & scan through wpa_supplicant with the card fairly
> successfully. I haven't tried monitor mode. Have recreated the oops a
> couple times.
>
>
> Alfa AWUSB036ACM
>

Hi David,

according to the kernel log you provided the crash occurs in
ieee80211_wake_txqs().
Could you please run gdb in order to identify the point where NULL
pointer dereference occurs? E.g:

$gdb mac80211.ko
$info address ieee80211_wake_txqs
$l*(<func addr>+<offset>)
offset is 0x1e3 in your log

Regards,
Lorenzo
