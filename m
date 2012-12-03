Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ultra-3eti.com ([173.13.207.162]:50938 "EHLO
	mail.ultra-3eti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab2LCTCR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 14:02:17 -0500
From: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
To: "paul@foresight-mands.com" <paul@foresight-mands.com>,
	"'Georgiewskiy Yuriy'" <bottleman@icf.org.ru>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: help: 802.11s bad performance with 802.11n enabled
Date: Mon, 3 Dec 2012 19:02:13 +0000
Message-ID: <BD54DDEB2546894FAB0731EA7B0EDF8D07C1263C@RockMX01.rock.corp> (sfid-20121203_200220_819537_1806C97D)
References: <BD54DDEB2546894FAB0731EA7B0EDF8D07C1256F@RockMX01.rock.corp>
 <alpine.DEB.2.02.1212031842350.27546@icf.org.ru>
 <BD54DDEB2546894FAB0731EA7B0EDF8D07C1259A@RockMX01.rock.corp>
 <alpine.DEB.2.02.1212031938250.7349@icf.org.ru>
 <005601cdd183$14666bf0$3d3343d0$@com>
In-Reply-To: <005601cdd183$14666bf0$3d3343d0$@com>
Content-Type: text/plain; charset="koi8-r"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My test is very simple.

Continuous ping at about 10 ping per node per second.
Ping size 64 bytes


-----Original Message-----
From: Paul Stoaks [mailto:paul@foresight-mands.com] 
Sent: Monday, December 03, 2012 1:22 PM
To: 'Georgiewskiy Yuriy'; Chaoxing Lin
Cc: linux-wireless@vger.kernel.org
Subject: RE: help: 802.11s bad performance with 802.11n enabled

What kind of traffic are you pushing through (packet sizes?)  Are they fixed size, fixed rate, or ...?

Paul


-----Original Message-----
From: linux-wireless-owner@vger.kernel.org
[mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of Georgiewskiy Yuriy
Sent: Monday, December 03, 2012 7:44 AM
To: Chaoxing Lin
Cc: linux-wireless@vger.kernel.org
Subject: RE: help: 802.11s bad performance with 802.11n enabled

On 2012-12-03 14:56 -0000, Chaoxing Lin wrote Georgiewskiy Yuriy:

CL>CL>For experiment, I changed ath9k driver to disable 802.11n packet
aggregation. The network becomes much better.
CL>CL>It's as stable as running 802.11a only mode.
CL>CL>So it seems that the aggregation plays a big role in in-stability 
CL>CL>of
802.11s network with 802.11n.
CL>CL>Any one has any idea why?
CL>
CL>Can you post a patch? i want test this too.
CL>
CL>The change is easy
CL>In ath9k/init.c
CL>Function ath9k_set_hw_capab()
CL>Replace below
CL>    if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT)
CL>         hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION; with
CL>	hw->flags &= ~IEEE80211_HW_AMPDU_AGGREGATION;

On first look in my case disabled aggregation reduces packet loss, link is more reliable, but it's also drop throughput to 15-20 Mbits/sec from about
~50 with aggregation enabled.

C уважением                       With Best Regards
Георгиевский Юрий.                Georgiewskiy Yuriy
+7 4872 711666                    +7 4872 711666
факс +7 4872 711143               fax +7 4872 711143
Компания ООО "Ай Ти Сервис"       IT Service Ltd
http://nkoort.ru                  http://nkoort.ru
JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YG129-RIPE                        YG129-RIPE

