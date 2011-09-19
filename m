Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53959 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013Ab1ISQqi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 12:46:38 -0400
Date: Mon, 19 Sep 2011 22:17:15 +0530
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<rodrigue@qca.qualcomm.com>
Subject: Re: [PATCH 12/12] ath9k: do not insert padding into tx buffers on
 AR9380+
Message-ID: <20110919164714.GA1234@vmraj-lnx.users.atheros.com> (sfid-20110919_184642_826475_0BD1BB4B)
References: <1316028267-34187-5-git-send-email-nbd@openwrt.org>
 <1316028267-34187-6-git-send-email-nbd@openwrt.org>
 <1316028267-34187-7-git-send-email-nbd@openwrt.org>
 <1316028267-34187-8-git-send-email-nbd@openwrt.org>
 <1316028267-34187-9-git-send-email-nbd@openwrt.org>
 <1316028267-34187-10-git-send-email-nbd@openwrt.org>
 <1316028267-34187-11-git-send-email-nbd@openwrt.org>
 <1316028267-34187-12-git-send-email-nbd@openwrt.org>
 <20110919144002.GA22040@vmraj-lnx.users.atheros.com>
 <4E7759CA.4010100@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4E7759CA.4010100@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 19, 2011 at 05:03:38PM +0200, Felix Fietkau wrote:
> On 2011-09-19 4:40 PM, Rajkumar Manoharan wrote:
> >On Wed, Sep 14, 2011 at 09:24:27PM +0200, Felix Fietkau wrote:
> >> With the new EDMA descriptor format, a single descriptor can contain up
> >> to four buffer pointers. By splitting the buffer into two parts, we can
> >> let the hardware add the padding internally instead of using memmove on
> >> the skb data.
> >>
> >> Signed-off-by: Felix Fietkau<nbd@openwrt.org>
> >> ---
> >>  drivers/net/wireless/ath/ath9k/xmit.c |   56 +++++++++++++++++++++-----------
> >>  1 files changed, 37 insertions(+), 19 deletions(-)
> >>
> >Felix,
> >
> >This patch again introduced "ath: Failed to stop TX DMA!" for AR9380+ chips.
> >After reverting this, the errors are completely gone away. Please look into this ASAP.
> How frequent are these errors in your tests? I ran several tests on
> embedded hardware with AR9380 and didn't notice any issues.
With this patch after the association and in idle state, the connection seems to be very unstable.
Please refer the following log. 

--
Rajkumar
Sep 19 22:05:44 localhost kernel: [   85.170229] ieee80211 phy0: device no longer idle - scanning
Sep 19 22:05:48 localhost kernel: [   89.068830] ieee80211 phy0: device now idle
Sep 19 22:05:48 localhost kernel: [   89.071068] ieee80211 phy0: device no longer idle - working
Sep 19 22:05:48 localhost kernel: [   89.073040] wlan0: authenticate with 00:03:7f:0b:a6:1b (try 1)
Sep 19 22:05:48 localhost kernel: [   89.074958] wlan0: authenticated
Sep 19 22:05:48 localhost kernel: [   89.074980] ieee80211 phy0: Allocated STA 00:03:7f:0b:a6:1b
Sep 19 22:05:48 localhost kernel: [   89.074984] ieee80211 phy0: Inserted dummy STA 00:03:7f:0b:a6:1b
Sep 19 22:05:48 localhost kernel: [   89.074994] wlan0: associate with 00:03:7f:0b:a6:1b (try 1)
Sep 19 22:05:48 localhost kernel: [   89.079027] wlan0: RX AssocResp from 00:03:7f:0b:a6:1b (capab=0x21 status=0 aid=1)
Sep 19 22:05:48 localhost kernel: [   89.079031] wlan0: associated
Sep 19 22:05:48 localhost kernel: [   89.079114] ieee80211 phy0: Inserted STA 00:03:7f:0b:a6:1b
Sep 19 22:05:48 localhost kernel: [   89.079119] ieee80211 phy0: WMM queue=2 aci=0 acm=0 aifs=3 cWmin=15 cWmax=1023 txop=0 uapsd=0
Sep 19 22:05:48 localhost kernel: [   89.079125] ieee80211 phy0: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15 cWmax=1023 txop=0 uapsd=0
Sep 19 22:05:48 localhost kernel: [   89.079131] ieee80211 phy0: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15 txop=94 uapsd=0
Sep 19 22:05:48 localhost kernel: [   89.079137] ieee80211 phy0: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 txop=47 uapsd=0
Sep 19 22:05:48 localhost kernel: [   89.081580] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Sep 19 22:05:48 localhost kernel: [   89.086962] Open BA session requested for 00:03:7f:0b:a6:1b tid 0
Sep 19 22:05:48 localhost kernel: [   89.096789] activated addBA response timer on tid 0
Sep 19 22:05:48 localhost kernel: [   89.098850] switched off addBA timer for tid 0
Sep 19 22:05:48 localhost kernel: [   89.098852] Aggregation is on for tid 0
Sep 19 22:05:49 localhost kernel: [   89.535843] ath: Failed to stop TX DMA!
Sep 19 22:05:49 localhost kernel: [   89.542849] ath: Failed to stop TX DMA!
Sep 19 22:05:51 localhost kernel: [   91.561998] ath: Failed to stop TX DMA!
Sep 19 22:05:56 localhost kernel: [   96.638656] ath: Failed to stop TX DMA!
Sep 19 22:05:56 localhost kernel: [   97.065752] ath: Failed to stop TX DMA!
Sep 19 22:05:56 localhost kernel: [   97.072759] ath: Failed to stop TX DMA!
Sep 19 22:05:57 localhost kernel: [   97.512480] ath: Failed to stop TX DMA!
Sep 19 22:05:57 localhost kernel: [   97.519489] ath: Failed to stop TX DMA!
Sep 19 22:05:59 localhost kernel: [  100.043425] wlan0: no IPv6 routers present
Sep 19 22:06:00 localhost kernel: [  100.541988] ath: Failed to stop TX DMA!
Sep 19 22:06:31 localhost kernel: [  131.860090] ieee80211 phy0: wlan0: Failed to send nullfunc to AP 00:03:7f:0b:a6:1b after 500ms, disconnecting.
Sep 19 22:06:31 localhost kernel: [  131.860114] Tx BA session stop requested for 00:03:7f:0b:a6:1b tid 0
Sep 19 22:06:31 localhost kernel: [  131.869103] ath: Failed to stop TX DMA!
Sep 19 22:06:31 localhost kernel: [  131.871102] Tx BA session stop requested for 00:03:7f:0b:a6:1b tid 0
Sep 19 22:06:31 localhost kernel: [  131.900106] ieee80211 phy0: Removed STA 00:03:7f:0b:a6:1b
Sep 19 22:06:31 localhost kernel: [  131.900170] ieee80211 phy0: Destroyed STA 00:03:7f:0b:a6:1b
Sep 19 22:06:31 localhost kernel: [  131.900176] ieee80211 phy0: device now idle
Sep 19 22:06:31 localhost kernel: [  131.902326] cfg80211: Calling CRDA to update world regulatory domain
Sep 19 22:06:31 localhost kernel: [  131.902344] Stopping Tx BA session for 00:03:7f:0b:a6:1b tid 0
Sep 19 22:06:31 localhost kernel: [  131.902345] Could not find station: 00:03:7f:0b:a6:1b
Sep 19 22:06:31 localhost kernel: [  131.902347] Stopping Tx BA session for 00:03:7f:0b:a6:1b tid 0
Sep 19 22:06:31 localhost kernel: [  131.902348] Could not find station: 00:03:7f:0b:a6:1b
Sep 19 22:06:31 localhost kernel: [  131.904407] cfg80211: World regulatory domain updated:
Sep 19 22:06:31 localhost kernel: [  131.904410] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Sep 19 22:06:31 localhost kernel: [  131.904412] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep 19 22:06:31 localhost kernel: [  131.904414] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep 19 22:06:31 localhost kernel: [  131.904416] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Sep 19 22:06:31 localhost kernel: [  131.904418] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Sep 19 22:06:31 localhost kernel: [  131.904420] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
