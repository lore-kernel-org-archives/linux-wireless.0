Return-Path: <SRS0=1+XV=R4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8CCEC43381
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 14:33:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 973FF20850
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 14:33:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="hrqLszcD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726177AbfCYOd4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Mar 2019 10:33:56 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41951 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfCYOd4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Mar 2019 10:33:56 -0400
Received: by mail-pf1-f195.google.com with SMTP id 188so1095377pfd.8
        for <linux-wireless@vger.kernel.org>; Mon, 25 Mar 2019 07:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mGGfmSUKgNNyGuiXLVx5jOgrRvs6jPkR8399Y1K2scs=;
        b=hrqLszcDJJB5bXOrnBkheaF9OtxwKmfPzmdWLug7qiWI3zQA0cZq+y4QT8MNvNX3Xd
         ChoIJjlxMDhpppCICUkDOjcfU6ahzxHY1jtaYdROvYQwpqDFbDhxWAw0c1jzisdmHeII
         GoF3qMdx2DsOfEbzA4RdH0rU0pgWe+4urSRVg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mGGfmSUKgNNyGuiXLVx5jOgrRvs6jPkR8399Y1K2scs=;
        b=cnjjAoltRNWyATSYArELVTBw2a2rqA2SYjVy5QLIm9r1Ku0mnFXeg7P13OnNpVzgbl
         toc4+OXCBtfM8ky4wFx4XsihdZA+EEL0977TrVlVTaF78VVMFv+MIkgrT2fiV8enULyr
         X5ewnmSizLPv32Pfv3RW4aS0KhJ9odRcugGV4aZr6hZ1bF5C6P37uKRBV/phL5D6pSRw
         ILHRZAaelkxaPjBq0IWG443ak0VXDqqAej/fjPkIFJTS4Y4mGdB3I1PRuPYhPwxopjfS
         J9xkWRipZu5QBNprhkF76euL/DlUuPwRcZCPOcJm7e79IYYsK2nT+z1srfKgEb8pletZ
         1KXw==
X-Gm-Message-State: APjAAAUsCwm8itCOJh2D6p6ofW7IsTpOhKryMbbxWTJNEv6mdVRlp+jQ
        YJQHoGtF9BG5NwvnC9zJgiJzzw==
X-Google-Smtp-Source: APXvYqwyqfbQ9zdqT4f/gX5O+lPf0tVthOIQ7v0Qx1dlotFj121SWDcYMm965jNPcIc4ukVDw6nSVQ==
X-Received: by 2002:a62:1b8a:: with SMTP id b132mr1936187pfb.19.1553524435980;
        Mon, 25 Mar 2019 07:33:55 -0700 (PDT)
Received: from penguin (189.8.197.35.bc.googleusercontent.com. [35.197.8.189])
        by smtp.gmail.com with ESMTPSA id c16sm22147212pfb.102.2019.03.25.07.33.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 Mar 2019 07:33:54 -0700 (PDT)
Date:   Mon, 25 Mar 2019 14:33:48 +0000
From:   Brian Norris <briannorris@chromium.org>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Tony Chuang <yhchuang@realtek.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Grant Grundler <grundler@chromium.org>
Subject: Re: [RFC v2 03/12] rtw88: hci files
Message-ID: <20190325143258.wqpy4vt2o3jmb4lq@penguin>
References: <1538553748-26364-1-git-send-email-yhchuang@realtek.com>
 <1538553748-26364-4-git-send-email-yhchuang@realtek.com>
 <20181004130212.GC16819@redhat.com>
 <F7CD281DE3E379468C6D07993EA72F84D172A54A@RTITMBSVM01.realtek.com.tw>
 <20181008093435.GE1961@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181008093435.GE1961@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+ Grant

I'm sorry (a little) to drudge up old revisions. But I happened to be
looking back at prior reviews, since I'm reviewing the latest, and I
realized I had this same (then-unresolved) confusion on later versions.
Maybe I should have read more before reviewing... Oh well. Comments
below:

On Mon, Oct 08, 2018 at 11:34:36AM +0200, Stanislaw Gruszka wrote:
> On Fri, Oct 05, 2018 at 12:07:06PM +0000, Tony Chuang wrote:
> > > > +static void rtw_pci_dma_check(struct rtw_dev *rtwdev,
> > > > +			      struct rtw_pci_rx_ring *rx_ring,
> > > > +			      u32 idx)
> > > > +{
> > > > +	struct rtw_chip_info *chip = rtwdev->chip;
> > > > +	struct rtw_pci_rx_buffer_desc *buf_desc;
> > > > +	u32 desc_sz = chip->rx_buf_desc_sz;
> > > > +	u16 total_pkt_size;
> > > > +	int i;
> > > > +
> > > > +	buf_desc = (struct rtw_pci_rx_buffer_desc *)(rx_ring->r.head +
> > > > +						     idx * desc_sz);
> > > > +	for (i = 0; i < 20; i++) {
> > > > +		total_pkt_size = le16_to_cpu(buf_desc->total_pkt_size);
> > > > +		if (total_pkt_size)
> > > > +			return;
> > > > +	}
> > > > +
> > > > +	if (i >= 20)
> > > > +		rtw_warn(rtwdev, "pci bus timeout, drop packet\n");
> > > This is not right, most likely you need to use

Indeed, this was not right. Tony ended up removing it entirely later on,
based on my independent (sorry, didn't read this!) suggestion.

> > > dma_sync_single_for_cpu() .
> > 
> > Not really understand how dma_sync_single_for_cpu() works.
> > Can you show me if possible?
> 
> dma_sync_single_for_cpu() and dma_sync_single_for_device() 
> transfer dma buffer ownership to respectivly CPU and device.
> It is well documented in:
> Documentation/DMA-API-HOWTO.txt:  
> Documentation/DMA-API.txt

Yes, if we expect to need a sort of polling loop like this here, then it
would be important to flush any caches (and, as Grant noted later, it
would probably help to ensure some kind of consistent time deadline --
udelay(), or maybe just check against ktime_get()).

I'll also note here as I did on the later series: these rings are
allocated with consistent memory, so as long as the device is only
signalling this interrupt after it has completed writing to memory, then
we should be reading the latest copy and there should be no need for a
polling loop.

And Tony apparently agreed with me; the loop is gone in the latest, and
instead, we simply read once before emitting a warning.

Regards,
Brian
