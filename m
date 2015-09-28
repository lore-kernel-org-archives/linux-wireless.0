Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33944 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933413AbbI1O0x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2015 10:26:53 -0400
Message-ID: <1443450406.2168.3.camel@HansenPartnership.com> (sfid-20150928_162701_513207_6C44F9E4)
Subject: Re: [PATCH V4 1/2] ACPI / EC: Fix broken 64bit big-endian users of
 'global_lock'
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: "'Rafael J. Wysocki'" <rjw@rjwysocki.net>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Linaro Kernel Mailman List <linaro-kernel@lists.linaro.org>,
	QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Linux ACPI <linux-acpi@vger.kernel.org>,
	"open list:BLUETOOTH DRIVERS" <linux-bluetooth@vger.kernel.org>,
	"open list:AMD IOMMU (AMD-VI)" <iommu@lists.linux-foundation.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"open list:NETWORKING DRIVERS (WIRELESS)"
	<linux-wireless@vger.kernel.org>,
	"open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>,
	"open list:ULTRA-WIDEBAND (UWB) SUBSYSTEM:"
	<linux-usb@vger.kernel.org>,
	"open list:EDAC-CORE" <linux-edac@vger.kernel.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	"moderated list:SOUND - SOC LAYER / DYNAMIC AUDIO POWER MANAGEM..."
	<alsa-devel@alsa-project.org>
Date: Mon, 28 Sep 2015 07:26:46 -0700
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1CBA3BF7@AcuExch.aculab.com>
References: <e28c4b4deaf766910c366ab87b64325da59c8ad6.1443198783.git.viresh.kumar@linaro.org>
	 <2524822.pQu4UKMrlb@vostro.rjw.lan>
	 <1443297128.2181.11.camel@HansenPartnership.com>
	 <3461169.v5xKdGLGjP@vostro.rjw.lan>
	 <063D6719AE5E284EB5DD2968C1650D6D1CBA3BF7@AcuExch.aculab.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-09-28 at 08:58 +0000, David Laight wrote:
> From: Rafael J. Wysocki
> > Sent: 27 September 2015 15:09
> ...
> > > > Say you have three adjacent fields in a structure, x, y, z, each one byte long.
> > > > Initially, all of them are equal to 0.
> > > >
> > > > CPU A writes 1 to x and CPU B writes 2 to y at the same time.
> > > >
> > > > What's the result?
> > >
> > > I think every CPU's  cache architecure guarantees adjacent store
> > > integrity, even in the face of SMP, so it's x==1 and y==2.  If you're
> > > thinking of old alpha SMP system where the lowest store width is 32 bits
> > > and thus you have to do RMW to update a byte, this was usually fixed by
> > > padding (assuming the structure is not packed).  However, it was such a
> > > problem that even the later alpha chips had byte extensions.
> 
> Does linux still support those old Alphas?
> 
> The x86 cpus will also do 32bit wide rmw cycles for the 'bit' operations.

That's different: it's an atomic RMW operation.  The problem with the
alpha was that the operation wasn't atomic (meaning that it can't be
interrupted and no intermediate output states are visible).

> > OK, thanks!
> 
> You still have to ensure the compiler doesn't do wider rmw cycles.
> I believe the recent versions of gcc won't do wider accesses for volatile data.

I don't understand this comment.  You seem to be implying gcc would do a
64 bit RMW for a 32 bit store ... that would be daft when a single
instruction exists to perform the operation on all architectures.

James


