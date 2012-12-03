Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from icf.org.ru ([91.193.237.1]:35996 "EHLO icf.org.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab2LCPnm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 10:43:42 -0500
Date: Mon, 3 Dec 2012 19:43:41 +0400 (MSK)
From: Georgiewskiy Yuriy <bottleman@icf.org.ru>
To: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: help: 802.11s bad performance with 802.11n enabled
In-Reply-To: <BD54DDEB2546894FAB0731EA7B0EDF8D07C1259A@RockMX01.rock.corp>
Message-ID: <alpine.DEB.2.02.1212031938250.7349@icf.org.ru> (sfid-20121203_164346_083136_9E8F16C5)
References: <BD54DDEB2546894FAB0731EA7B0EDF8D07C1256F@RockMX01.rock.corp> <alpine.DEB.2.02.1212031842350.27546@icf.org.ru> <BD54DDEB2546894FAB0731EA7B0EDF8D07C1259A@RockMX01.rock.corp>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1050998036-646201792-1354549421=:7349"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1050998036-646201792-1354549421=:7349
Content-Type: TEXT/PLAIN; charset=KOI8-R
Content-Transfer-Encoding: 8BIT

On 2012-12-03 14:56 -0000, Chaoxing Lin wrote Georgiewskiy Yuriy:

CL>CL>For experiment, I changed ath9k driver to disable 802.11n packet aggregation. The network becomes much better.
CL>CL>It's as stable as running 802.11a only mode.
CL>CL>So it seems that the aggregation plays a big role in in-stability of 802.11s network with 802.11n.
CL>CL>Any one has any idea why?
CL>
CL>Can you post a patch? i want test this too.
CL>
CL>The change is easy
CL>In ath9k/init.c
CL>Function ath9k_set_hw_capab()
CL>Replace below
CL>    if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT)
CL>         hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
CL>with
CL>	hw->flags &= ~IEEE80211_HW_AMPDU_AGGREGATION; 

On first look in my case disabled aggregation reduces packet loss, 
link is more reliable, but it's also drop throughput to 15-20 Mbits/sec
from about ~50 with aggregation enabled.

C уважением                       With Best Regards
Георгиевский Юрий.                Georgiewskiy Yuriy
+7 4872 711666                    +7 4872 711666
факс +7 4872 711143               fax +7 4872 711143
Компания ООО "Ай Ти Сервис"       IT Service Ltd
http://nkoort.ru                  http://nkoort.ru
JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YG129-RIPE                        YG129-RIPE
---1050998036-646201792-1354549421=:7349--
