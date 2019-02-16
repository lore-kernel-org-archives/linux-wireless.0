Return-Path: <SRS0=K8Xh=QX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE72EC43381
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Feb 2019 11:05:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A82B222D9
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Feb 2019 11:05:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbfBPLFc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Feb 2019 06:05:32 -0500
Received: from mout.kundenserver.de ([217.72.192.75]:45469 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbfBPLFc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Feb 2019 06:05:32 -0500
Received: from oxbaltgw00.schlund.de ([172.19.246.6]) by
 mrelayeu.kundenserver.de (mreue106 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MCb2L-1glIrj1U71-009dRy; Sat, 16 Feb 2019 12:05:20 +0100
Date:   Sat, 16 Feb 2019 12:05:18 +0100 (CET)
From:   Stefan Wahren <stefan.wahren@i2se.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Felix Fietkau <nbd@nbd.name>,
        Doug Anderson <dianders@chromium.org>,
        Minas Harutyunyan <hminas@synopsys.com>,
        USB list <linux-usb@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <1411983628.668277.1550315118443@email.ionos.de>
In-Reply-To: <20190215071226.GA2372@redhat.com>
References: <20190211173315.GE6292@redhat.com>
 <Pine.LNX.4.44L0.1902111246410.1543-100000@iolanthe.rowland.org>
 <CAJ0CqmVFVBXi5E07-ZsYojC7mP4ogpwbcDkDTeebHwX+ayz2DQ@mail.gmail.com>
 <20190212093035.GB12906@redhat.com>
 <404607590.373282.1550126997144@email.ionos.de>
 <20190214092530.GA17273@redhat.com>
 <878a7160-2e91-d057-6d27-c6b9d85f700e@i2se.com>
 <20190215071226.GA2372@redhat.com>
Subject: Re: [BUG] mt76x0u: Probing issues on Raspberry Pi 3 B+
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.8.4-Rev47
X-Originating-Client: open-xchange-appsuite
X-Provags-ID: V03:K1:1I4zC0RkVpP3ohoZhL8Pe27VwdNydmMOZfDNw4N7OI2Uf27A7IV
 S1z9MPmVYcpfhtLTrv4/mhfoqy396pGMJcpNOLOsypa3lNrgW7QrAApkPj2ZZKqvJZu1qKI
 I0ms7P0grNwCRqDmRqgINtsrvWCb0UNjidvLZLyl6AzEg8Sxo8kRjMhyirIUErOvd0Hx4BX
 o9Q2rVZTWxqcdhf7gWoWg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:3M7bpmRm1Qs=:uKvlBmjwlCJCmZazxh0se7
 YbrsFkrZalMH0vHYvPfB85EoPDxXxpNFg/WR4s1SQbRJ09Pt81J3OGHvcHV/Hps+F2ZS8JYYB
 Kugm8QFXPknOlGajpMK7I6Vavd93CLsW5IjekwBQ98pJ8I+/USyqDI80VjU0cVzmkGTYtG9kK
 xa9w/NrupHbjRTujhza4W4dQ62Cc71Bhrw/b7wpZdIk079tzKX0/dTXUDTwTusotVDto07pvi
 TE3zprKSSvFtut8K3VJI04FAwJlNKNA7ER6R1eWWFsMlX5BdbtOATGcyEQqPp2yBS1nVmNbVb
 D1Y8LM0POZloVyMVWmx/A2FdXY1UWdQ8PRGtYYRXlPCiHEbxRRiYqadt8QycNRcb62wZ1/m65
 YsdbcyF9ULUJN2ySxsdxLRBBxTWTXUQl1tm/yWIcDU2S78j+UgGjD52nyEqoA4QI4xOPpwNQS
 gKAJQ+3hbky6/ESznNLRUj5qRv2hmsp8HAleJNH8ni0ExcLBEruyYzTeKGqO6vrxneyyA3qDs
 xMa4TIlyA2L0zcpJiFt6MENmv6icUoSN0s0v14NkgMFLxdIBE/59fAEgfYKG8GwR66vhgSxok
 dxo5ptGGVxx9PpHAjc1yhy6h4asdFSDKg0Nu4eA3VKBmWiUckrD1tKXr5EA6nobM0iKlULD/O
 CZOBD4Dy6XJHN4M7J2KRN19NpSJL5TR007JFUMKkGHMULZfM1lqWvZbJ/1E3PylsywVKEKD90
 hl8HkWtqR3TosmNEdtmkDdb/N2ubAfIU1DQLfSQH6vzc+I0g5thZwgj55Fc=
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Stanislaw,

> Stanislaw Gruszka <sgruszka@redhat.com> hat am 15. Februar 2019 um 08:12 geschrieben:
> 
> 
> On Thu, Feb 14, 2019 at 10:48:15AM +0100, Stefan Wahren wrote:
> > Hi Stanislaw,
> > 
> > Am 14.02.19 um 10:25 schrieb Stanislaw Gruszka:
> > > On Thu, Feb 14, 2019 at 07:49:57AM +0100, Stefan Wahren wrote:
> > >> Hi Stanislaw,
> > >>
> > >>> Stanislaw Gruszka <sgruszka@redhat.com> hat am 12. Februar 2019 um 10:30 geschrieben:
> > >>>
> > >>>
> > >>>
> > >>> In usb_sg_init() urb->num_sgs is set 0 for sg_tablesize = 0 controllers.
> > >>> In mt76 we set urb->num_sgs to 1. I thought it is fine, but now I think
> > >>> this is bug. We can fix that without changing allocation method and
> > >>> still use SG allocation. Attached patch do this, please check if it works
> > >>> on rpi. Patch is on top of your error path fixes.
> > >> your patch didn't apply cleanly to yesterdays next. After some minor manual fixup, i was able to build them and here are the results starting from boot (please ignore the invalid time in the kernel log):
> > >> https://gist.github.com/lategoodbye/33bd5bc75b9fc935faa231bc472defa8
> > > I think this is due to urb->transfer_length and sg[0]->length mismatch,
> > > which should be addressed by my other patch. I'm attaching the patch
> > > rebased on -next with this line integrated, please test. 
> > >
> > > But there could be other bug's in mt76-usb SG code.
> 
> I found another bug in mt76usb SG code. We set sg->offset bigger than
> PAGE_SIZE that actually make sg point to memory in different page than
> sg->page. Correcting this with another patch that avoid using sg
> mapping with sg->length > PAGE_SIZE, fixed mt76x0u with AMD IOMMU:
> https://bugzilla.kernel.org/show_bug.cgi?id=202241
> 
> I'm attaching 3 patches, they should also fix issue on rpi.
> It's also possible that only 2 patches are sufficient:
> 
> 0001-mt76usb-do-not-set-urb-num_sgs-to-1-for-non-SG-usb-h.patch
> 0003-mt76usb-do-not-use-compound-head-page-for-SG-I-O.patch
> 
> to fix the issue, if doing dma_map_{page,sg} is fine with
> sg->offset == 0 and sg->length bigger than one page.
> 
> Please test, thanks.
> 

sorry for the delay, but i do this all in my spare time.

The results for your recent patch series are better (no firmware timeout), but still no working wifi and still a warning:
https://gist.github.com/lategoodbye/c4864e446821717419cbe65df07f8d8d

I've identified the reason for the warning in dwc2:

/*
 * We assume that DMA is always aligned in non-split
 * case or split out case. Warn if not.
 */
WARN_ON_ONCE(hsotg->params.host_dma && (chan->xfer_dma & 0x3));

Btw i can confirm a regression was introduced after 4.19, because in 4.19 there was no firmware timeout but even no working wifi:

Feb 15 19:10:51 raspberrypi kernel: [   79.818414] usb 1-1.3: new high-speed USB device number 6 using dwc2
Feb 15 19:10:51 raspberrypi kernel: [   80.178470] usb 1-1.3: reset high-speed USB device number 6 using dwc2
Feb 15 19:10:51 raspberrypi kernel: [   80.314388] mt76x0 1-1.3:1.0: ASIC revision: 76100002 MAC revision: 76502000
Feb 15 19:10:52 raspberrypi kernel: [   81.118751] BBP version f000f200
Feb 15 19:10:52 raspberrypi kernel: [   81.152995] mt76x0 1-1.3:1.0: EEPROM ver:02 fae:01
Feb 15 19:10:52 raspberrypi kernel: [   81.153232] mt76x0 1-1.3:1.0: EEPROM country region 01 (channels 1-13)
Feb 15 19:10:52 raspberrypi kernel: [   81.176968] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
Feb 15 19:10:52 raspberrypi kernel: [   81.178255] usbcore: registered new interface driver mt76x0
Feb 15 19:10:53 raspberrypi kernel: [   81.578982] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready

Stefan

> Stanislaw
