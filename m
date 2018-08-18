Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:43137 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbeHRTRV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 18 Aug 2018 15:17:21 -0400
Date: Sat, 18 Aug 2018 18:08:40 +0200
From: Daniel Golle <daniel@makrotopia.org>
To: Craig Matsuura <cmatsuura@vivint.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Kofi Agor <nenekofi@gmail.com>,
        Enrico Mioso <mrkiko.rs@gmail.com>,
        Mathias Kresin <dev@kresin.me>,
        Tom Psyborg <pozega.tomislav@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        Jamie Stuart <jamie@onebillion.org>
Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
 frame due to full tx queue...?
Message-ID: <20180818160836.GB1468@makrotopia.org> (sfid-20180818_180925_524363_77436E67)
References: <MWHPR02MB3326233159B021143D7278F5D4A10@MWHPR02MB3326.namprd02.prod.outlook.com>
 <alpine.LNX.2.21.99.1803301931300.5692@mStation.localdomain>
 <CAOt++SeLh_NxcmM=YEMQSv4y9PabS_dT7k4yTxUiqXbac-=iUQ@mail.gmail.com>
 <20180417194255.GA17067@redhat.com>
 <CAOt++SeNt=4RUTvAR1y_WjC=a-YyYa3YBSmoAmv+7uK71U+3+A@mail.gmail.com>
 <20180528125039.GA22122@redhat.com>
 <20180815114029.GA1862@redhat.com>
 <20180815223526.GC1243@makrotopia.org>
 <20180816110103.GB2797@redhat.com>
 <DM5PR02MB365669D5E9F2DE20DAE4CB7AD43E0@DM5PR02MB3656.namprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <DM5PR02MB365669D5E9F2DE20DAE4CB7AD43E0@DM5PR02MB3656.namprd02.prod.outlook.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Still seeing a lot of those

Sat Aug 18 16:05:51 2018 kern.err kernel: [ 8364.972151] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sat Aug 18 16:05:51 2018 kern.err kernel: [ 8364.981622] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sat Aug 18 16:05:51 2018 kern.err kernel: [ 8364.991070] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sat Aug 18 16:05:51 2018 kern.err kernel: [ 8365.000506] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
Sat Aug 18 16:05:51 2018 kern.err kernel: [ 8365.009935] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2

while wifi somehow keeps working at degraded level once the error
occured.

On Thu, Aug 16, 2018 at 07:30:40PM +0000, Craig Matsuura wrote:
> FWIW we would use iperf and push a lot of data to a STA and would cause lock ups and issues with the queues.
> 
> 
> Craig
> 
> 
> Craig Matsuura • Technical Director, Embedded Software Architecture
> 
> cmatsuura@vivint.com<mailto:cmatsuura@vivint.com> • P: 801.229.6005
> 
> 
> 
> simply smarter • vivint.com
> 
> 3401 N Ashton Blvd. Lehi, UT 84043
> 
> 
> 
> [1497369905956_vivint-logo-orange.png]
> 
> ________________________________
> From: linux-wireless-owner@vger.kernel.org <linux-wireless-owner@vger.kernel.org> on behalf of Stanislaw Gruszka <sgruszka@redhat.com>
> Sent: Thursday, August 16, 2018 5:01:04 AM
> To: Daniel Golle
> Cc: Kofi Agor; Enrico Mioso; Craig Matsuura; Mathias Kresin; Tom Psyborg; linux-wireless; John Crispin; Felix Fietkau; Jamie Stuart
> Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue...?
> 
> Hello
> 
> On Thu, Aug 16, 2018 at 12:35:29AM +0200, Daniel Golle wrote:
> > Clone the master branch of
> > https://na01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgit.openwrt.org%2Fopenwrt%2Fstaging%2Fdangole.git&amp;data=01%7C01%7Ccmatsuura%40vivint.com%7C259b5ae9949e445dd9fe08d603680486%7C54cc98ca024a470185483741e3b8d59d%7C0&amp;sdata=8mOOSNRnqvjDVnCNHH15c%2BfEzr69yPpCkbSdD6Q8ZuA%3D&amp;reserved=0
> > and give it shot and let us know the results.
> 
> Thanks!
> 
> > > Please also remove:
> > > 600-23-rt2x00-rt2800mmio-add-a-workaround-for-spurious-TX_F.patch
> > > 991-rt2800_change_rx_ampdu_factor.patch
> > > 992-rt2800_change_ba_size.patch
> > > 993-rt2800_change_rx_ampdu_density.patch
> > > Those are not needed and can be harmful with the test patches,
> > > (especially spurious interrupt one, patches will not apply cleanly
> > > with it).
> >
> > Ack. Hope it doesn't break Rt3883 and/or Rt3663 for which that patch
> > was added by Gabor Juhos a decade ago...
> 
> The new patches change the way we handle TX status interrupt. I think
> spurious interrupts were a problem because we do not disable the IRQ
> and read statuses, so we could get interrupt after we empty TX_STA_FIFO
> register. With current implementation this should not be an issue.
> 
> > > Another thing is fixing RATE_PROBE frames which are aggregated with
> > > other frames and not sent at requested rate. I implemented qsel queue patch
> > > similar to mt76, but this not work as expected on older Ralink chips.
> > > https://na01.safelinks.protection.outlook.com/?url=https%3A%2F%2Fgithub.com%2Fsgruszka%2Fwireless-drivers-next%2Fcommit%2F846d205edd8c36d1b7828fee54bf4cf40bf8cb1a&amp;data=01%7C01%7Ccmatsuura%40vivint.com%7C259b5ae9949e445dd9fe08d603680486%7C54cc98ca024a470185483741e3b8d59d%7C0&amp;sdata=mI%2BPAh7OalmB1hxzjF%2FL6GqxwHDPi7Hy5P9IWADu5gI%3D&amp;reserved=0
> >
> > Which hardware did you try? Just so I can reproduce what's going on
> > and maybe help fixing it...
> 
> I tested on RT3062 PCI and some USB dongles, don't remember chip version.
> Basically HW become unresponsive after sent some traffic.
> 
> I debugged the problem by printing sequence number and rate of RATE PROBE
> frames by something like this:
> 
> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
> index 92ddc19..d7f250b 100644
> --- a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
> +++ b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
> @@ -334,6 +334,12 @@ static void rt2x00queue_create_tx_descriptor_ht(struct rt2x00_dev *rt2x00dev,
>                          txdesc->u.ht.mcs |= 0x08;
>          }
> 
> +       if (tx_info->flags & IEEE80211_TX_CTL_RATE_CTRL_PROBE) {
> +               int ssn = le16_to_cpu(hdr->seq_ctrl) >> 4;
> +               printk("RATE PROBE %d %d\n", ssn, txdesc->u.ht.mcs);
> +       }
> +
> +
>          if (test_bit(CONFIG_HT_DISABLED, &rt2x00dev->flags)) {
>                  if (!(tx_info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT))
>                          txdesc->u.ht.txop = TXOP_SIFS;
> 
> and compared that with on air traffic captured in monitor mode on
> different device in wireshark. On air traffic showed different
> probe frames rate than requested.
> 
> Regards
> Stanislaw
