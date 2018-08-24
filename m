Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:49568 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726752AbeHXQhK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 12:37:10 -0400
Date: Fri, 24 Aug 2018 15:02:28 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Craig Matsuura <cmatsuura@vivint.com>,
        Kofi Agor <nenekofi@gmail.com>,
        Enrico Mioso <mrkiko.rs@gmail.com>,
        Mathias Kresin <dev@kresin.me>,
        Tom Psyborg <pozega.tomislav@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        Jamie Stuart <jamie@onebillion.org>
Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
 frame due to full tx queue...?
Message-ID: <20180824130227.GA31789@redhat.com> (sfid-20180824_150241_394365_04429FB5)
References: <CAOt++SeLh_NxcmM=YEMQSv4y9PabS_dT7k4yTxUiqXbac-=iUQ@mail.gmail.com>
 <20180417194255.GA17067@redhat.com>
 <CAOt++SeNt=4RUTvAR1y_WjC=a-YyYa3YBSmoAmv+7uK71U+3+A@mail.gmail.com>
 <20180528125039.GA22122@redhat.com>
 <20180815114029.GA1862@redhat.com>
 <20180815223526.GC1243@makrotopia.org>
 <20180816110103.GB2797@redhat.com>
 <DM5PR02MB365669D5E9F2DE20DAE4CB7AD43E0@DM5PR02MB3656.namprd02.prod.outlook.com>
 <20180818160836.GB1468@makrotopia.org>
 <20180820122041.GA8109@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180820122041.GA8109@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello

On Mon, Aug 20, 2018 at 02:20:41PM +0200, Stanislaw Gruszka wrote:
> On Sat, Aug 18, 2018 at 06:08:40PM +0200, Daniel Golle wrote:
> > Still seeing a lot of those
> > 
> > Sat Aug 18 16:05:51 2018 kern.err kernel: [ 8364.972151] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
> > Sat Aug 18 16:05:51 2018 kern.err kernel: [ 8364.981622] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
> > Sat Aug 18 16:05:51 2018 kern.err kernel: [ 8364.991070] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
> > Sat Aug 18 16:05:51 2018 kern.err kernel: [ 8365.000506] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
> > Sat Aug 18 16:05:51 2018 kern.err kernel: [ 8365.009935] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
> > 
> > while wifi somehow keeps working at degraded level once the error
> > occured.
> 
> I would like to know why we get those errors at all. Perhaps there is
> something wrong with queue pause/unpasue logic. Or with locking.
> Or maybe this is normal, we pausue queue in mac80211 but it still have
> some pending skbs which are scheduled to the driver.
> 
> Let's check if pausing is correct. Please apply this patch:
> https://github.com/sgruszka/wireless-drivers-next/commit/525c50486e17446793b21ac7a8498cb48b3bb210.patch
> and provide dmesg output.
> 
> Note that adding printk messages can make itself somehow AP
> unresponsive, as I pointed earlier in this thread. However
> at this point I would like to check if queue pause works as it
> should in the driver. 

I get testing results from T-Bone user in bugzilla:
https://bugzilla.kernel.org/show_bug.cgi?id=82751

And get this:

[  781.644185] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[  781.662620] 2 d1 s1 p1 ms1

Looks like rt2x00 correctly stop queue in mac80211, but sill get skb's. 

So we can do 3 things: increase queue size to 128, increase threshold
to 16 and make the massage debug one instead of error (I checked
some other drivers and looks most of them silently drop the frame
in case queue is full). Especially removing the message can be
useful since printk can somehow make mt7620 router unresponsive
for some time resulting in connection drops.

Thoughts ?

Regards
Stanislaw
