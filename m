Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60139 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752981Ab2KYOAw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Nov 2012 09:00:52 -0500
Message-ID: <1353852070.9875.2.camel@jlt4.sipsolutions.net> (sfid-20121125_150056_200428_1ADFB536)
Subject: Re: mips: warning in net/mac80211/tx.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Sun, 25 Nov 2012 15:01:10 +0100
In-Reply-To: <50B20DAD.9030204@broadcom.com>
References: <50B20DAD.9030204@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-11-25 at 13:23 +0100, Arend van Spriel wrote:
> Hi Johannes,
> 
> I played with crosstool-ng to compile test our driver for a number of
> platforms that it is supposed to work on. The gcc version is 4.7.2.
> 
> *mips*:
>   CC [M]  net/mac80211/tx.o
> net/mac80211/tx.c: In function 'ieee80211_subif_start_xmit':
> net/mac80211/tx.c:1797:22: error: 'chanctx_conf' may be used
> uninitialized in this function [-Werror=maybe-uninitialized]

Yeah it seems to randomly throw this warning under certain
circumstances, sometimes gcc doesn't seem to be able to prove that in
fact it *isn't* used uninitialized.

I think we should just leave the warning though, anything else I could
come up with to suppress it would just cause real ones to be suppressed
as well if somebody changes this code.

johannes

