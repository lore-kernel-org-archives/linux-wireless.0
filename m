Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:36196 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbcALLik (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jan 2016 06:38:40 -0500
Received: by mail-lb0-f181.google.com with SMTP id oh2so271218073lbb.3
        for <linux-wireless@vger.kernel.org>; Tue, 12 Jan 2016 03:38:39 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1452201308.3141.25.camel@sipsolutions.net>
References: <773DB8A82AB6A046AE0195C68612A31901C5B5A9@sbs2003.acksys.local>
	<CANUX_P2k-Feexi5=gBm+UxsFkoic7FeGDFcNa_D3J2ujYL2ghQ@mail.gmail.com>
	<0a5101d1424c$eb46d2d0$c1d47870$@acksys.fr>
	<0a6a01d143a2$fcb77720$f6266560$@acksys.fr>
	<CANUX_P2pF_He3mruTxMU_poBXzZpa9rXA7AgYV_RQ4BJ9wS6Mg@mail.gmail.com>
	<1452201308.3141.25.camel@sipsolutions.net>
Date: Tue, 12 Jan 2016 13:38:38 +0200
Message-ID: <CANUX_P1rmoJBa0P4arO-1Hbi_A07mMpzMoAwcDWjjh-JnOvv+w@mail.gmail.com> (sfid-20160112_123844_489110_1E145CB9)
Subject: Re: Mac80211 : Wpa rekeying issue
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: voncken <cedric.voncken@acksys.fr>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 7, 2016 at 11:15 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
> On Thu, 2015-12-31 at 10:41 +0200, Emmanuel Grumbach wrote:
> >
> > So essentially, this is a bug in the TX'ing side. Fixing it requires
> > to hit the performance which is not something people are willing to
> > do, when the bug is really in the spec.
> >
>
> I wonder if, for most devices, this is really true?
>
> We could, after all, remove the key from hardware acceleration before
> we replace it logically in software, avoiding the problem [1], like
> this:
>
> https://p.sipsolutions.net/a71aa559c27998c7.txt
> (completely untested!)
>
> This would slightly increase the window of time in which devices like
> ath10k that require hardware crypto drop the frame entirely, but that
> seems quite reasonable?

Yes - it looks reasonable. At least, worth being tested :)

>
>
> [1] assuming the driver doesn't return from the set_key() method while
> it still has frames that might have been decrypted with that key; which
> again is clearly true for iwlwifi due to the combined data/firmware
> command design, but maybe not fully guaranteed for ath9k
