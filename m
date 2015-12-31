Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:36851 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbbLaIlz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Dec 2015 03:41:55 -0500
Received: by mail-lb0-f180.google.com with SMTP id oh2so124930479lbb.3
        for <linux-wireless@vger.kernel.org>; Thu, 31 Dec 2015 00:41:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <0a6a01d143a2$fcb77720$f6266560$@acksys.fr>
References: <773DB8A82AB6A046AE0195C68612A31901C5B5A9@sbs2003.acksys.local>
	<CANUX_P2k-Feexi5=gBm+UxsFkoic7FeGDFcNa_D3J2ujYL2ghQ@mail.gmail.com>
	<0a5101d1424c$eb46d2d0$c1d47870$@acksys.fr>
	<0a6a01d143a2$fcb77720$f6266560$@acksys.fr>
Date: Thu, 31 Dec 2015 10:41:53 +0200
Message-ID: <CANUX_P2pF_He3mruTxMU_poBXzZpa9rXA7AgYV_RQ4BJ9wS6Mg@mail.gmail.com> (sfid-20151231_094230_609283_71F7BF75)
Subject: Re: Mac80211 : Wpa rekeying issue
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: voncken <cedric.voncken@acksys.fr>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 31, 2015 at 10:12 AM, voncken <cedric.voncken@acksys.fr> wrote:
>
>         Hi,
>
> I'm not a WPA expert and security expert,
>
> Could you explain why the patch sent by Alexander Wetzel break the security properties of this code?
>
> The Alexander's patch is in attachment.
>
> Thanks for your help.

It simply disables the replay attack detection :)
You could receive the same (encrypted) packet twice and not throw away
the second one.
The author of the patch never said that this patch is a "fix", it is
rather a debug step to understand what happens.

PTK rekeying is a problem from the spec point of view. In Intel, we
did inquiries and in the end we understood that what we should really
do whenever we get to a situation where we need to rekey the PTK is to
disconnect and reconnect. Only weird configuration allow to change the
PTK more frequently than after X packet (don't remember what X is bu
something like 2^32 which is big enough to hold the connection for
days...).

IIRC, Intel devices don't have problems in Tx while we rekey because
we give the key material along with the packet itself, so that we
can't get to a situation where we have old PN and new key. The Atheros
devices separate the key material and the Tx packet (which is a
perfectly valid design decision), but this introduce the possibility
to use the old PN with a new key meaning that the recipient could
decrypt the packet after the new key has been installed, but it would
also update the PN to be high and discard all the next packets that
will come with a new (low) PN.
So essentially, this is a bug in the TX'ing side. Fixing it requires
to hit the performance which is not something people are willing to
do, when the bug is really in the spec.
That's what I remember, but I may be wrong.

>
> > -----Message d'origine-----
> > De : linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
> > owner@vger.kernel.org] De la part de voncken
> > Envoyé : mardi 29 décembre 2015 16:24
> > À : 'Emmanuel Grumbach'
> > Cc : 'linux-wireless'; 'Johannes Berg'
> > Objet : RE: Mac80211 : Wpa rekeying issue
> >
> >       > -----Message d'origine-----
> > > De : Emmanuel Grumbach [mailto:egrumbach@gmail.com] Envoyé : mardi 29
> > > décembre 2015 15:20 À : Cedric VONCKEN Cc : linux-wireless Objet : Re:
> > > Mac80211 : Wpa rekeying issue
> > >
> > > On Tue, Dec 29, 2015 at 3:01 PM, Cedric VONCKEN
> > > <cedric.voncken@acksys.fr>
> > > wrote:
> > > > Hi,
> > > >
> > > > My test plateform is:
> > > > 2 equipements
> > > > Both equipment used compat version 2015-07-21 from openwrt.
> > > > Both equipment used security WPA2
> > > >
> > > > The equipment #1 is an AP.
> > > >         The Group rekey interval is set to 3601s
> > > >         The Pair rekey interval set to 50s (I reduced this value to
> > > > show the issue often)
> > > >         The Master rekey interval is set to 86400 s.
> > > >
> > > > The equipment #2 is a sta+wds
> > > >
> > > > I used a 5GHz channel to have a free channel (without other AP) I
> > > > connected a computer on each equipment.
> > > >
> > > > To reproduce the issue:
> > > >         I ran iperf udp@50Mbps from computer connected to the AP to
> > > > the computer connected to the sta. After several WPA2 rekeying,
> > > > iperf server side didn't received any frame.
> > > >
> > > > I investigated in the driver. All packets are dropped in sta side,
> > > > because the function ieee80211_crypto_ccmp_decrypt return
> > > > Rx_DROP_UNUSABLE. This function return this code because the test
> > > > if(memcmp(pn,key->u.ccmp.rx_pn[queue],IEEE8021_CCMP_PN_LEN) <=0)
> > > > return true.
> > > >
> > > > Have you any idea to fix this issue?
> > > >
> > >
> > > I don't remember exactly what we had, but you may look at
> > > http://permalink.gmane.org/gmane.linux.kernel.wireless.general/137742
> >
> > Thanks for the link, I think I'm in the same situation.
> >
> > How can I fix this issue?
> >
> > Because the patch sent by Alexander Wetzel was rejected by Johannes (for
> > security reason), and if I disable the hw crypto I will have performance
> > issue.
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> > in the body of a message to majordomo@vger.kernel.org More majordomo info
> > at  http://vger.kernel.org/majordomo-info.html
