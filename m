Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from icf.org.ru ([91.193.236.10]:53366 "EHLO icf.org.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758587Ab3BSUbU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 15:31:20 -0500
Date: Wed, 20 Feb 2013 00:31:13 +0400 (MSK)
From: Georgiewskiy Yuriy <bottleman@icf.org.ru>
To: Adrian Chadd <adrian@freebsd.org>
cc: Sujith Manoharan <sujith@msujith.org>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	devel@lists.open80211s.org, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] improve operational ANI in Mesh mode
In-Reply-To: <CAJ-Vmo=TmpSbt_y=b6w3=tEU4NiWViK95+3PVoKvnOfeqRFoKw@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1302200027120.19533@icf.org.ru> (sfid-20130219_213124_710499_34AC40B6)
References: <alpine.DEB.2.02.1302160630580.4293@icf.org.ru> <20130219134028.GA26332@pandem0nium> <alpine.DEB.2.02.1302191752110.31254@icf.org.ru> <CAJ-VmomPkPvABSJtdb6Y=fDNxyd_XtE6sk9yWQzw9qC7rjkwiA@mail.gmail.com> <alpine.DEB.2.02.1302192034420.7450@icf.org.ru>
 <CAJ-VmokUJtowcO0AWpyFLoLN0R0KowETb1BOyjN66rzPSDhjOQ@mail.gmail.com> <20771.50338.434076.484711@gargle.gargle.HOWL> <CAJ-VmokAP6hSxjGDUu7Q5rSg3dvxfLapQBSLgYCvWc9b0YEPgA@mail.gmail.com> <20771.51233.248133.141840@gargle.gargle.HOWL>
 <alpine.DEB.2.02.1302192258510.19584@icf.org.ru> <CAJ-Vmo=TmpSbt_y=b6w3=tEU4NiWViK95+3PVoKvnOfeqRFoKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1050998036-2046251322-1361305873=:19533"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1050998036-2046251322-1361305873=:19533
Content-Type: TEXT/PLAIN; charset=KOI8-R
Content-Transfer-Encoding: 8BIT

On 2013-02-19 11:37 -0800, Adrian Chadd wrote Georgiewskiy Yuriy:

AC>On 19 February 2013 11:11, Georgiewskiy Yuriy <bottleman@icf.org.ru> wrote:
AC>
AC>>
AC>> hm, i have signal jumps too on some cards, but it's may be a hardware problem,
AC>> in one of my case this confirmed by manufacturer, then hi block 2.4 bands on it
AC>> where problem occurses, and continue sell it as 5Ggz only card. and i have NF
AC>> calibration jumps on this card too, it easy to se just enable calibration debug
AC>> (echo 0x00000008 > /sys/kernel/debug/ieee80211/phy0/ath9k/debug) and watch on
AC>> log with tail -f, you sould se something like this, may be periodicaly:
AC>>
AC>> 6.505180] ath: phy0: NF calibrated [ctl] [chain 0] is -68
AC>> 6.505185] ath: phy0: NF[0] (-68) > MAX (-97), correcting to MAX
AC>> 6.505188] ath: phy0: NF calibrated [ctl] [chain 1] is -80
AC>> 6.505191] ath: phy0: NF[1] (-80) > MAX (-97), correcting to MAX
AC>> 6.505194] ath: phy0: NF calibrated [ext] [chain 0] is -70
AC>> 6.505197] ath: phy0: NF[3] (-70) > MAX (-97), correcting to MAX
AC>> 6.505200] ath: phy0: NF calibrated [ext] [chain 1] is -80
AC>> 6.505204] ath: phy0: NF[4] (-80) > MAX (-97), correcting to MAX
AC>
AC>Yes. I've seen cards that do this. It's almost always due to badly
AC>placed components/tracks causing spurs / resonance to show up in the
AC>2GHz bands.
AC>It makes the NIC unusable in those modes.

but, there is some funny rssi processing sometimes:

common.h
#define ATH_EP_RND(x, mul)                                              \
        ((((x)%(mul)) >= ((mul)/2)) ? ((x) + ((mul) - 1)) / (mul) : (x)/(mul))
        
recv.c
        last_rssi = sc->last_rssi;
        if (likely(last_rssi != ATH_RSSI_DUMMY_MARKER))
                rssi = ATH_EP_RND(last_rssi, ATH_RSSI_EP_MULTIPLIER);
        if (rssi < 0)
                rssi = 0;
                                                        
        /* Update Beacon RSSI, this is used by ANI. */
        ah->stats.avgbrssi = rssi;

may be i don't understand something, but looks strange.                                                                        

C уважением                       With Best Regards
Георгиевский Юрий.                Georgiewskiy Yuriy
+7 4872 711666                    +7 4872 711666
факс +7 4872 711143               fax +7 4872 711143
Компания ООО "Ай Ти Сервис"       IT Service Ltd
http://nkoort.ru                  http://nkoort.ru
JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YG129-RIPE                        YG129-RIPE
---1050998036-2046251322-1361305873=:19533--
