Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:35089 "HELO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757797Ab0IXTaN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Sep 2010 15:30:13 -0400
Received: by mail-ww0-f42.google.com with SMTP id 13so110444wwb.3
        for <linux-wireless@vger.kernel.org>; Fri, 24 Sep 2010 12:30:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100924191139.GI4211@atomide.com>
References: <1285236215-21136-1-git-send-email-luciano.coelho@nokia.com>
 <20100924180316.GE8077@tuxdriver.com> <1285354249.9779.3.camel@powerslave> <20100924191139.GI4211@atomide.com>
From: "Gadiyar, Anand" <gadiyar@ti.com>
Date: Sat, 25 Sep 2010 00:51:32 +0530
Message-ID: <AANLkTimixgHuhKYRP9X17V+z20T70Pn0vJJEsO_HgXQ4@mail.gmail.com>
Subject: Re: [PATCH v3] omap: beagle: add support for wl1271 on the board file
To: Tony Lindgren <tony@atomide.com>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	"ext John W. Linville" <linville@tuxdriver.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ido Yariv <ido@wizery.com>, Ohad Ben-Cohen <ohad@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 25, 2010 at 12:41 AM, Tony Lindgren <tony@atomide.com> wrote:
> * Luciano Coelho <luciano.coelho@nokia.com> [100924 11:42]:
>> On Fri, 2010-09-24 at 20:03 +0200, ext John W. Linville wrote:
>> > On Thu, Sep 23, 2010 at 01:03:35PM +0300, Luciano Coelho wrote:
>> > > Add board configuration for the wl1271 daughter board.  This patch is based
>> > > on Ohad Ben-Cohen's patches for Zoom boards.
>> > >
>> > > Cc: Ohad Ben-Cohen <ohad@wizery.com>
>> > > Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
>> > > ---
>> > > from v2 to v3: removed accidental change to wl1271.h
>> >
>> > I presume that this should come through my tree as well (since it
>> > contains the move of wl12xx.h)?
>>
>> Yes, this is based on your tree.  But please hold on, because there were
>> some comments (namely, the expansion board should be detected, not
>> configured for wl1271 by default), which I still have to fix.  I'm
>> waiting for the manufacturer of the expansion board to provide me with
>> some more info for proper detection.
>>
>> Also, I know that there are some other work being done in the beagle
>> board file, so we may need to rethink how to sync this.
>>
>> So, for now, let's skip this patch and I'll provide another one when
>> these issues are addressed.
>
> You could also do it based on some kernel cmdline option. Of course
> detection during the runtime would be better.
>

This seems to be a generic problem that many boards with potential for
adding expansion boards seem to have. How about one of these options:
(a) having u-boot modify ATAGS_REVISION based on an environment variable
or
(b) add a generic board_revision kernel command line parameter that
each such board file can parse

By default - with no special command line options -  peripherals for
the most common board revision could be picked. Anyway a user that
uses such a daughterboard would know to modify the kernel command
line, or set an environment variable in u-boot, (or use a custom
u-boot) so this could scale well.

What do you think?

- Anand
