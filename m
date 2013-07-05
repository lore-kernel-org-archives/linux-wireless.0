Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f52.google.com ([209.85.216.52]:39990 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757365Ab3GEOpC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 10:45:02 -0400
Received: by mail-qa0-f52.google.com with SMTP id bv4so1255275qab.18
        for <linux-wireless@vger.kernel.org>; Fri, 05 Jul 2013 07:45:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5FF020A1CFFEEC49BD1E09530C4FF5951035636350@SC-VEXCH1.marvell.com>
References: <CAMLZHHSSfPnWK957Yd+vrLrsPHtUDW3b4ZxSjMe2SdpaQPk5hQ@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951035636350@SC-VEXCH1.marvell.com>
Date: Fri, 5 Jul 2013 08:45:01 -0600
Message-ID: <CAMLZHHSduu3guHuw__XKZfhrFWc8r7W6DwLp3SMdtLQ56CRh6Q@mail.gmail.com> (sfid-20130705_164507_282308_DA18BC81)
Subject: Re: [PATCH] mwifiex: don't ignore SDIO interrupts during shutdown
From: Daniel Drake <dsd@laptop.org>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Bing Zhao <bzhao@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 5, 2013 at 8:26 AM, Amitkumar Karwar <akarwar@marvell.com> wrote:
> I think, we should probably look into mwifiex_sdio_suspend() routine instead of mwifiex_sdio_remove() to debug interrupt storm issue. Please correct me if I am missing something.

The system is going into an unpowered suspend. This means that
mwifiex_sdio_suspend() returns -ENOSYS.
The card then gets removed by mwifiex_sdio_remove().

mwifiex_sdio_remove() calls mwifiex_remove_card() without having taken
any care to finish pending commands, etc. mwifiex_remove_card()
immediately sets surprise_removed which triggers the questionable
"ignore all interrupts" behaviour. If there were any async commands
pending, they complete now, with an interrupt. The interrupt doesn't
get acked, so it becomes an interrupt storm.

Hope that is clearer.

Daniel
