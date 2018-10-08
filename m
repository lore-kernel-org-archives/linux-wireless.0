Return-Path: <SRS0=RoeA=MU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08A12C00449
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 09:34:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CC4BE204FD
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Oct 2018 09:34:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC4BE204FD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbeJHQp0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Oct 2018 12:45:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60890 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726354AbeJHQp0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Oct 2018 12:45:26 -0400
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.25])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 383EA3082A27;
        Mon,  8 Oct 2018 09:34:38 +0000 (UTC)
Received: from localhost (ovpn-204-38.brq.redhat.com [10.40.204.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C005E2016BF3;
        Mon,  8 Oct 2018 09:34:37 +0000 (UTC)
Date:   Mon, 8 Oct 2018 11:34:36 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v2 03/12] rtw88: hci files
Message-ID: <20181008093435.GE1961@redhat.com>
References: <1538553748-26364-1-git-send-email-yhchuang@realtek.com>
 <1538553748-26364-4-git-send-email-yhchuang@realtek.com>
 <20181004130212.GC16819@redhat.com>
 <F7CD281DE3E379468C6D07993EA72F84D172A54A@RTITMBSVM01.realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D172A54A@RTITMBSVM01.realtek.com.tw>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.25
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Mon, 08 Oct 2018 09:34:38 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Oct 05, 2018 at 12:07:06PM +0000, Tony Chuang wrote:
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
> > > +
> > > +	if (i >= 20)
> > > +		rtw_warn(rtwdev, "pci bus timeout, drop packet\n");
> > This is not right, most likely you need to use
> > dma_sync_single_for_cpu() .
> 
> Not really understand how dma_sync_single_for_cpu() works.
> Can you show me if possible?

dma_sync_single_for_cpu() and dma_sync_single_for_device() 
transfer dma buffer ownership to respectivly CPU and device.
It is well documented in:
Documentation/DMA-API-HOWTO.txt:  
Documentation/DMA-API.txt

Thanks
Stanislaw
