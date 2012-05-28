Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from claranet-outbound-smtp02.uk.clara.net ([195.8.89.35]:52550 "EHLO
	claranet-outbound-smtp02.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753089Ab2E1O22 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 May 2012 10:28:28 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Subject: Re: ath9k stops working (DMA trouble?) shortly after going online
Date: Mon, 28 May 2012 15:28:15 +0100
Cc: ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
References: <201205281316.15008.tvrtko.ursulin@onelan.co.uk> <CAD2nsn26Ey+ws4D82LSSsCT2mB5NhQ-35Dts9xx=6=JyDzYPPQ@mail.gmail.com>
In-Reply-To: <CAD2nsn26Ey+ws4D82LSSsCT2mB5NhQ-35Dts9xx=6=JyDzYPPQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_/t4wP13pEIVPRTe"
Message-Id: <201205281528.15852.tvrtko.ursulin@onelan.co.uk> (sfid-20120528_162832_854374_AA26E3DE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_/t4wP13pEIVPRTe
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

On Monday 28 May 2012 14:01:41 Mohammed Shafi wrote:
> On Mon, May 28, 2012 at 5:46 PM, Tvrtko Ursulin
> 
> <tvrtko.ursulin@onelan.co.uk> wrote:
> > Hi all,
> > 
> > This is on kernel 3.3.2, with the following hardware:
> > 
> > 03:00.0 Network controller: Atheros Communications Inc. AR928X Wireless
> > Network Adapter (PCI-Express) (rev 01)
> > 
> > dmesg below. I wonder if this is a known issue and I should try
> > X, Y or Z for a fix? Or any other info / debugging you would like
> > me to do just ask.
> 
> can you  please try if this helps
> http://www.spinics.net/lists/linux-wireless/msg90835.html

I have switched to today's git for testing where I could reproduce the 
problem. Then on top of that I tried the suggested patch but unfortunately 
breakage is still there and looks similar to me. New dmesg attached.

Regards,

Tvrtko

--Boundary-00=_/t4wP13pEIVPRTe
Content-Type: text/plain;
  name="dmesg"
Content-Transfer-Encoding: 7bit

[   12.836411] wlan0: authenticate with 00:24:82:39:da:c8
[   12.846756] wlan0: No basic rates, using min rate instead.
[   12.847878] wlan0: direct probe to 00:24:82:39:da:c8 (try 1/3)
[   13.048492] wlan0: send auth to 00:24:82:39:da:c8 (try 2/3)
[   13.051356] wlan0: authenticated
[   13.052492] wlan0: associate with 00:24:82:39:da:c8 (try 1/3)
[   13.055208] wlan0: RX AssocResp from 00:24:82:39:da:c8 (capab=0x411 status=0 aid=1)
[   13.055218] wlan0: associated
[   13.056366] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[   13.056671] cfg80211: Calling CRDA for country: GB
[   13.067662] ath: regdomain 0x833a updated by CountryIE
[   13.067673] ath: EEPROM regdomain: 0x833a
[   13.067677] ath: EEPROM indicates we should expect a country code
[   13.067683] ath: doing EEPROM country->regdmn map search
[   13.067689] ath: country maps to regdmn code: 0x37
[   13.067694] ath: Country alpha2 being used: GB
[   13.067698] ath: Regpair used: 0x37
[   13.067787] cfg80211: Regulatory domain changed to country: GB
[   13.067792] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   13.067799] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   13.067806] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   13.067812] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   13.067817] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[   15.544715] systemd[1]: ntpd.service changed stop-sigterm -> final-sigterm
[   16.054375] wlan0: deauthenticated from 00:24:82:39:da:c8 (Reason: 6)
[   16.064125] cfg80211: Calling CRDA to update world regulatory domain
[   16.077421] cfg80211: World regulatory domain updated:
[   16.077432] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   16.077440] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   16.077448] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   16.077455] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[   16.077461] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   16.077468] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[   16.077506] cfg80211: Calling CRDA for country: GB
[   16.091379] cfg80211: Regulatory domain changed to country: GB
[   16.091390] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   16.091398] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   16.091404] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   16.091411] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   16.091416] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[   20.414173] wlan0: authenticate with 00:24:82:39:da:c8
[   20.421279] wlan0: No basic rates, using min rate instead.
[   20.421372] wlan0: send auth to 00:24:82:39:da:c8 (try 1/3)
[   20.423130] wlan0: authenticated
[   20.423953] wlan0: associate with 00:24:82:39:da:c8 (try 1/3)
[   20.426005] wlan0: RX AssocResp from 00:24:82:39:da:c8 (capab=0x411 status=0 aid=1)
[   20.426017] wlan0: associated
[   20.426790] cfg80211: Calling CRDA for country: GB
[   20.436335] ath: regdomain 0x833a updated by CountryIE
[   20.436342] ath: EEPROM regdomain: 0x833a
[   20.436345] ath: EEPROM indicates we should expect a country code
[   20.436350] ath: doing EEPROM country->regdmn map search
[   20.436353] ath: country maps to regdmn code: 0x37
[   20.436356] ath: Country alpha2 being used: GB
[   20.436359] ath: Regpair used: 0x37
[   20.436423] cfg80211: Regulatory domain changed to country: GB
[   20.436427] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[   20.436431] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   20.436435] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   20.436439] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   20.436443] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[  500.170746] ath: phy0: Failed to stop TX DMA, queues=0x005!
[  525.248191] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x000062c0
[  525.248204] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  525.263668] ath: phy0: Failed to stop TX DMA, queues=0x005!
[  525.275796] cfg80211: Calling CRDA to update world regulatory domain
[  525.289076] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  525.292025] cfg80211: World regulatory domain updated:
[  525.292033] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  525.292038] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  525.292041] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  525.292045] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[  525.292048] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  525.292051] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[  525.292240] cfg80211: Calling CRDA for country: GB
[  525.305538] cfg80211: Regulatory domain changed to country: GB
[  525.305546] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  525.305550] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  525.305553] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  525.305556] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  525.305559] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
[  525.399382] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  525.399396] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  525.478836] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  525.478849] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  525.486902] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  525.566713] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  525.566726] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  525.574782] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  525.654851] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  525.654864] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  525.662938] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  525.742569] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  525.742582] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  525.750645] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  525.830603] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  525.830616] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  525.838690] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  525.918202] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  525.918215] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  525.926263] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  526.006066] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  526.006080] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  526.014150] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  526.093900] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  526.093913] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  526.101970] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  526.181736] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  526.181749] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  526.189787] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  526.269651] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  526.269664] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  526.277689] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  526.357501] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  526.357515] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  526.365623] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  526.510483] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  526.510497] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  526.655087] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  526.655100] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  526.799810] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  526.799823] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  526.944570] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  526.944583] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  527.089304] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  527.089318] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  527.234090] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  527.234103] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  527.378888] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  527.378902] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  527.523703] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  527.523717] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  527.668477] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  527.668490] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  527.813171] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  527.813185] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  527.958034] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  527.958048] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  528.102772] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  528.102786] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  528.247715] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  528.247728] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  528.393590] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  528.393602] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  528.539088] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  528.539102] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  528.683888] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  528.683902] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  528.828628] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  528.828642] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  528.973354] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  528.973367] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  529.118129] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  529.118143] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  529.263021] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  529.263034] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  529.407701] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  529.407715] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  529.552515] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  529.552529] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  529.697262] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  529.697275] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  529.842009] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  529.842023] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  529.986809] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  529.986822] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  530.131531] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  530.131545] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  530.276959] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  530.276973] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  530.298064] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  535.291613] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  535.291627] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  535.371422] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  535.371436] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  535.379510] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  535.459282] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  535.459296] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  535.467447] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  535.547068] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  535.547082] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  535.555166] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  535.634942] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  535.634956] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  535.643024] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  535.722913] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  535.722927] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  535.731087] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  535.810655] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  535.810669] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  535.818824] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  535.898532] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  535.898546] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  535.906614] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  535.986527] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  535.986540] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  535.994612] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  536.074258] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  536.074270] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  536.082340] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  536.162261] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  536.162274] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  536.170341] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  536.250047] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  536.250060] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  536.258124] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  536.402859] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  536.402874] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  536.547540] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  536.547553] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  536.692523] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  536.692537] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  536.838048] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  536.838062] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  536.982809] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  536.982823] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  537.127651] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  537.127665] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  537.272379] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  537.272393] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  537.417222] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  537.417235] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  537.562007] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  537.562021] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  537.706701] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  537.706716] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  537.851489] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  537.851503] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  537.996249] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  537.996262] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  538.141049] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  538.141063] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  538.285887] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  538.285901] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  538.430594] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  538.430607] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  538.575422] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  538.575435] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  538.720181] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  538.720194] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  538.864887] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  538.864900] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  539.010885] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  539.010898] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  539.156445] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  539.156460] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  539.301193] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  539.301206] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  539.445967] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  539.445981] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  539.590765] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  539.590778] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  539.735592] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  539.735606] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  539.880368] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  539.880381] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  540.025191] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  540.025204] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  540.170924] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  540.170938] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  540.191369] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  545.183974] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  545.183987] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  545.263875] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  545.263888] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  545.271965] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  545.351908] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  545.351921] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  545.360017] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  545.439601] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  545.439614] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  545.447693] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  545.527463] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  545.527475] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  545.535546] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  545.615336] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  545.615349] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  545.623409] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  545.703266] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  545.703279] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  545.711345] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  545.791153] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  545.791166] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  545.799274] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  545.878927] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  545.878940] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  545.886996] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  545.966761] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  545.966774] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  545.974833] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  546.054718] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  546.054731] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  546.062800] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  546.142500] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  546.142514] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  546.150670] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  546.295314] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  546.295327] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  546.440034] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  546.440047] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  546.584860] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  546.584874] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  546.729608] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  546.729620] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  546.874447] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  546.874460] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  547.019180] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  547.019194] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  547.163955] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  547.163968] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  547.308780] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  547.308794] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  547.453462] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  547.453476] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  547.598221] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  547.598233] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  547.742749] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  547.742758] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  547.887769] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  547.887783] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  548.032611] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  548.032624] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  548.177422] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  548.177435] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  548.322168] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  548.322181] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  548.466941] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  548.466954] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  548.611740] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  548.611754] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  548.756409] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  548.756421] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  548.901186] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  548.901199] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  549.045978] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  549.045991] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  549.190773] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  549.190786] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  549.335569] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  549.335582] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  549.480353] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  549.480365] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  549.625423] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  549.625436] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  549.771009] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  549.771023] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  549.915804] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  549.915817] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  550.060613] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  550.060626] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  550.082642] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  555.073781] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  555.073795] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  555.153426] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  555.153440] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  555.161552] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  555.241222] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  555.241236] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  555.249354] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  555.329151] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  555.329164] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  555.337230] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  555.417014] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  555.417028] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  555.425099] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  555.505586] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  555.505600] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  555.513647] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  555.593722] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  555.593735] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  555.601767] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  555.681600] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  555.681613] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  555.689666] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  555.769516] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  555.769530] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  555.777675] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  555.857430] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  555.857444] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  555.865499] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  555.944930] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  555.944939] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  555.952754] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  556.032117] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  556.032130] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  556.040192] ath: phy0: Failed to stop TX DMA, queues=0x001!
[  556.184886] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  556.184898] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  556.329735] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  556.329749] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  556.474492] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  556.474506] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  556.619325] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  556.619339] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  556.764121] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  556.764135] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  556.908917] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  556.908931] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  557.053737] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  557.053751] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  557.199463] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  557.199476] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  557.344231] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  557.344245] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  557.489091] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  557.489104] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  557.633835] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  557.633848] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  557.778618] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00006040
[  557.778631] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  557.923478] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  557.923491] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  558.068274] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  558.068287] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  558.213042] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  558.213055] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  558.357811] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  558.357824] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  558.502658] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  558.502671] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  558.647427] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  558.647440] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  558.792300] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  558.792313] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  558.937069] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  558.937082] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  559.081824] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  559.081837] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  559.226607] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  559.226620] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  559.371386] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  559.371399] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  559.516209] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  559.516222] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  559.660949] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  559.660962] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  559.805810] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  559.805823] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  559.950578] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  559.950591] ath: phy0: Could not stop RX, we could be confusing the DMA engine when we start RX up
[  559.971523] ath: phy0: DMA failed to stop in 10 ms AR_CR=0x00000024 AR_DIAG_SW=0x42000020 DMADBG_7=0x00008040
[  569.265990] wlan0: authenticate with 00:24:82:39:da:c8
[  569.273087] wlan0: No basic rates, using min rate instead.
[  569.274928] wlan0: direct probe to 00:24:82:39:da:c8 (try 1/3)
[  569.477528] wlan0: send auth to 00:24:82:39:da:c8 (try 2/3)
[  569.478408] wlan0: authenticated
[  569.479741] wlan0: associate with 00:24:82:39:da:c8 (try 1/3)
[  569.482352] wlan0: RX AssocResp from 00:24:82:39:da:c8 (capab=0x411 status=0 aid=1)
[  569.482361] wlan0: associated
[  569.483581] cfg80211: Calling CRDA for country: GB
[  569.500730] ath: regdomain 0x833a updated by CountryIE
[  569.500737] ath: EEPROM regdomain: 0x833a
[  569.500740] ath: EEPROM indicates we should expect a country code
[  569.500744] ath: doing EEPROM country->regdmn map search
[  569.500746] ath: country maps to regdmn code: 0x37
[  569.500749] ath: Country alpha2 being used: GB
[  569.500751] ath: Regpair used: 0x37
[  569.500807] cfg80211: Regulatory domain changed to country: GB
[  569.500809] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[  569.500813] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  569.500816] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  569.500819] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  569.500822] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)

--Boundary-00=_/t4wP13pEIVPRTe--
