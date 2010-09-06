Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:3676 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750927Ab0IFFyl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Sep 2010 01:54:41 -0400
Received: from vs3013.wh2.ocn.ne.jp (125.206.180.245)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0392822476
	for <linux-wireless@vger.kernel.org>; Mon,  6 Sep 2010 14:54:38 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Sushil DUTT <sdutt@our.ecu.edu.au>
Subject: Re: mac80211-based commercial router?
Date: Mon, 6 Sep 2010 14:54:33 +0900
Cc: =?iso-8859-1?q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>,
	=?iso-8859-1?q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>,
	Bob Copeland <me@bobcopeland.com>, jpo <pommnitz@yahoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
References: <AANLkTim_Ou8fFbfsn8AEZFpWBzjnAQuT4S_w8bV5saYD@mail.gmail.com> <AANLkTimVRPTRdMe-pEusXxCiZXjPPWSFfXY7CRiyRazj@mail.gmail.com> <47710AF097913A429588DDC29B060B83032FB9@SINPRD0103MB052.apcprd01.prod.exchangelabs.com>
In-Reply-To: <47710AF097913A429588DDC29B060B83032FB9@SINPRD0103MB052.apcprd01.prod.exchangelabs.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201009061454.33672.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi sushil!

try any board which has good support in OpenWRT, e.g. the RouterStation Pro - 
which is what we are using here for a commercial mac80211 + ath5k based mesh 
routing device.

bruno

On Mon September 6 2010 14:12:56 Sushil DUTT wrote:
> Friends,
> 
> I saw in this thread that Athreos Ath9k is based on mac80211. Any idea,
> from where I can get this development kit? This kit seems perfect for my
> WLAN solution:)
> 
> To give a background about my project,
> Our lab has developed a WLAN solution which shows better results(in
> comaprision of mkt available solutions) in simulation. Now my job is to
> embedd & prove this solution in a stable hardware environment. I need a
> platform with SDK which can support both AP & Station. Reference
> application is highly desirable to reduce my development time.
> 
> Thanks in advance for your responses.
> 
> 
> Thanks & Regards,
> Sushil Dutt
> Centre for Communications Engineering Research
> School of Engineering
> Edith Cowan University
> 100 Joondalup Drive, Joondalup WA 6027, Australia.
> Telephone: (61 8) 6304 5318 or (61 8) 6304 5458
> Fax: (61 8) 6304 5811
> 
> 
> ________________________________________
> From: linux-wireless-owner@vger.kernel.org
> [linux-wireless-owner@vger.kernel.org] on behalf of Gábor Stefanik
> [netrolller.3d@gmail.com] Sent: Monday, September 06, 2010 7:29 AM
> To: Björn Smedman
> Cc: Bob Copeland; jpo; linux-wireless@vger.kernel.org; Luis R. Rodriguez
> Subject: Re: mac80211-based commercial router?
> 
> 2010/9/6 Björn Smedman <bjorn.smedman@venatech.se>:
> > 2010/9/6 Gábor Stefanik <netrolller.3d@gmail.com>:
> >> On Sun, Sep 5, 2010 at 10:08 PM, Bob Copeland <me@bobcopeland.com> wrote:
> >>> On Fri, Sep 3, 2010 at 4:43 PM, jpo <pommnitz@yahoo.com> wrote:
> >>>> Android 2.2 comes with AP functionality. Are the Android WLAN drivers
> >>>> mac80211 based?
> >>> 
> >>> No, they aren't.  Does Android really do AP mode or
> >>> just adhoc?
> >>> 
> >>> wl1251 is an in-tree module for the TI chip used in G1,
> >>> but it doesn't support AP mode.  I do not know if there's
> >>> a mac80211 driver that supports the broadcom chip used
> >>> in other phones.
> >> 
> >> AFAIK BCM4325 should be doable, especially if it is attached via SDIO
> >> bus. In phones where SPI is used, it is more problematic, as b43
> >> doesn't support SPI.
> > 
> > I guess the short answer is no then; all the chip vendors still focus
> > on their own proprietary mac implementations, at least on the AP side.
> > Any thoughts on what would be required for them to switch to mac80211?
> > Will it ever happen?
> > 
> > /Björn
> 
> AFAIK, the status is the following:
> -Atheros: Ath9k is officially supported and recommended by Atheros,
> and is usable for an AP - indeed, I believe Atheros is the first and
> only company to officially support a mac80211 driver AND make chipsets
> for APs. AFAIK, for the AR9002 family, no other Linux driver is
> available (at least not wit 802.11n support). Once we begin seeing
> AR9002-based APs with Linux firmware, chances are they will have a
> mac80211 driver inside. CCing Luis on this one.
> -Broadcom: they refuse to even acknowledge (maybe with the exception
> of legal threats) the development of b43, and supply binary drivers
> (and a 2.4-series kernel) in their platform kits. Also, b43 is way
> behind time when it comes to HW support (it doesn't support N-PHY,
> which is the norm now), and usually when APs begin shipping wiht a new
> Broadcom chipset, b43 still doesn't support that chipset until much
> later. I don't know about APs that include a Broadcom CPU but an
> Atheros wireless chip - AFAIK some do exist, but all use madwifi or
> some variant.
> -Ralink: Again, platform kits contain non-mac80211 drivers, even for
> recent chipsets (at least they are open-source, though). Someone
> should find a way to make them base drivers for the eventual RT4xxx
> (?) chipsets on the rt2x00 framework.
> -Marvell: No idea.
> -Realtek: Same situation as Ralink.
> 
> And some embedded Linux vendors:
> -MontaVista: I believe they are still using 2.4.x kernels (though I've
> heard of MontaVista-based routers with 2.6.8 - but even that one is
> way too old for mac80211.)
> -MikroTik: AFAIK RouterOS contains binary drivers with no relation to
> their open-source counterparts. They even named their Atheros driver
> "ath5k" IIRC, ignoring the in-tree driver with the same name! Plus,
> even if it had mac80211-based drivers, it wouldn't matter, since there
> is no (legal) way to access a Unix shell in RouterOS; instead it uses
> a proprietary "configuration shell" apparently inspired by Cisco IOS
> and ZyNOS.
> 
> --
> Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html--
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
