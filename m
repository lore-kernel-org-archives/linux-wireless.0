Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from icf.org.ru ([91.193.236.10]:49533 "EHLO icf.org.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758644Ab3BSQtc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 11:49:32 -0500
Date: Tue, 19 Feb 2013 20:49:28 +0400 (MSK)
From: Georgiewskiy Yuriy <bottleman@icf.org.ru>
To: Adrian Chadd <adrian@freebsd.org>
cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	devel@lists.open80211s.org, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] improve operational ANI in Mesh mode
In-Reply-To: <CAJ-VmomPkPvABSJtdb6Y=fDNxyd_XtE6sk9yWQzw9qC7rjkwiA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1302192034420.7450@icf.org.ru> (sfid-20130219_174938_607674_C3EAA5DD)
References: <alpine.DEB.2.02.1302160630580.4293@icf.org.ru> <20130219134028.GA26332@pandem0nium> <alpine.DEB.2.02.1302191752110.31254@icf.org.ru> <CAJ-VmomPkPvABSJtdb6Y=fDNxyd_XtE6sk9yWQzw9qC7rjkwiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1050998036-554048686-1361292568=:7450"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1050998036-554048686-1361292568=:7450
Content-Type: TEXT/PLAIN; charset=KOI8-R
Content-Transfer-Encoding: 8BIT

On 2013-02-19 08:31 -0800, Adrian Chadd wrote Georgiewskiy Yuriy:

AC>Well, ANI does adjust some of its parameters based on the beacon
AC>signal level. It uses that as an estimate for how "strong" the signal
AC>is likely to be and tunes the baseband to either be highly sensitive
AC>or slightly on the deafer side.
AC>
AC>If you have many sources of beacons (read: ibss, mesh, TDMA in my
AC>case) then that particular feature of ANI can't be used and it should
AC>be disabled. The code should be special casing it.
AC>
AC>I suggest someone writes a bunch of test functions:
AC>
AC>* whether we see no beacons (ie, AP mode)
AC>* whether we see one set of beacons (ie, STA mode)
AC>* whether we see multiple sets of beacons (ie ,everything else)
AC>
AC>.. and then modify the ANI code to work with the above.

I think you are right, but there i think a number of another bugs outside
of ani code - scan somehow triggers ani which adjust levels randomly, 
it's triggers it even if ani disabled completely, question - why? random 
levels after inserting module and bring up interface, its very annoing on 
real network, reboot node - and a number of client will unreacheble, reboot 
again - reachble, or part of him, scan on node - same result, this is why 
i first disable ani at all, but this no much help me, then start digging 
what is wrong. and after this changes i se no difference between AP and 
802.11 modes, i think bugs with scan and initialisation steel present, 
but ani will work and nivelate this bugs, don't known about other modes, 
i just compare with ap.

C уважением                       With Best Regards
Георгиевский Юрий.                Georgiewskiy Yuriy
+7 4872 711666                    +7 4872 711666
факс +7 4872 711143               fax +7 4872 711143
Компания ООО "Ай Ти Сервис"       IT Service Ltd
http://nkoort.ru                  http://nkoort.ru
JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YG129-RIPE                        YG129-RIPE
---1050998036-554048686-1361292568=:7450--
