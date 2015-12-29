Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp08.msg.oleane.net ([62.161.4.8]:49642 "EHLO
	smtp08.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbbL2PXx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Dec 2015 10:23:53 -0500
From: "voncken" <cedric.voncken@acksys.fr>
To: "'Emmanuel Grumbach'" <egrumbach@gmail.com>
Cc: "'linux-wireless'" <linux-wireless@vger.kernel.org>,
	"'Johannes Berg'" <johannes@sipsolutions.net>
References: <773DB8A82AB6A046AE0195C68612A31901C5B5A9@sbs2003.acksys.local> <CANUX_P2k-Feexi5=gBm+UxsFkoic7FeGDFcNa_D3J2ujYL2ghQ@mail.gmail.com>
In-Reply-To: <CANUX_P2k-Feexi5=gBm+UxsFkoic7FeGDFcNa_D3J2ujYL2ghQ@mail.gmail.com>
Subject: RE: Mac80211 : Wpa rekeying issue
Date: Tue, 29 Dec 2015 16:23:49 +0100
Message-ID: <0a5101d1424c$eb46d2d0$c1d47870$@acksys.fr> (sfid-20151229_162356_150658_528D4536)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	> -----Message d'origine-----
> De : Emmanuel Grumbach [mailto:egrumbach@gmail.com]
> Envoyé : mardi 29 décembre 2015 15:20
> À : Cedric VONCKEN
> Cc : linux-wireless
> Objet : Re: Mac80211 : Wpa rekeying issue
> 
> On Tue, Dec 29, 2015 at 3:01 PM, Cedric VONCKEN <cedric.voncken@acksys.fr>
> wrote:
> > Hi,
> >
> > My test plateform is:
> > 2 equipements
> > Both equipment used compat version 2015-07-21 from openwrt.
> > Both equipment used security WPA2
> >
> > The equipment #1 is an AP.
> >         The Group rekey interval is set to 3601s
> >         The Pair rekey interval set to 50s (I reduced this value to
> > show the issue often)
> >         The Master rekey interval is set to 86400 s.
> >
> > The equipment #2 is a sta+wds
> >
> > I used a 5GHz channel to have a free channel (without other AP) I
> > connected a computer on each equipment.
> >
> > To reproduce the issue:
> >         I ran iperf udp@50Mbps from computer connected to the AP to
> > the computer connected to the sta. After several WPA2 rekeying, iperf
> > server side didn't received any frame.
> >
> > I investigated in the driver. All packets are dropped in sta side,
> > because the function ieee80211_crypto_ccmp_decrypt return
> > Rx_DROP_UNUSABLE. This function return this code because the test
> > if(memcmp(pn,key->u.ccmp.rx_pn[queue],IEEE8021_CCMP_PN_LEN) <=0)
> > return true.
> >
> > Have you any idea to fix this issue?
> >
> 
> I don't remember exactly what we had, but you may look at
> http://permalink.gmane.org/gmane.linux.kernel.wireless.general/137742

Thanks for the link, I think I'm in the same situation.

How can I fix this issue?

Because the patch sent by Alexander Wetzel was rejected by Johannes (for security reason), and if I disable the hw crypto I will have performance issue.


