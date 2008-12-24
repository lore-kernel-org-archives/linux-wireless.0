Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f13.google.com ([209.85.217.13]:64561 "EHLO
	mail-gx0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbYLXRpq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2008 12:45:46 -0500
Received: by gxk6 with SMTP id 6so2638477gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 24 Dec 2008 09:45:45 -0800 (PST)
Message-ID: <43e72e890812240945x69dd771fs86eb15a3b34a1545@mail.gmail.com> (sfid-20081224_184549_929514_02F725B6)
Date: Wed, 24 Dec 2008 09:45:44 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "W. van den Akker" <listsrv@wilsoft.nl>
Subject: Re: Still problems to get ath9k in accessmode. Kernel hangs
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200812241040.39056.listsrv@wilsoft.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200812241040.39056.listsrv@wilsoft.nl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 24, 2008 at 1:40 AM, W. van den Akker <listsrv@wilsoft.nl> wrote:
> Hi,
>
> I have tested with the latest kernel 2.6.27.10 and compat-wireless 22-12-2008.
> I have a dual core system (Intel(R) Pentium(R) 4 CPU 3.00GHz) and use hostapd
> 0.6.6.
>
> I have build the kernel, compiled the compat-wireless and did a make install.
> Make unload didnt work because some drivers were in use (mac80211).

After it fails to unload do

lsmod | grep mac80211

to see which ones are still loaded and depending on mac80211.

> First problem arises, a rmmod ath9k hangs the kernel. No message of what so
> ever in the log or to stdout.

Please do:

modprobe -l ath9k
modprobe -l mac80211

To ensure the right drivers are loaded.

lsmod | grep mac80211
lsmod | grep ath

  Luis
