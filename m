Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:11871 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751536AbYITVSv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Sep 2008 17:18:51 -0400
Received: by nf-out-0910.google.com with SMTP id d3so337728nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 20 Sep 2008 14:18:48 -0700 (PDT)
Message-ID: <f488382f0809201418j66a813a0m4c0a5843f0dfc87a@mail.gmail.com> (sfid-20080920_231910_580186_F1A6ECD6)
Date: Sat, 20 Sep 2008 14:18:48 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [ath9k-devel] ath9k: massive unexplained latency in 2.6.27 (rc5, rc6, probably others)
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"Senthilkumar Balasubramanian"
	<Senthilkumar.Balasubramanian@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	"Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <43e72e890809201357y1413a151r85aad7cc16440cf4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <f488382f0809181604l105535bkceecd44c590bc88b@mail.gmail.com>
	 <20080919175824.GA5626@senthil-lnx.users.atheros.com>
	 <20080919182322.GB7027@tesla>
	 <alpine.LNX.2.00.0809191630090.14961@alcarin.uplinklabs.net>
	 <20080919235305.GD11665@tesla>
	 <f488382f0809191701u2dbf8d22n6015c9f1f23c73be@mail.gmail.com>
	 <43e72e890809191813n95579f5h83e92b0ba1f95a44@mail.gmail.com>
	 <f488382f0809192029w601e0e72x5c3affc3dbe65118@mail.gmail.com>
	 <f488382f0809200821m6fe355feu2d9fb99ac3c7f712@mail.gmail.com>
	 <43e72e890809201357y1413a151r85aad7cc16440cf4@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 20, 2008 at 1:57 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> So here's what we need to do -- try to zero on in what causes this IRQ
> storm.

How is the best way to approach this? I assume ATH_DBG_INTERRUPT and
pray like hell my /var partition doesn't fill up first? Maybe I'll
just symlink /var/log/messages to a file on a substantially larger
pattition...

> Most likely its some strange event that triggers it, perhaps
> some sort of noise which makes the device try to adapt and hits a path
> we are not handling correctly yet. Can you provide the initial log of
> when ath9k gets loaded? This tells us what card it is, like AR5416 or
> AR9280, etc.

[10238.347956] ath9k: 0.1
[10238.348028] vendor=8086 device=27d2
[10238.348033] ath9k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[10238.348050] ath9k 0000:03:00.0: setting latency timer to 64
[10238.480781] phy1: Selected rate control algorithm 'ath9k_rate_control'
[10238.483320] phy1: Atheros 5416: mem=0xffffc20000060000, irq=17

It claims to be a 5416, but I was under the impression that it was the
5418 that came with the MacBook Pro.
