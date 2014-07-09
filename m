Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:53558 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbaGIOqV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jul 2014 10:46:21 -0400
Received: by mail-pa0-f42.google.com with SMTP id lj1so9398134pab.1
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jul 2014 07:46:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140708025719.GU1390@garbanzo.do-not-panic.com>
References: <CA+XVXffrepXAKitqhL4C87Jxy4MiF+iAO_PP6YZkMKtqeckV+Q@mail.gmail.com>
 <20140623204800.GF1390@garbanzo.do-not-panic.com> <CA+XVXfcJwZJPz9rLWx6+KSWzEfkcdnjBYpzhyKfvmX7Au38akA@mail.gmail.com>
 <20140630222132.GN1390@garbanzo.do-not-panic.com> <CA+XVXffHGQFDQ+yAhdh+R=XuDsT4QfhvFfWK4b2Cw_DttzL-BQ@mail.gmail.com>
 <20140702020442.GP1390@garbanzo.do-not-panic.com> <CA+XVXffvG6GagBPMZF+iogaAeYV0kUoi4BX68J0fxOfsHjE70A@mail.gmail.com>
 <20140703221901.GS1390@garbanzo.do-not-panic.com> <CA+XVXffnDs4oCnyD0NzmyG6=jxqXwUFd+Tj8XAsWGC1bgcMH8A@mail.gmail.com>
 <CA+XVXfewhKpsdVo5Yq3RiKWoDe85h1ne_QVUDtFuC4sfECkV7g@mail.gmail.com> <20140708025719.GU1390@garbanzo.do-not-panic.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Wed, 9 Jul 2014 17:46:05 +0300
Message-ID: <CA+XVXffMM9W76ysqgs=pyAHubavefgjqW5u8bNSZxTX69j7nzg@mail.gmail.com> (sfid-20140709_164628_214072_6848CEEF)
Subject: Re: [PATCH 4/5] cfg80211: accept world/same regdom from driver/user hints
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 8, 2014 at 5:57 AM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> Let's separate cell base station hints from userspace from firmware
> being loaded and assuming that magical firmware has now regulatory
> data (which obviously I consider silly since we already provide the
> same functionality with CRDA and let you override the db.txt). The
> cellular base station hint infrastructure can certainly be expanded
> to support overriding the *_orig parameters. The FW API looks less
> attractive now as it seems more than anything the hint can actually
> come from userspace and the base station hint mechanism for your
> use case.
>
> A FW API to let FW load regulatory data dynamically is still OK but
> lets be clear that if you are using it for a userspace work around
> for cell base astation hints it seems rather a work around for
> existing APIs and you can likely implement what you want with less
> code. If we don't need this FW API I rather not have it added.

I don't see a way around having the get_regd() API to get regulatory
data from FW. How else would we get regdomain settings?

A hint can come from userspace (as a cell-base hint) or from the
driver. In some platforms the Wifi HW is directly connected to the SIM
and the FW sends up events about country change. This eventually
causes a driver hint.

Sometimes the SIM is removed or there's no reception etc. In this case
we must get back to the "default" country, which is burned in
NVRAM/FW. As explained in my previous email, currently reg.c doesn't
have any suitable facility to save this "default" country-code. So
AFAICT, your suggestion of setting the default on boot and then
returning to it is out of the question. And anyway a "restore to
default" API doesn't exist. I'm suggesting the following solution for
this problem:
1. user/kernel calls regulatory_hint("99") to say we need to return to default
2. get_regd("99") is called and the driver/FW returns the default
country-code and it's regulatory data.

Of course we can also invent new APIs, something like:
1. on boot, the kernel calls set_default_country("XX")
2. user/kernel calls a new api restore_to_default_country(), and reg.c
uses the XX value and restores.

Personally I think the first offer is simpler and involves less
complexity on behalf of reg.c. That was my final point of the previous
email.

Arik
