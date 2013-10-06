Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:53333 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab3JFFCY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Oct 2013 01:02:24 -0400
Received: by mail-la0-f42.google.com with SMTP id ep20so4511114lab.15
        for <linux-wireless@vger.kernel.org>; Sat, 05 Oct 2013 22:02:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAOAOC6YT=ek4S=s0YNqejD2iCdPYng6FnJ1ROegwWhmcVZhyOg@mail.gmail.com>
References: <CAOAOC6YT=ek4S=s0YNqejD2iCdPYng6FnJ1ROegwWhmcVZhyOg@mail.gmail.com>
Date: Sun, 6 Oct 2013 08:02:23 +0300
Message-ID: <CANUX_P25P2LwMwA3HRaxGBCkPsDTs6cOymkM5P+t7B8132CExA@mail.gmail.com> (sfid-20131006_070240_121173_73B853E5)
Subject: Re: pci-half-mini 7206 ac/bluetooth issues
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Tim Nelson <tim.l.nelson@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 6, 2013 at 4:49 AM, Tim Nelson <tim.l.nelson@gmail.com> wrote:
> If I use both the wifi and the bluetooth at the same time on the
> adapter eventually wifi dies.
>
> Here is a complete log from my syslog, I rmmod'd the iwlmvm and then
> modprobed it to resolve the issue.  This only happens when using
> wifi/bluetooth at the same time.
>

can you please try this:

modprobe bt_coex_active=0

and also (in a different test), can you please disable power save - add:
options iwlmvm power_scheme=1
to /etc/modprobe.d/iwlwifi.conf or something like that?

Thanks
