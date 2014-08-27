Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:61120 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865AbaH0GHO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Aug 2014 02:07:14 -0400
Received: by mail-ig0-f173.google.com with SMTP id h18so5729160igc.12
        for <linux-wireless@vger.kernel.org>; Tue, 26 Aug 2014 23:07:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53FCEECA.8090308@hauke-m.de>
References: <CACna6rzRf7qf0YAFWqp4VgwR76-N8HO12eSz_H5NW9LpjBArdw@mail.gmail.com>
	<53FCEECA.8090308@hauke-m.de>
Date: Wed, 27 Aug 2014 08:07:13 +0200
Message-ID: <CACna6ryS=Tr7FsF6NMJOHZax1zXpGxYfOt-GprNM1WHi2tJhkA@mail.gmail.com> (sfid-20140827_080719_036355_0A0BF9D6)
Subject: Re: Booting bcm47xx (bcma & stuff), sharing code with bcm53xx
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 August 2014 22:32, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> On 08/26/2014 06:42 PM, Rafał Miłecki wrote:
>> 3) Above change (point 2) would require some small change in bcma. We
>> would need 2-stages init: detecting (with kmalloc!) bus cores,
>> registering cores. This is required, because we can't register cores
>> too early, device_add (and the underlying kobject) would oops/WARN in
>> kobject_get.
>>
>
> This sound good to me, but I still have some questions.
>
> Do you also want to change ssb registration?
> Is it worth the effort? I think MIPS bcm47xx will be EOL and replaced by
> the ARM versions completely in the next years. (I do not have any
> private information about Broadcom product politics)

ssb has its own hacks like having "struct device" static (I think it
was a big "no" from Greg when introducing bcma). ssb is already smart
enough to detect early boot phase and don't register devices then. I
think we won't need to modify ssb at all.
On the other hand I care about bcma, as it's used by PCIe devices and
will still be used on ARM SoCs.


> I think this will be reduce the number of hacks a little bit, but you
> still need a 2 stage init of bcma for mips SoCs, and I do not know how
> to prevent this.

I'm OK with two separated calls to the bcma to register it fully. Not
a big deal. We could also think about sth like a ssb_is_early_boot,
not sure about this yet.

-- 
Rafał
