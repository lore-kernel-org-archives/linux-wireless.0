Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:54049 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab2AXPT2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 10:19:28 -0500
Received: by pbaa10 with SMTP id a10so2252003pba.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jan 2012 07:19:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120124143909.GA5217@redhat.com>
References: <4F0AEBAB.9020104@01019freenet.de>
	<CAGXE3d-cOeTEHugbgWMoz8-Dymw0=JHxykdK4ZkBmCJZ9tSPmg@mail.gmail.com>
	<201201100803.q0A83nsQ003757@mail.maya.org>
	<CAGXE3d_jW7NFnekMfwn6JPXX0xB4UWM3ttbRVLv-ZbsoMOoWEw@mail.gmail.com>
	<201201200730.q0K7U0oj004966@mail.maya.org>
	<CAGXE3d_rCMYwoEBNjk+S7WvAmCkPMcq-Gpawm370-cSbjXy6rg@mail.gmail.com>
	<4F1D84CE.8020403@maya.org>
	<CAGXE3d_UPmcjgss+xMPBtkM22kBwGD23y8Fzxkr+6286W+EwbQ@mail.gmail.com>
	<201201231744.q0NHi68I002597@mail.maya.org>
	<CAGXE3d8P0UjnZ7Z=gg1uoe0WUX+4jWmg=a2i9_nV5E6i-xcfLQ@mail.gmail.com>
	<20120124143909.GA5217@redhat.com>
Date: Tue, 24 Jan 2012 16:19:27 +0100
Message-ID: <CAGXE3d8AbZB2GuPN0x8cNdvPXmKAH3Soug=COahvma4yQKFN5A@mail.gmail.com> (sfid-20120124_161931_733357_F64653AE)
Subject: Re: Compat-wireless-3.2-rc6-3 is broken for rt2860 device
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Andreas Hartmann <andihartmann@01019freenet.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 24, 2012 at 3:39 PM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Tue, Jan 24, 2012 at 09:07:04AM +0100, Helmut Schaa wrote:
>> > but the machine does crash anyway. Could hdr be null, too?
>>
>> Ok, I'll do some testing as soon as time allows and get back to you then.
>
> Not sure how good idea is is, but perhaps we could introduce mac80211 flag
> that will disable behaviour of f0425bed commit for drivers, which will
> set that flag.

I don't think this is a good idea, since if it is a device workaround
it should be
implemented in the driver. That's what I tried before but according to Andreas
the patch causes a crash. But in general it should be possible to bring a
BA session down by calling ieee80211_stop_tx_ba_session from the driver.
Not sure why that'll crash :(

Helmut
