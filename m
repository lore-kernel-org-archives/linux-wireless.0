Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40230 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027Ab2A2Vli (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jan 2012 16:41:38 -0500
Received: by ghrr11 with SMTP id r11so1495947ghr.19
        for <linux-wireless@vger.kernel.org>; Sun, 29 Jan 2012 13:41:37 -0800 (PST)
Message-ID: <4F25BD09.3060607@lwfinger.net> (sfid-20120129_224141_512840_7889DAC4)
Date: Sun, 29 Jan 2012 15:41:29 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: htl10@users.sourceforge.net
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>, herton@mandriva.com.br
Subject: Re: rtl8187 behavior change/breakage with 3.2.1-3.fc16.x86_64<->3.2.2-1.fc16.x86_64
References: <1327869629.89221.YahooMailClassic@web29503.mail.ird.yahoo.com>
In-Reply-To: <1327869629.89221.YahooMailClassic@web29503.mail.ird.yahoo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/29/2012 02:40 PM, Hin-Tak Leung wrote:
> This may be a fedora-specific problem - I noticed that just after booting into the new fedora kernel (3.2.2-1.fc16.x86_64), I am getting a strange message from the kernel:
>
> rtl8187: Invalid hwaddr! Using randomly generated MAC address
>
> And it is setting my rtl8187 to an alien mac address instead of the usual one I have. The previous (3.2.1-3.fc16.x86_64) works correctly, and as far as I go back through my /var/log/message, had never had this problem ever.
>
> The relevant changelog in the fedora package is this, so this might be a compat-wireless 3.3-rc1-2 problem? I checked rhbz 784345 which looked unrelated, although it is realtek (another driver).
>
> --------------
>
> * Wed Jan 25 2012 Josh Boyer<jwboyer@redhat.com>  - 3.2.2-1
> - Linux 3.2.2
> - Add patch to invalidate parent cache when fsync is called on a partition
>    (rhbz 783211)
> - Test fix for realtek_async_autopm oops from Stanislaw Gruszka (rhbz 784345)

The wireless device in 784345 uses iwlwifi. The Realtek device is a wired interface.

> * Wed Jan 25 2012 John W. Linville<linville@redhat.com>
> - modpost: add option to allow external modules to avoid taint
> - Make integrated compat-wireless take advantage of the above
>
> * Wed Jan 25 2012 Josh Boyer<jwboyer@redhat.com>
> - Backport patch to fix oops in rds (rhbz 718790)
>
> * Tue Jan 24 2012 John W. Linville<linville@redhat.com>
> - Update compat-wireless snapshot to version 3.3-rc1-2
>
> * Tue Jan 24 2012 Josh Boyer<jwboyer@redhat.com>
> - Re-enable the ARCMSR module (rhbz 784287)
> - Add back a set of patches that were erroneously dropped during the rebase
> - Re-enable the LIRC_STAGING drivers (rhbz 784398)
> --------------------------------

I just checked, and rtl8187 works fine with my RTL8187L using 3.3-rc1 from 
wireless-testing. I don't know where the problem occurs.

Larry


