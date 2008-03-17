Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.178]:26296 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbYCQRMO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 13:12:14 -0400
Received: by py-out-1112.google.com with SMTP id u52so7843309pyb.10
        for <linux-wireless@vger.kernel.org>; Mon, 17 Mar 2008 10:12:14 -0700 (PDT)
Message-ID: <43e72e890803171012h1b6fdfc5wabf5c1c39176ebcd@mail.gmail.com> (sfid-20080317_171218_472685_4127BE22)
Date: Mon, 17 Mar 2008 13:12:13 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Franz Apeltauer" <franz.apeltauer@gmx.at>
Subject: Re: 2 compile errors: rt2x00firmware.c and mesh.c
Cc: "Ivo van Doorn" <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <47DC6ABF.5040309@gmx.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <47CB3B5E.4020701@gmx.at> <200803112322.45274.IvDoorn@gmail.com>
	 <47D70F5C.7020208@gmx.at> <200803120009.15002.IvDoorn@gmail.com>
	 <47DC6ABF.5040309@gmx.at>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 15, 2008 at 8:33 PM, Franz Apeltauer <franz.apeltauer@gmx.at> wrote:
> Ivo van Doorn schrieb:
>
> > Hmm, thats odd. It should at least support adhoc.
>  > (Master mode depends on mac80211, regular mac80211 versions found
>  > in the kernel don't support it yet, and they need patches from
>  > Johannes Berg).
>  >
>  > Does 'dmesg' indicate anything?
>  >
>
>  Loaded the current tarball.
>  There are not many error or warning messages in dmeg output anymore.
>  Like before I found "ADDRCONF(NETDEV_UP): wlan0: link is not ready"
>  but I thought, that this probably tells me, that it could not "see" any
>  access point (which is true).

This message comes out when your device has no queue dicipline
attached to it yet. For new wireless drivers (mac80211) this pops up
when you are not associated as you have no communication link
established yet.

>  dmesg output etc. is attached.
>
>  It seems, that ad-hoc is not needed by many people. And for me wlan is
>  nice to have, not a must. So, I do not want to waste your time any
>  longer to get this 'special' case runnning.
>
>  Thank you all very much for your help!
>  Franz
>
> # make load

You can avoid using make load by just doing:

make unload
modprobe foo

where foo is the wireless module you *know* you need.

  Luis
