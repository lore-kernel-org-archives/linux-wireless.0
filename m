Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9CA7C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 12:45:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 772BF20644
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 12:45:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 772BF20644
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbeJJUHR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 16:07:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47426 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726636AbeJJUHQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 16:07:16 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E362E3084256;
        Wed, 10 Oct 2018 12:45:15 +0000 (UTC)
Received: from localhost (unknown [10.43.2.54])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3DDFA6B8D5;
        Wed, 10 Oct 2018 12:45:15 +0000 (UTC)
Date:   Wed, 10 Oct 2018 14:45:09 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     Tom Psyborg <pozega.tomislav@gmail.com>,
        linux-wireless@vger.kernel.org, Mathias Kresin <dev@kresin.me>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH v3 4/4] rt2800: fix registers init for MT7620
Message-ID: <20181010124508.GA22330@redhat.com>
References: <1539086170-32528-1-git-send-email-sgruszka@redhat.com>
 <1539086170-32528-4-git-send-email-sgruszka@redhat.com>
 <CAKR_QV+0z-5ee=sbEawFSnEF2ngvJSUPpNUoY_oPK1Cfk9P0iA@mail.gmail.com>
 <20181010071451.GA9140@redhat.com>
 <20181010120657.GA1185@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181010120657.GA1185@makrotopia.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Wed, 10 Oct 2018 12:45:16 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello

On Wed, Oct 10, 2018 at 02:06:58PM +0200, Daniel Golle wrote:
> > > https://github.com/psyborg55/linux/commit/24b46d482590a87553df1de0b5c8032f363cb7cf
> > >  ?
> > > 
> > >  using this code to determine 7620 soc
> > > 
> > >  if (rt == RT5390 && rt2x00_is_soc(rt2x00dev))
> > >          rt = RT6352;
> > > 
> > >  somehow did not work in rt2800_init_registers routine. i could verify
> > >  that by removing tx_sw_cfg registers from rt6352 and the wifi would
> > >  still work, unless removed them from rt5390 also
> > 
> > I tested by adding additional printk("Init RT6352 registers\n"); in 
> > if (rt2x00_rt(rt2x00dev, RT6352)) branch. The message was printed:
> > 
> > [   68.049946] ieee80211 phy0: rt2x00_set_rt: Info - RT chipset 6352, rev 0500 detected
> > [   68.065392] ieee80211 phy0: rt2x00_set_rf: Info - RF chipset 7620 detected
> > [   68.079777] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
> > [   68.177760] kmodloader: done loading kernel modules from /etc/modules.d/*
> > [   68.825758] urandom_read: 5 callbacks suppressed
> > [   68.825768] random: jshn: uninitialized urandom read (4 bytes read)
> > [   77.792400] 8021q: adding VLAN 0 to HW filter on device eth0
> > [   77.825045] br-lan: port 1(eth0.1) entered blocking state
> > [   77.836032] br-lan: port 1(eth0.1) entered disabled state
> > [   77.847156] device eth0.1 entered promiscuous mode
> > [   77.856739] device eth0 entered promiscuous mode
> > [   77.931043] br-lan: port 1(eth0.1) entered blocking state
> > [   77.941861] br-lan: port 1(eth0.1) entered forwarding state
> > [   77.953171] IPv6: ADDRCONF(NETDEV_UP): br-lan: link is not ready
> > [   78.849852] IPv6: ADDRCONF(NETDEV_CHANGE): br-lan: link becomes ready
> > [   82.302306] Init RT6352 registers
> > 
> > Perhaps rt2x00_is_soc(rt2x00dev) does not work on this particular system
> > that you have and device is configured as RT5390 ? I.e. maybe this is
> > PCIe device. This should be printed in :
> > 
> > ieee80211 phy0: rt2x00_set_rt: Info - RT chipset 6352, rev 0500 detected
> > 
> > line, you should have 'RT chipset 5390' instead.
> 
> RT6352 is the pre-mediatek-merge name of MT7620A/N. It is always a SoC.
> The RF part of both MT7620A and MT7620N identifies as RT5390. The
> vendor driver also uses an equivalent check to destinguish between the
> actual PCIe/USB RT5390xx and RT6352, see
> 
> https://github.com/i80s/mtk-sources/blob/master/mt7620/src/include/rtmp_chip.h#L114

Yes , but this does not explain why things do not work as
expected for Tomislav, which IIUC use RT5390 configuration.

Perhaps the check:

	if (rt == RT5390 && rt2x00_is_soc(rt2x00dev))
		rt = RT6352;

should be some how modified to work on Tomislav's hardware ?

Thanks
Stanislaw
