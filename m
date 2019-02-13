Return-Path: <SRS0=xkZe=QU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3154FC282C2
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 11:08:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0136E222B2
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Feb 2019 11:08:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389969AbfBMLIj convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Feb 2019 06:08:39 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:55008 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727894AbfBMLIi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Feb 2019 06:08:38 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x1DB8EuF019534, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtitcasv01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x1DB8EuF019534
        (version=TLSv1 cipher=AES256-SHA bits=256 verify=NOT);
        Wed, 13 Feb 2019 19:08:14 +0800
Received: from RTITEXH01.realtek.com.tw (172.21.6.62) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server (TLS) id
 14.3.408.0; Wed, 13 Feb 2019 19:08:14 +0800
Received: from RTITMBSVM04.realtek.com.tw ([fe80::e404:880:2ef1:1aa1]) by
 RTITEXH01.realtek.com.tw ([::1]) with mapi id 14.03.0435.000; Wed, 13 Feb
 2019 19:08:13 +0800
From:   Tony Chuang <yhchuang@realtek.com>
To:     Tony Chuang <yhchuang@realtek.com>,
        Brian Norris <briannorris@chromium.org>
CC:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH v4 03/13] rtw88: hci files
Thread-Topic: [PATCH v4 03/13] rtw88: hci files
Thread-Index: AQHUuFCwL7VQDfSYhE2MAb8drhRitKXJdAKAgBDPKrCAAzN8gA==
Date:   Wed, 13 Feb 2019 11:08:13 +0000
Message-ID: <F7CD281DE3E379468C6D07993EA72F84D17A5B7D@RTITMBSVM04.realtek.com.tw>
References: <1548820940-15237-1-git-send-email-yhchuang@realtek.com>
 <1548820940-15237-4-git-send-email-yhchuang@realtek.com>
 <20190131223609.GA191502@google.com>
 <F7CD281DE3E379468C6D07993EA72F84D17A3A5E@RTITMBSVM04.realtek.com.tw>
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D17A3A5E@RTITMBSVM04.realtek.com.tw>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.68.124]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi

> On Behalf Of Tony Chuang
> Subject: RE: [PATCH v4 03/13] rtw88: hci files
> 
> > From: Brian Norris [mailto:briannorris@chromium.org]
> >
> > Hi,
> >
> > A few scattered comments:
> >
> > > +static void rtw_pci_dma_check(struct rtw_dev *rtwdev,
> > > +			      struct rtw_pci_rx_ring *rx_ring,
> > > +			      u32 idx)
> > > +{
> > > +	struct rtw_chip_info *chip = rtwdev->chip;
> > > +	struct rtw_pci_rx_buffer_desc *buf_desc;
> > > +	u32 desc_sz = chip->rx_buf_desc_sz;
> > > +	u16 total_pkt_size;
> > > +	int i;
> > > +
> > > +	buf_desc = (struct rtw_pci_rx_buffer_desc *)(rx_ring->r.head +
> > > +						     idx * desc_sz);
> > > +	for (i = 0; i < 20; i++) {
> > > +		total_pkt_size = le16_to_cpu(buf_desc->total_pkt_size);
> > > +		if (total_pkt_size)
> > > +			return;
> > > +	}
> >
> >
> > Umm, what are you trying to do here? This is a non-sensical loop. I
> > *imagine* you're trying to do some kind of timeout loop here, but since
> > there's nothing telling the compiler that this is anything but normal
> > memory, this loop gets flattened by the compiler into a single check of
> > ->total_pkt_size (I checked; my compiler gets rid of the loop).
> >
> > So, at a minimum, you should just remove the loop. But I'm not sure if
> > this "check" function has any value at all...
> >
> > > +
> > > +	if (i >= 20)
> > > +		rtw_warn(rtwdev, "pci bus timeout, drop packet\n");
> >
> > ...BTW, I'm seeing this get triggered quite a bit.
> 
> It's quite strange though... triggered on my laptop as well.
> I am looking for the reason that cause it. I found that 8822BE does not
> trigger this. And it's like even if I added a volatile before it to hint the
> compiler not to optimize, it still happens. Now trying to figure out why
> the bus continues to timeout.
> 
> After this problem is resolved I'll either remove the loop or add proper
> hint for the compiler to check the value. But it seems to take many days
> to debug, so I think for this patch set I can just remain it here.
> 
> >
> > Do you have some kind of memory mapping/ordering issue or something? I
> > wouldn't think you should expect to just drop packets on the floor so
> > often like this.
> >
> 
> Looks like the cause is that the DMA might not have done when the interrupt
> arrived. Need to do more test to figure it out.
> 


I tested and checked again. I found that I didn't enable DMA sync for
the TRX path. After some work it can be resolved if I turn DMA sync on.
So I will include this in the PATCH v5.


> 
> 
> Yan-Hsuan
> 

Yan-Hsuan
