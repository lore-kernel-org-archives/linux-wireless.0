Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CB40C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 12:07:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D393C2077C
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 12:07:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D393C2077C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=makrotopia.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbeJJT3L (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 15:29:11 -0400
Received: from fudo.makrotopia.org ([185.142.180.71]:38233 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726503AbeJJT3L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 15:29:11 -0400
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
         (Exim 4.90_1)
        (envelope-from <daniel@makrotopia.org>)
        id 1gADGl-000727-GE; Wed, 10 Oct 2018 14:07:16 +0200
Date:   Wed, 10 Oct 2018 14:06:58 +0200
From:   Daniel Golle <daniel@makrotopia.org>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Tom Psyborg <pozega.tomislav@gmail.com>,
        linux-wireless@vger.kernel.org, Mathias Kresin <dev@kresin.me>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH v3 4/4] rt2800: fix registers init for MT7620
Message-ID: <20181010120657.GA1185@makrotopia.org>
References: <1539086170-32528-1-git-send-email-sgruszka@redhat.com>
 <1539086170-32528-4-git-send-email-sgruszka@redhat.com>
 <CAKR_QV+0z-5ee=sbEawFSnEF2ngvJSUPpNUoY_oPK1Cfk9P0iA@mail.gmail.com>
 <20181010071451.GA9140@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181010071451.GA9140@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Stanislaw,

On Wed, Oct 10, 2018 at 09:14:52AM +0200, Stanislaw Gruszka wrote:
> On Wed, Oct 10, 2018 at 01:27:31AM +0200, Tom Psyborg wrote:
> > On 09/10/2018, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> > > There is dupliceted 'if (rt2x00_rt(rt2x00dev, RT6352))' entry that couses
> > > we do not perform proper register initaliztion for RT6352 (MT7620 SOCs).
> > >
> > > Reported-by: Tomislav Požega <pozega.tomislav@gmail.com>
> > > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > > ---
> > >  drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 3 +--
> > >  1 file changed, 1 insertion(+), 2 deletions(-)
> > >
> > > diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > > b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > > index daf20d7424ac..170e7c87f7bc 100644
> > > --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > > +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > > @@ -5451,8 +5451,7 @@ static int rt2800_init_registers(struct rt2x00_dev
> > > *rt2x00dev)
> > >  					      0x00000000);
> > >  		}
> > >  	} else if (rt2x00_rt(rt2x00dev, RT5390) ||
> > > -		   rt2x00_rt(rt2x00dev, RT5392) ||
> > > -		   rt2x00_rt(rt2x00dev, RT6352)) {
> > > +		   rt2x00_rt(rt2x00dev, RT5392)) {
> > >  		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000404);
> > >  		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
> > >  		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
> > > --
> > > 2.7.5
> > >
> > >
> > 
> > 
> > have you got chance to test
> > https://github.com/psyborg55/linux/commit/24b46d482590a87553df1de0b5c8032f363cb7cf
> >  ?
> > 
> >  using this code to determine 7620 soc
> > 
> >  if (rt == RT5390 && rt2x00_is_soc(rt2x00dev))
> >          rt = RT6352;
> > 
> >  somehow did not work in rt2800_init_registers routine. i could verify
> >  that by removing tx_sw_cfg registers from rt6352 and the wifi would
> >  still work, unless removed them from rt5390 also
> 
> I tested by adding additional printk("Init RT6352 registers\n"); in 
> if (rt2x00_rt(rt2x00dev, RT6352)) branch. The message was printed:
> 
> [   68.049946] ieee80211 phy0: rt2x00_set_rt: Info - RT chipset 6352, rev 0500 detected
> [   68.065392] ieee80211 phy0: rt2x00_set_rf: Info - RF chipset 7620 detected
> [   68.079777] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
> [   68.177760] kmodloader: done loading kernel modules from /etc/modules.d/*
> [   68.825758] urandom_read: 5 callbacks suppressed
> [   68.825768] random: jshn: uninitialized urandom read (4 bytes read)
> [   77.792400] 8021q: adding VLAN 0 to HW filter on device eth0
> [   77.825045] br-lan: port 1(eth0.1) entered blocking state
> [   77.836032] br-lan: port 1(eth0.1) entered disabled state
> [   77.847156] device eth0.1 entered promiscuous mode
> [   77.856739] device eth0 entered promiscuous mode
> [   77.931043] br-lan: port 1(eth0.1) entered blocking state
> [   77.941861] br-lan: port 1(eth0.1) entered forwarding state
> [   77.953171] IPv6: ADDRCONF(NETDEV_UP): br-lan: link is not ready
> [   78.849852] IPv6: ADDRCONF(NETDEV_CHANGE): br-lan: link becomes ready
> [   82.302306] Init RT6352 registers
> 
> Perhaps rt2x00_is_soc(rt2x00dev) does not work on this particular system
> that you have and device is configured as RT5390 ? I.e. maybe this is
> PCIe device. This should be printed in :
> 
> ieee80211 phy0: rt2x00_set_rt: Info - RT chipset 6352, rev 0500 detected
> 
> line, you should have 'RT chipset 5390' instead.

RT6352 is the pre-mediatek-merge name of MT7620A/N. It is always a SoC.
The RF part of both MT7620A and MT7620N identifies as RT5390. The
vendor driver also uses an equivalent check to destinguish between the
actual PCIe/USB RT5390xx and RT6352, see

https://github.com/i80s/mtk-sources/blob/master/mt7620/src/include/rtmp_chip.h#L114


Cheers


Daniel

> 
> Thanks
> Stanislaw
