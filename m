Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:34050 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727823AbeHPOB6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Aug 2018 10:01:58 -0400
Date: Thu, 16 Aug 2018 13:01:04 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Kofi Agor <nenekofi@gmail.com>, Enrico Mioso <mrkiko.rs@gmail.com>,
        Craig Matsuura <cmatsuura@vivint.com>,
        Mathias Kresin <dev@kresin.me>,
        Tom Psyborg <pozega.tomislav@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        Jamie Stuart <jamie@onebillion.org>
Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
 frame due to full tx queue...?
Message-ID: <20180816110103.GB2797@redhat.com> (sfid-20180816_130412_532444_8CAC041B)
References: <CAOt++SeSQ2j1KuVkbqt77LfznXN7JV0Lx5O8d7-m2VBrz8=85g@mail.gmail.com>
 <alpine.LNX.2.21.99.1803301642110.31428@mStation.localdomain>
 <MWHPR02MB3326233159B021143D7278F5D4A10@MWHPR02MB3326.namprd02.prod.outlook.com>
 <alpine.LNX.2.21.99.1803301931300.5692@mStation.localdomain>
 <CAOt++SeLh_NxcmM=YEMQSv4y9PabS_dT7k4yTxUiqXbac-=iUQ@mail.gmail.com>
 <20180417194255.GA17067@redhat.com>
 <CAOt++SeNt=4RUTvAR1y_WjC=a-YyYa3YBSmoAmv+7uK71U+3+A@mail.gmail.com>
 <20180528125039.GA22122@redhat.com>
 <20180815114029.GA1862@redhat.com>
 <20180815223526.GC1243@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180815223526.GC1243@makrotopia.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello

On Thu, Aug 16, 2018 at 12:35:29AM +0200, Daniel Golle wrote:
> Clone the master branch of
> https://git.openwrt.org/openwrt/staging/dangole.git
> and give it shot and let us know the results.

Thanks!

> > Please also remove:
> > 600-23-rt2x00-rt2800mmio-add-a-workaround-for-spurious-TX_F.patch
> > 991-rt2800_change_rx_ampdu_factor.patch
> > 992-rt2800_change_ba_size.patch
> > 993-rt2800_change_rx_ampdu_density.patch
> > Those are not needed and can be harmful with the test patches,
> > (especially spurious interrupt one, patches will not apply cleanly 
> > with it).
> 
> Ack. Hope it doesn't break Rt3883 and/or Rt3663 for which that patch
> was added by Gabor Juhos a decade ago...

The new patches change the way we handle TX status interrupt. I think
spurious interrupts were a problem because we do not disable the IRQ 
and read statuses, so we could get interrupt after we empty TX_STA_FIFO
register. With current implementation this should not be an issue. 

> > Another thing is fixing RATE_PROBE frames which are aggregated with
> > other frames and not sent at requested rate. I implemented qsel queue patch
> > similar to mt76, but this not work as expected on older Ralink chips.  
> > https://github.com/sgruszka/wireless-drivers-next/commit/846d205edd8c36d1b7828fee54bf4cf40bf8cb1a
> 
> Which hardware did you try? Just so I can reproduce what's going on
> and maybe help fixing it...

I tested on RT3062 PCI and some USB dongles, don't remember chip version.
Basically HW become unresponsive after sent some traffic.

I debugged the problem by printing sequence number and rate of RATE PROBE
frames by something like this:

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
index 92ddc19..d7f250b 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
@@ -334,6 +334,12 @@ static void rt2x00queue_create_tx_descriptor_ht(struct rt2x00_dev *rt2x00dev,
 			txdesc->u.ht.mcs |= 0x08;
 	}
 
+	if (tx_info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE) {
+		int ssn = le16_to_cpu(hdr->seq_ctrl) >> 4;
+		printk("RATE PROBE %d %d\n", ssn, txdesc->u.ht.mcs);
+	}
+
+
 	if (test_bit(CONFIG_HT_DISABLED, &rt2x00dev->flags)) {
 		if (!(tx_info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT))
 			txdesc->u.ht.txop = TXOP_SIFS;

and compared that with on air traffic captured in monitor mode on
different device in wireshark. On air traffic showed different 
probe frames rate than requested.

Regards
Stanislaw
