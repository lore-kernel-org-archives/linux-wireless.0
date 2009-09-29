Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:60029 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbZI2Adk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 20:33:40 -0400
Received: by iwn8 with SMTP id 8so2848157iwn.33
        for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2009 17:33:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <45e8e6c40909281702i2e5497e7l3a6492151f506ce5@mail.gmail.com>
References: <20090919205545.GA18080@bombadil.infradead.org>
	<4AB5A5A7.3020107@canonical.com> <43e72e890909200743h74934657nc056c9e6dcb14e90@mail.gmail.com>
	<4AB65CFE.7090101@canonical.com> <43e72e890909201028i119b75c0ic94d07e79e4b7a43@mail.gmail.com>
	<45e8e6c40909281702i2e5497e7l3a6492151f506ce5@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 28 Sep 2009 17:33:24 -0700
Message-ID: <43e72e890909281733j11bbbb76n7506a587a1fe58a7@mail.gmail.com>
Subject: Re: [RFC] compat-2.6: mangle symbols for driver-select
To: Andrey Yurovsky <andrey@cozybit.com>
Cc: tim.gardner@canonical.com, linux-wireless@vger.kernel.org,
	Greg KH <greg@kroah.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 28, 2009 at 5:02 PM, Andrey Yurovsky <andrey@cozybit.com> wrote:
> On a side note, the compat-wireless name mangling will help with
> another problem:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/249186
>
> ...this happens because compat-wireless builds a version of the usbnet
> module but then there are Ethernet dongles (ex: asix) that rely on the
> stock version of usbnet (they aren't updated by compat-wireless) and
> the user gets a symbols mismatch as a result.  This won't be an issue
> if compat-wireless' usbnet has mangled names for its symbols.

Good call.

My solution to this was to consider backporting the usb modules that
use usbnet, these modules are pretty dormant development wise so it
certainly is something we could do.

I'm giving this mangle thing another shot now since I don't see anyone
stepping up, I won't do usbnet, my first target will obviously be
Atheros drivers :)

  Luis
