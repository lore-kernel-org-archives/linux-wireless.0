Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from icf.org.ru ([91.193.236.10]:55401 "EHLO icf.org.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762765Ab2DLUoe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Apr 2012 16:44:34 -0400
Date: Thu, 12 Apr 2012 23:53:56 +0400 (MSK)
From: Georgiewskiy Yuriy <bottleman@icf.org.ru>
To: Ben Greear <greearb@candelatech.com>
cc: Florian Fainelli <florian@openwrt.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 4/5] mac80211: Add more ethtools stats: survey, rates,
 etc
In-Reply-To: <4F870828.4020708@candelatech.com>
Message-ID: <alpine.DEB.2.02.1204122352001.29503@icf.org.ru> (sfid-20120412_224451_824525_FDE3F3A1)
References: <1334248375-22967-1-git-send-email-greearb@candelatech.com> <1334248375-22967-5-git-send-email-greearb@candelatech.com> <4F8705E3.2010902@openwrt.org> <4F870828.4020708@candelatech.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1050998036-1367714212-1334260436=:29503"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1050998036-1367714212-1334260436=:29503
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On 2012-04-12 09:51 -0700, Ben Greear wrote Florian Fainelli:

BG>On 04/12/2012 09:42 AM, Florian Fainelli wrote:
BG>> Hi,
BG>> 
BG>> Le 04/12/12 18:32, greearb@candelatech.com a ?crit :
BG>> > From: Ben Greear<greearb@candelatech.com>
BG>> > 
BG>> > The signal and noise are forced to be positive since ethtool
BG>> > deals in unsigned 64-bit values and this number should be human
BG>> > readable. This gives easy access to some of the data formerly
BG>> > exposed in the deprecated /proc/net/wireless file.
BG>> 
BG>> Uh, that's misleading, the signal and noise values are typically negative,
BG>> so one needs to think about mentally adding a minus sign if he/she wants to
BG>> understand it. Does not ethtool know about 32-bits signed integers?
BG>
BG>Ethtool stats only supports u64.  I think it's easy enough for
BG>humans or programs to add the negative sign.  Can signal or noise
BG>ever be > 0?  If so, that could actually break something that depends
BG>on flipping the value to negative....

Don't know is this is a bug or it's reaaly can be positive, but:

iw dev mp0 station dump
Station 00:02:6f:b8:94:d3 (on mp0)
    inactive time:	49 ms
    rx bytes:	36318341
    rx packets:	271741
    tx bytes:	4180152
    tx packets:	35445
    tx retries:	7724
    tx failed:	123
    signal:  	1 dBm
    signal avg:	-2 dBm
    tx bitrate:	240.0 MBit/s MCS 13 40Mhz short GI
    rx bitrate:	180.0 MBit/s MCS 12 40Mhz short GI
    mesh llid:	8349
    mesh plid:	49801
    mesh plink:	ESTAB
    authorized:	yes
    authenticated:	yes
    preamble:	long
    WMM/WME:	yes
    FP:		no
    TDLS peer:	no
										    

C уважением                       With Best Regards
Георгиевский Юрий.                Georgiewskiy Yuriy
+7 4872 711666                    +7 4872 711666
факс +7 4872 711143               fax +7 4872 711143
Компания ООО "Ай Ти Сервис"       IT Service Ltd
http://nkoort.ru                  http://nkoort.ru
JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YG129-RIPE                        YG129-RIPE
---1050998036-1367714212-1334260436=:29503--
