Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40360 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757817Ab0LBQYP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 11:24:15 -0500
Received: by iwn42 with SMTP id 42so1123275iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 08:24:15 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikcngkX=a24r=uQKXgBjABQzZn_Hz3H2bvuiU8e@mail.gmail.com>
References: <AANLkTi=6NGw3GTnX+vEqx_iHcDb4SUmPc5vvndyMc=5s@mail.gmail.com>
 <AANLkTinMBx=5J4ZAaO7qkmJAxp4xbjoJxq+m+Bjz+K1e@mail.gmail.com>
 <AANLkTimUpxb+qaCerwgxqcz5iOmFz7MaZFhFPSOxJd1M@mail.gmail.com>
 <AANLkTikCrcpbyNEL94Jo9OsvcaEguKfN6-9nheZ=Sa8Q@mail.gmail.com> <AANLkTikcngkX=a24r=uQKXgBjABQzZn_Hz3H2bvuiU8e@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 2 Dec 2010 18:23:54 +0200
Message-ID: <AANLkTikccdMeLE-V2-pATqzj8mg3DKyN7SVCi-RX-vdn@mail.gmail.com>
Subject: Re: wl1271: power down/up sequence
To: Joerie de Gram <j.de.gram@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 1, 2010 at 12:40 PM, Joerie de Gram <j.de.gram@gmail.com> wrote:
> I have pushed my development tree to:
> http://h1.pargon.nl/gitweb/gitweb.cgi?p=kernel.git;a=shortlog;h=refs/heads/wireless

You forgot to apply 516d5cc "mmc: add runtime PM handlers":

http://www.spinics.net/lists/linux-mmc/msg03970.html

Without that patch, MMC core doesn't tell PM core how to control the
power of the wl1271 device, so you're left with it powered on after
boot.
