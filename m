Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:44280 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755478AbeCHJjn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Mar 2018 04:39:43 -0500
Date: Thu, 8 Mar 2018 10:39:39 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Jamie Stuart <jamie@onebillion.org>
Cc: Daniel Golle <daniel@makrotopia.org>,
        Enrico Mioso <mrkiko.rs@gmail.com>,
        Tom Psyborg <pozega.tomislav@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, John Crispin <john@phrozen.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
 frame due to full tx queue...?
Message-ID: <20180308093938.GA2266@redhat.com> (sfid-20180308_103948_214911_47964E2A)
References: <20180103113540.GA10306@redhat.com>
 <alpine.LNX.2.21.99.1801031503370.8405@localhost.localdomain>
 <CAKR_QVLRwAA0NJSarX46J4A8XSp8h5SuTEtSBQ4ydpEPh_-aUw@mail.gmail.com>
 <alpine.LNX.2.21.99.1801220643400.32225@mStation.localdomain>
 <20180123132234.GC2520@redhat.com>
 <alpine.LNX.2.21.99.1801240917001.13679@mStation.localdomain>
 <20180124100316.GB3101@redhat.com>
 <20180301153006.GJ1233@makrotopia.org>
 <20180307122701.GA10584@redhat.com>
 <7B51BD3B-CAC3-479B-B06E-637A1C3A678A@onebillion.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="NzB8fVQJ5HfG6fxh"
In-Reply-To: <7B51BD3B-CAC3-479B-B06E-637A1C3A678A@onebillion.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hi

On Wed, Mar 07, 2018 at 05:47:34PM +0200, Jamie Stuart wrote:
> config wifi-device 'radio0'
> 	option type 'mac80211'
> 	option channel 'auto'

To make reproducible testing results I would suggest to setup a channel,
(choose one that is the less used by other wireless networks),
problem may happen on some channels and not happen on other.

> The 30 clients are all Apple iPads (a mixture of iPad mini and mini 2, running iOS 9-11). During this testing period, all clients were simultaneously downloading files from the devices’ sdcard (served via nginx running on the device). Although this is not a typical use-case, it was useful in stress-testing the wireless setup.

For such scenario I would suggest hardcode ba_size = 0 and see if that
would help.

I also attach another patch, can be applied on top of two previous.
This one should give RX hardware more time to provide proper BlockACK
frame, so hopefully could help with seq mismashes.

Stanislaw

--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="rt2800_change_rx_ampdu_density.patch"

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index e68f7f9d48f8..95f20072a219 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -9286,7 +9286,7 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	spec->ht.cap |= rx_chains << IEEE80211_HT_CAP_RX_STBC_SHIFT;
 
 	spec->ht.ampdu_factor = 0;
-	spec->ht.ampdu_density = 4;
+	spec->ht.ampdu_density = 7;
 	spec->ht.mcs.tx_params = IEEE80211_HT_MCS_TX_DEFINED;
 	if (tx_chains != rx_chains) {
 		spec->ht.mcs.tx_params |= IEEE80211_HT_MCS_TX_RX_DIFF;

--NzB8fVQJ5HfG6fxh--
