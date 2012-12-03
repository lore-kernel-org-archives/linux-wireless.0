Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vmail02-lax.tokbox.com ([72.51.46.97]:42516 "EHLO
	ns.stoaks-software.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1750794Ab2LCSV7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 13:21:59 -0500
Reply-To: <paul@foresight-mands.com>
From: "Paul Stoaks" <paul@foresight-mands.com>
To: "'Georgiewskiy Yuriy'" <bottleman@icf.org.ru>,
	"'Chaoxing Lin'" <Chaoxing.Lin@ultra-3eti.com>
Cc: <linux-wireless@vger.kernel.org>
References: <BD54DDEB2546894FAB0731EA7B0EDF8D07C1256F@RockMX01.rock.corp> <alpine.DEB.2.02.1212031842350.27546@icf.org.ru> <BD54DDEB2546894FAB0731EA7B0EDF8D07C1259A@RockMX01.rock.corp> <alpine.DEB.2.02.1212031938250.7349@icf.org.ru>
In-Reply-To: <alpine.DEB.2.02.1212031938250.7349@icf.org.ru>
Subject: RE: help: 802.11s bad performance with 802.11n enabled
Date: Mon, 3 Dec 2012 10:21:56 -0800
Message-ID: <005601cdd183$14666bf0$3d3343d0$@com> (sfid-20121203_192203_296077_96868BC7)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="KOI8-R"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

What kind of traffic are you pushing through (packet sizes?)  Are they fixed
size, fixed rate, or ...?

Paul


-----Original Message-----
From: linux-wireless-owner@vger.kernel.org
[mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of Georgiewskiy
Yuriy
Sent: Monday, December 03, 2012 7:44 AM
To: Chaoxing Lin
Cc: linux-wireless@vger.kernel.org
Subject: RE: help: 802.11s bad performance with 802.11n enabled

On 2012-12-03 14:56 -0000, Chaoxing Lin wrote Georgiewskiy Yuriy:

CL>CL>For experiment, I changed ath9k driver to disable 802.11n packet
aggregation. The network becomes much better.
CL>CL>It's as stable as running 802.11a only mode.
CL>CL>So it seems that the aggregation plays a big role in in-stability of
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

On first look in my case disabled aggregation reduces packet loss, link is
more reliable, but it's also drop throughput to 15-20 Mbits/sec from about
~50 with aggregation enabled.

C уважением                       With Best Regards
Георгиевский Юрий.                Georgiewskiy Yuriy
+7 4872 711666                    +7 4872 711666
факс +7 4872 711143               fax +7 4872 711143
Компания ООО "Ай Ти Сервис"       IT Service Ltd
http://nkoort.ru                  http://nkoort.ru
JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
YG129-RIPE                        YG129-RIPE

