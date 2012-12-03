Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from icf.org.ru ([91.193.237.1]:38732 "EHLO icf.org.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751445Ab2LCSd0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 13:33:26 -0500
Date: Mon, 3 Dec 2012 22:33:24 +0400 (MSK)
From: Georgiewskiy Yuriy <bottleman@icf.org.ru>
To: Paul Stoaks <paul@foresight-mands.com>
cc: 'Chaoxing Lin' <Chaoxing.Lin@ultra-3eti.com>,
	linux-wireless@vger.kernel.org
Subject: RE: help: 802.11s bad performance with 802.11n enabled
In-Reply-To: <005601cdd183$14666bf0$3d3343d0$@com>
Message-ID: <alpine.DEB.2.02.1212032231160.348@icf.org.ru> (sfid-20121203_193330_586422_0AD97D9B)
References: <BD54DDEB2546894FAB0731EA7B0EDF8D07C1256F@RockMX01.rock.corp> <alpine.DEB.2.02.1212031842350.27546@icf.org.ru> <BD54DDEB2546894FAB0731EA7B0EDF8D07C1259A@RockMX01.rock.corp> <alpine.DEB.2.02.1212031938250.7349@icf.org.ru>
 <005601cdd183$14666bf0$3d3343d0$@com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1050998036-548867584-1354559604=:348"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1050998036-548867584-1354559604=:348
Content-Type: TEXT/PLAIN; charset=KOI8-R
Content-Transfer-Encoding: 8BIT

On 2012-12-03 10:21 -0800, Paul Stoaks wrote 'Georgiewskiy Yuriy' and...':

i test with ping -A size 64 and 1500 bytes, and with iperf with default parameters plus 
just -c -i1 -t100500

PS>What kind of traffic are you pushing through (packet sizes?)  Are they fixed
PS>size, fixed rate, or ...?
PS>
PS>Paul
PS>
PS>
PS>-----Original Message-----
PS>From: linux-wireless-owner@vger.kernel.org
PS>[mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of Georgiewskiy
PS>Yuriy
PS>Sent: Monday, December 03, 2012 7:44 AM
PS>To: Chaoxing Lin
PS>Cc: linux-wireless@vger.kernel.org
PS>Subject: RE: help: 802.11s bad performance with 802.11n enabled
PS>
PS>On 2012-12-03 14:56 -0000, Chaoxing Lin wrote Georgiewskiy Yuriy:
PS>
PS>CL>CL>For experiment, I changed ath9k driver to disable 802.11n packet
PS>aggregation. The network becomes much better.
PS>CL>CL>It's as stable as running 802.11a only mode.
PS>CL>CL>So it seems that the aggregation plays a big role in in-stability of
PS>802.11s network with 802.11n.
PS>CL>CL>Any one has any idea why?
PS>CL>
PS>CL>Can you post a patch? i want test this too.
PS>CL>
PS>CL>The change is easy
PS>CL>In ath9k/init.c
PS>CL>Function ath9k_set_hw_capab()
PS>CL>Replace below
PS>CL>    if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT)
PS>CL>         hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION; with
PS>CL>	hw->flags &= ~IEEE80211_HW_AMPDU_AGGREGATION;
PS>
PS>On first look in my case disabled aggregation reduces packet loss, link is
PS>more reliable, but it's also drop throughput to 15-20 Mbits/sec from about
PS>~50 with aggregation enabled.
PS>
PS>C уважением                       With Best Regards
PS>Георгиевский Юрий.                Georgiewskiy Yuriy
PS>+7 4872 711666                    +7 4872 711666
PS>факс +7 4872 711143               fax +7 4872 711143
PS>Компания ООО "Ай Ти Сервис"       IT Service Ltd
PS>http://nkoort.ru                  http://nkoort.ru
PS>JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
PS>YG129-RIPE                        YG129-RIPE
PS>
PS>--
PS>To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
PS>the body of a message to majordomo@vger.kernel.org
PS>More majordomo info at  http://vger.kernel.org/majordomo-info.html
PS>

C уважением                       With Best Regards
Георгиевский Юрий.                Georgiewskiy Yuriy
+7 4872 711666                    +7 4872 711666
факс +7 4872 711143               fax +7 4872 711143
Компания ООО "Ай Ти Сервис"       IT Service Ltd
http://nkoort.ru                  http://nkoort.ru
JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YG129-RIPE                        YG129-RIPE
---1050998036-548867584-1354559604=:348--
