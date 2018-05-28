Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:40114 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S938914AbeE1Mun (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 May 2018 08:50:43 -0400
Date: Mon, 28 May 2018 14:50:40 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Kofi Agor <nenekofi@gmail.com>
Cc: Enrico Mioso <mrkiko.rs@gmail.com>,
        Craig Matsuura <cmatsuura@vivint.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>,
        Tom Psyborg <pozega.tomislav@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, John Crispin <john@phrozen.org>,
        Felix Fietkau <nbd@nbd.name>,
        Jamie Stuart <jamie@onebillion.org>
Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
 frame due to full tx queue...?
Message-ID: <20180528125039.GA22122@redhat.com> (sfid-20180528_145059_943808_057B59A8)
References: <20180327171815.GA31338@redhat.com>
 <20180327174302.GB1206@makrotopia.org>
 <alpine.LNX.2.21.99.1803280605580.2911@mStation.localdomain>
 <CAOt++SeSQ2j1KuVkbqt77LfznXN7JV0Lx5O8d7-m2VBrz8=85g@mail.gmail.com>
 <alpine.LNX.2.21.99.1803301642110.31428@mStation.localdomain>
 <MWHPR02MB3326233159B021143D7278F5D4A10@MWHPR02MB3326.namprd02.prod.outlook.com>
 <alpine.LNX.2.21.99.1803301931300.5692@mStation.localdomain>
 <CAOt++SeLh_NxcmM=YEMQSv4y9PabS_dT7k4yTxUiqXbac-=iUQ@mail.gmail.com>
 <20180417194255.GA17067@redhat.com>
 <CAOt++SeNt=4RUTvAR1y_WjC=a-YyYa3YBSmoAmv+7uK71U+3+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAOt++SeNt=4RUTvAR1y_WjC=a-YyYa3YBSmoAmv+7uK71U+3+A@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have some updates here.

First thing is that printing messages by printk can cause few seconds 
of cpu hang on my mt7620 hardware, what result on wifi disconnects.
I realized that when added debug patch like this:

diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 595c662a61e8..de2643f7189f 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -135,6 +135,8 @@ void ieee80211_send_bar(struct ieee80211_vif *vif, u8 *ra, u16 tid, u16 ssn)
 	bar->control = cpu_to_le16(bar_control);
 	bar->start_seq_num = cpu_to_le16(ssn);
 
+	printk("%s tid %d ssn %04x %d\n", __func__, tid, ssn , ssn >> 4);
+
 	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT |
 					IEEE80211_TX_CTL_REQ_TX_STATUS;
 	ieee80211_tx_skb_tid(sdata, skb, tid);

This patch alone cause wifi disconnects. I don't know where problem is, but
remove printing i.e. rt2x00_warn() messages can be thing to check if you
observe wifi disconnects.

Another issue is BA ssn mishmashes which I can observe. Those were
causing by older rt2800 usb hardware not responding correctly to BAR
frame. I.e for BAR frame with SSN 0x0060 (6), it responded BA with
SSN 7fe0 (2046). Removing of posting BAR by this patch:

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
index 357c0941aaad..7e2786464bcf 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -382,9 +382,6 @@ static void rt2x00lib_fill_tx_status(struct rt2x00_dev *rt2x00dev,
 				  IEEE80211_TX_CTL_AMPDU;
 		tx_info->status.ampdu_len = 1;
 		tx_info->status.ampdu_ack_len = success ? 1 : 0;
-
-		if (!success)
-			tx_info->flags |= IEEE80211_TX_STAT_AMPDU_NO_BACK;
 	}
 
 	if (rate_flags & IEEE80211_TX_RC_USE_RTS_CTS) {

solved the problem and improved performance when connecting with this
older rt2800 usb device. Even if other rt2800 usb devices respond with
correct solicit BA SSN this change is beneficial when connecting two
rt2800 devices. Unfortunately sending BAR seems to be needed for
some stations, so this need to be investigated a bit more.

Another issue is that sometimes we do not sent rate probe frames,
I posted fix for that (revert of my older change):
https://marc.info/?l=linux-wireless&m=152750671715369&w=2 
This patch improve performance when mt7620 is connected with Intel iwl7265
device. With the patch I have 70 Mbits/sec compared to about 17 Mbits/sec
before. Perhaps it also fix stability issues.

Stanislaw
