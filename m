Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55742 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab0LJO1D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Dec 2010 09:27:03 -0500
Received: by vws16 with SMTP id 16so2231271vws.19
        for <linux-wireless@vger.kernel.org>; Fri, 10 Dec 2010 06:27:01 -0800 (PST)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <201012101409.38146.florian@kriener.org>
References: <201012101409.38146.florian@kriener.org>
Date: Fri, 10 Dec 2010 15:27:01 +0100
Message-ID: <AANLkTikb1Pmk3F6BL1ewrKpQaOxrG-McxbfnfTGNcZKo@mail.gmail.com>
Subject: Re: BUG: Microcode SW error detected / Frequent disconnects
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Florian Kriener <florian@kriener.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 10, 2010 at 2:09 PM, Florian Kriener <florian@kriener.org> wrote:
> Dear Intel wireless experts,
>
> when connecting to a certain network I always get a lot of network
> hangs, which can sometimes be solved temporarily by reconnecting to that
> network. The cause seems to be a microcode software error. At leat, that
> is what dmesg shows. I attached a piece of it.
>
> The access point in question is a speedport w503v, which is a Telekom
> (German ISP) branded AVM or Arcadyan dsl router. It is located in a WLAN
> polluted area with approx. 45 networks nearby. Most of them are between
> channels 6 and 11. The access point in question is somehow seated at
> channel 10, which I cannot change.
>
> % uname -a
> Linux nanuk 2.6.36-trunk-amd64 #1 SMP Wed Oct 27 14:28:29 UTC 2010
> x86_64 GNU/Linux
>

Guessing you are using a Debian kernel from experimental.
'uname -a' is normally not enough, we need the Debian version string.
(As there was only one 2.6.36 kernel, it is clear which version you have).
There is now a 2.6.37-rc4 in experimental, please try that.
bwh has prepared -rc5 a few hours ago and it will be uploaded to
experimental soonish.
(You check out from SVN and build by yourself or wait, see
instructions on Debian kernel team wiki).

Another possibility is you use compat-wireless stable or bleeding-edge
(in addition to your host 2.6.36 kernel).

All these "experiments" only to see if it is a problem in 2.6.36.
(Might be the Intel developers know where the problem is exactly).

Next question is: You have latest firmware file(s) from non-free?
(Or look at Intel's iwlwifi download website).

BTW, sometimes a full dmesg log is more helpful than a truncated one.

- Sedat -
