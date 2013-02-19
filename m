Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from icf.org.ru ([91.193.237.1]:39289 "EHLO icf.org.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933985Ab3BSTME (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Feb 2013 14:12:04 -0500
Date: Tue, 19 Feb 2013 23:11:57 +0400 (MSK)
From: Georgiewskiy Yuriy <bottleman@icf.org.ru>
To: Sujith Manoharan <sujith@msujith.org>
cc: Adrian Chadd <adrian@freebsd.org>,
	Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	devel@lists.open80211s.org, ath9k-devel@lists.ath9k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] improve operational ANI in Mesh mode
In-Reply-To: <20771.51233.248133.141840@gargle.gargle.HOWL>
Message-ID: <alpine.DEB.2.02.1302192258510.19584@icf.org.ru> (sfid-20130219_201211_268833_C0827999)
References: <alpine.DEB.2.02.1302160630580.4293@icf.org.ru> <20130219134028.GA26332@pandem0nium> <alpine.DEB.2.02.1302191752110.31254@icf.org.ru> <CAJ-VmomPkPvABSJtdb6Y=fDNxyd_XtE6sk9yWQzw9qC7rjkwiA@mail.gmail.com> <alpine.DEB.2.02.1302192034420.7450@icf.org.ru>
 <CAJ-VmokUJtowcO0AWpyFLoLN0R0KowETb1BOyjN66rzPSDhjOQ@mail.gmail.com> <20771.50338.434076.484711@gargle.gargle.HOWL> <CAJ-VmokAP6hSxjGDUu7Q5rSg3dvxfLapQBSLgYCvWc9b0YEPgA@mail.gmail.com> <20771.51233.248133.141840@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1050998036-464131293-1361301117=:19584"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1050998036-464131293-1361301117=:19584
Content-Type: TEXT/PLAIN; charset=KOI8-R
Content-Transfer-Encoding: 8BIT

On 2013-02-20 00:14 +0530, Sujith Manoharan wrote Adrian Chadd:

SM>Adrian Chadd wrote:
SM>> It's easy enough to diagnose - just enable NF cal logging. Look at
SM>> what's being read back from the initial NF cal and what's being
SM>> written into the time-series average.
SM>
SM>I discussed this with Felix a while ago, a small log is here:
SM>http://pastebin.ca/2312828 (Note the jump in signal level).
SM>
SM>> It may be that something dumb is happening, like there's no
SM>> per-channel history, or the history from the wrong channel is being
SM>> used on a new channel.
SM>
SM>I am not sure about the dumb part, but ath9k doesn't have per-channel
SM>history or calibration data. :)

hm, i have signal jumps too on some cards, but it's may be a hardware problem,
in one of my case this confirmed by manufacturer, then hi block 2.4 bands on it
where problem occurses, and continue sell it as 5Ggz only card. and i have NF 
calibration jumps on this card too, it easy to se just enable calibration debug
(echo 0x00000008 > /sys/kernel/debug/ieee80211/phy0/ath9k/debug) and watch on 
log with tail -f, you sould se something like this, may be periodicaly:

6.505180] ath: phy0: NF calibrated [ctl] [chain 0] is -68
6.505185] ath: phy0: NF[0] (-68) > MAX (-97), correcting to MAX
6.505188] ath: phy0: NF calibrated [ctl] [chain 1] is -80
6.505191] ath: phy0: NF[1] (-80) > MAX (-97), correcting to MAX
6.505194] ath: phy0: NF calibrated [ext] [chain 0] is -70
6.505197] ath: phy0: NF[3] (-70) > MAX (-97), correcting to MAX
6.505200] ath: phy0: NF calibrated [ext] [chain 1] is -80
6.505204] ath: phy0: NF[4] (-80) > MAX (-97), correcting to MAX

and for example log from normal card:

[61255.118534] ath: phy0: NF calibrated [ctl] [chain 1] is -110
[61255.118544] ath: phy0: NF calibrated [ext] [chain 0] is -108
[61255.118553] ath: phy0: NF calibrated [ext] [chain 1] is -110
[61285.187275] ath: phy0: NF calibrated [ctl] [chain 0] is -109
[61285.187288] ath: phy0: NF calibrated [ctl] [chain 1] is -110
[61285.187297] ath: phy0: NF calibrated [ext] [chain 0] is -108

C уважением                       With Best Regards
Георгиевский Юрий.                Georgiewskiy Yuriy
+7 4872 711666                    +7 4872 711666
факс +7 4872 711143               fax +7 4872 711143
Компания ООО "Ай Ти Сервис"       IT Service Ltd
http://nkoort.ru                  http://nkoort.ru
JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YG129-RIPE                        YG129-RIPE
---1050998036-464131293-1361301117=:19584--
