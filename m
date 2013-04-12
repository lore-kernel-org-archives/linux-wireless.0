Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f48.google.com ([209.85.212.48]:41021 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229Ab3DLUew (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Apr 2013 16:34:52 -0400
Received: by mail-vb0-f48.google.com with SMTP id p13so2448582vbe.35
        for <linux-wireless@vger.kernel.org>; Fri, 12 Apr 2013 13:34:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKKzdA1+HyU+-EyMRru4AqMQRkhhZvbTCDVZOn_edc+DZKoTkQ@mail.gmail.com>
References: <CAKKzdA1+HyU+-EyMRru4AqMQRkhhZvbTCDVZOn_edc+DZKoTkQ@mail.gmail.com>
Date: Fri, 12 Apr 2013 13:34:51 -0700
Message-ID: <CA++WF2NfyNxq6guc=R=k3JtnAgyUmMMFrLw7bCdH0Bx+GMikdQ@mail.gmail.com> (sfid-20130412_223456_931995_7EE4A504)
Subject: Re: driver IPW2200 of gentoo 3.7.10 kernel
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: Peter van Toorn <pvantoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Peter,

On 12 April 2013 05:26, Peter van Toorn <pvantoorn@gmail.com> wrote:
>
> Dear Stas
>
> I found your name and email on the "MAINTAINERS"of the linux-3.7.10-gentoo
> kernel
>
> I have an old laptop which needs the IPW2200 module.
>
> I encounter two problems:
> 1) via the menuconfig I am unable to set the IPW2200 module, although
> instructions are given
> via the help info how to do. So I cannot turn on the "module"option for
> the driver via the GUI of
> menuconfig
>
> 2) Worse, the CONFIG_IP2200 option is not present in the .config file. So
> the ability
> to set the IP2200 driver is not available.
>
> Is this a temporarily bug only for this version of linux, or is support
> for this driver stopped.
>
> A newer version of linux will fix the problem???
>
> I have an operational system using kernel 3.5.7
>
> Any idea?

CONFIG_IPW2200 option depends on CFG80211_EXT which is not enabled by
default any more.

So you need to enable CFG80211_EXT first. You can do this via 'make menuconfig'.

[*] Networking support --->
-*- Wireless --->
<*> cfg80211 - wireless configuration API
[*] cfg80211 wireless extension compatability

Than you can enable IPW2200 as usual.

Stanislav.
