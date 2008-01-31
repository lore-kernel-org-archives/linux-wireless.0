Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.240]:5894 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538AbYAaQ4x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2008 11:56:53 -0500
Received: by an-out-0708.google.com with SMTP id d31so177444and.103
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jan 2008 08:56:51 -0800 (PST)
Message-ID: <40f31dec0801310856p28513848nd22c4b3c590b7a46@mail.gmail.com> (sfid-20080131_165658_170820_15EBF6CD)
Date: Thu, 31 Jan 2008 18:56:51 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: ath5k: reset for 5424-based card
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <20080131155901.GA7997@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080131155901.GA7997@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/1/31, Bob Copeland <me@bobcopeland.com>:
> Hi all,
>
> I have the following device (0x168c:001c) which comes with certain MacBooks:
>
> 02:00.0 Ethernet controller: Atheros Communications, Inc. AR5006EG 802.11 b/g
> Wireless PCI Express Adapter (rev 01)

Can you plz run ath_info tool found on madwifi-trace branch and post
the output (mac/phy revision) ?

> The current driver from merged-upstream of a few days ago doesn't seem to
> work for this card.  In ath5k_hw_nic_wakeup, it dies after the nic reset
> and any MMIO accesses from then on return -1 (needs a hard reboot to fix).
>
> I dumped a trace of the working madwifi driver using mmio-trace and saw that
> it only sets the bottom two bits when doing AR5K_RESET_CTL.  So, the patch
> below indeed makes probe work for the card.
>

It's a known bug, i have a patch pending already, problem is that
AR5K_RESET_CTL_PCI probably hangs the "host interface unit" and you
need to reboot as you said, just removing it also fixes the probe
problem (that seems to only happen on newer pci-e cards).

> It isn't perfect after that; it can associate with an AP but appears to reset
> constantly so it's not really usable.
>

That's interesting because even with the fix on nic_wakeup + making
initvals tables etc i tried it on a 2425 and couldn't even scan
(that's why i hadn't post the patch earlier, card wouldn't work anyway
so i left it for the patch series i'm working on). If you got your
card scanning then we are really close on fixing it !

> I'd love to get this working generally; if needed I can try out patches,
> supply traces, or, given enough direction, contribute some code...
>

Thanx a lot for your patch, just have in mind that we prefer to reset
most of the card's units to be on the safe side, that's because we
don't know what cards (mac/phy revisions) can live without reseting X
unit.

Another important question, what band was the ap on ?

-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
