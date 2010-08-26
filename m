Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45125 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103Ab0HZREr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Aug 2010 13:04:47 -0400
MIME-Version: 1.0
In-Reply-To: <1282793857.22839.233.camel@localhost>
References: <20100824120743.GG29330@bicker>
	<1282652121.2968.9.camel@localhost>
	<AANLkTikL8KUyaCsSy8yu0brUde5cGCRnfc74Ufs47jga@mail.gmail.com>
	<1282793857.22839.233.camel@localhost>
Date: Thu, 26 Aug 2010 10:04:45 -0700
Message-ID: <AANLkTikW0hWZr-VZzmL=BCqF+nU7LapandpOkNLv7GwX@mail.gmail.com>
Subject: Re: [rfc patch] libertas: fix if_spi_prog_helper_firmware()
From: Colin McCabe <cmccabe@alumni.cmu.edu>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Dan Carpenter <error27@gmail.com>,
	Mike Frysinger <vapier.adi@gmail.com>,
	libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 25, 2010 at 8:37 PM, Ben Hutchings <ben@decadent.org.uk> wrote:
> On Wed, 2010-08-25 at 20:26 -0700, Colin McCabe wrote:
>> On Tue, Aug 24, 2010 at 5:15 AM, Ben Hutchings <ben@decadent.org.uk> wrote:
>> > On Tue, 2010-08-24 at 14:07 +0200, Dan Carpenter wrote:
>> >> The indenting is not correct here.  I don't have this hardware and I'm
>> >> just guessing as to what was intended.  I think that if there is an
>> >> error we should return an error code, but if there isn't an error we
>> >> should return success directly without releasing the firmware.
>> > [...]
>> >
>> > The driver doesn't use or refer to the firmware image once it's copied
>> > into device RAM, so this just leaks the firmware.
>> >
>> > The driver *should* keep a reference so it can restore the firmware
>> > after suspend/resume without filesystem access (which is likely to
>> > deadlock).
>>
>> Well, if all you want to do is put the device into "deep sleep" mode,
>> you will not need a firmware reload after waking it up.
> [...]
>
> I was thinking of system suspend/resume, which could remove all power
> from the device.
>

Ok, that makes sense.

Colin
