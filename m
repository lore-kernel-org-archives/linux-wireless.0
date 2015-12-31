Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp28.msg.oleane.net ([62.161.4.28]:45075 "EHLO
	smtp28.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbbLaKPp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Dec 2015 05:15:45 -0500
From: "voncken" <cedric.voncken@acksys.fr>
To: "'Emmanuel Grumbach'" <egrumbach@gmail.com>
Cc: "'linux-wireless'" <linux-wireless@vger.kernel.org>
References: <773DB8A82AB6A046AE0195C68612A31901C5B5A9@sbs2003.acksys.local>	<CANUX_P2k-Feexi5=gBm+UxsFkoic7FeGDFcNa_D3J2ujYL2ghQ@mail.gmail.com>	<0a5101d1424c$eb46d2d0$c1d47870$@acksys.fr>	<0a6a01d143a2$fcb77720$f6266560$@acksys.fr> <CANUX_P2pF_He3mruTxMU_poBXzZpa9rXA7AgYV_RQ4BJ9wS6Mg@mail.gmail.com>
In-Reply-To: <CANUX_P2pF_He3mruTxMU_poBXzZpa9rXA7AgYV_RQ4BJ9wS6Mg@mail.gmail.com>
Subject: RE: Mac80211 : Wpa rekeying issue
Date: Thu, 31 Dec 2015 11:15:42 +0100
Message-ID: <0a7101d143b4$3480de10$9d829a30$@acksys.fr> (sfid-20151231_111617_893169_1533C906)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >
> >         Hi,
> >
> > I'm not a WPA expert and security expert,
> >
> > Could you explain why the patch sent by Alexander Wetzel break the
> security properties of this code?
> >
> > The Alexander's patch is in attachment.
> >
> > Thanks for your help.
> 
> It simply disables the replay attack detection :) You could receive the
> same (encrypted) packet twice and not throw away the second one.
> The author of the patch never said that this patch is a "fix", it is rather
> a debug step to understand what happens.
> 
> PTK rekeying is a problem from the spec point of view. In Intel, we did
> inquiries and in the end we understood that what we should really do
> whenever we get to a situation where we need to rekey the PTK is to
> disconnect and reconnect. Only weird configuration allow to change the PTK
> more frequently than after X packet (don't remember what X is bu something
> like 2^32 which is big enough to hold the connection for days...).
> 
> IIRC, Intel devices don't have problems in Tx while we rekey because we
> give the key material along with the packet itself, so that we can't get to
> a situation where we have old PN and new key. The Atheros devices separate
> the key material and the Tx packet (which is a perfectly valid design
> decision), but this introduce the possibility to use the old PN with a new
> key meaning that the recipient could decrypt the packet after the new key
> has been installed, but it would also update the PN to be high and discard
> all the next packets that will come with a new (low) PN.
> So essentially, this is a bug in the TX'ing side. Fixing it requires to hit
> the performance which is not something people are willing to do, when the
> bug is really in the spec.
> That's what I remember, but I may be wrong.
> 
Thanks for your answer.
Do you know if we can have the same issue with ATH10K chipset?


