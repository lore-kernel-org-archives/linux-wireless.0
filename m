Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754079Ab3I3Nzn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Sep 2013 09:55:43 -0400
Message-ID: <1380549653.6136.4.camel@dcbw.foobar.com> (sfid-20130930_155546_844074_A3762ED7)
Subject: Re: NetworkManager not connecting anymore
From: Dan Williams <dcbw@redhat.com>
To: Arend van Spriel <aspriel@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 30 Sep 2013 09:00:53 -0500
In-Reply-To: <CAJ65rDzRUZcZG5+iz2TeQLW7YS+T5xD+M-BxpJp23N=W4dn1+g@mail.gmail.com>
References: <CAJ65rDzRUZcZG5+iz2TeQLW7YS+T5xD+M-BxpJp23N=W4dn1+g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2013-09-29 at 11:11 +0200, Arend van Spriel wrote:
> With a recent update on my Ubuntu 12.10 laptop, wireless connection is no
> longer working with NetworkManager. It is working when using wpa_supplicant
> directly. The nm-applet indicates 'device not ready' for the Wireless
> Networks. Attached is the syslog upon inserting the wireless driver module,
> which is brcmsmac. Not sure if the state change below correlates to the
> nm-applet status.
> 
> NetworkManager[1121]: <info> (wlan0): device state change: unmanaged ->
> unavailable (reason 'managed') [10 20 2]

'unavailable' could mean a couple things:

1) supplicant isn't running or can't be contacted via D-Bus
2) rfkill is blocking wifi
3) the driver returned ENOENT in response to the dev_open() call,
indicating that it does not have any firmware available

The logs you've posted don't look complete; do you get *anything* else
shown?  You can also:

killall -TERM NetworkManager
NetworkManager --no-daemon --log-level=debug

to get more information.

Let me know,
Dan

