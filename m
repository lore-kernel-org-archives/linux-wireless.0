Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49859 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781Ab2AXIG3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 03:06:29 -0500
Received: by pbaa10 with SMTP id a10so2070623pba.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jan 2012 00:06:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120124072946.GB2420@redhat.com>
References: <4F040FEA.3080703@01019freenet.de>
	<1408490.qSFZVkU7fA@helmutmobil.site>
	<4F0562DF.3000200@dualc.maya.org>
	<CAGXE3d8b5qtbhesPjRy3EXvkiwshUg0eZqcDBzb1OhKK3j6z6A@mail.gmail.com>
	<4F0AEBAB.9020104@01019freenet.de>
	<CAGXE3d-cOeTEHugbgWMoz8-Dymw0=JHxykdK4ZkBmCJZ9tSPmg@mail.gmail.com>
	<201201100803.q0A83nsQ003757@mail.maya.org>
	<CAGXE3d_jW7NFnekMfwn6JPXX0xB4UWM3ttbRVLv-ZbsoMOoWEw@mail.gmail.com>
	<201201200730.q0K7U0oj004966@mail.maya.org>
	<CAGXE3d_rCMYwoEBNjk+S7WvAmCkPMcq-Gpawm370-cSbjXy6rg@mail.gmail.com>
	<20120124072946.GB2420@redhat.com>
Date: Tue, 24 Jan 2012 09:06:28 +0100
Message-ID: <CAGXE3d8vPU2ousKU5ANv5pL55QtWFizPyEnW2tHDHPeGBUgKzg@mail.gmail.com> (sfid-20120124_090632_678133_5D10378A)
Subject: Re: Compat-wireless-3.2-rc6-3 is broken for rt2860 device
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Andreas Hartmann <andihartmann@01019freenet.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 24, 2012 at 8:29 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Mon, Jan 23, 2012 at 02:29:08PM +0100, Helmut Schaa wrote:
>> On Fri, Jan 20, 2012 at 8:29 AM, Andreas Hartmann
>> <andihartmann@01019freenet.de> wrote:
>> > All in one: Your workaround was a good idea, but unfortunately it
>> > doesn't "solve" / workaround the problem introduced with the patch
>> > "mac80211: retry sending failed BAR frames later instead of tearing
>> > down aggr" [1]. I don't know off any other solution at this time as to revert it.
>>
>> Ok, so we've got at least one hw issue here: rt2800 is not able to report
>> correct ACK state of BARs :(
>
> Whould it help, if rt2800 driver will not filter out BAR frames?

I don't think so since we're having problems with tx aggregation and not rx.
Also, BARs are not handled at all in mac80211 AFAIK.

Helmut
