Return-Path: <SRS0=LoJ4=QT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8919EC282C4
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 22:04:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47F5B20842
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Feb 2019 22:04:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Hb5qVZVP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732009AbfBLWET (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Feb 2019 17:04:19 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:43808 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbfBLWET (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Feb 2019 17:04:19 -0500
Received: by mail-ed1-f65.google.com with SMTP id f9so190221eds.10
        for <linux-wireless@vger.kernel.org>; Tue, 12 Feb 2019 14:04:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pkMTu2cnGg47Dq/vpnq9W4pTmWvUYEKL4hOvDkRKsB0=;
        b=Hb5qVZVPAJmTv+6Zt+6ZNRt12uDu0aXeQCF1C9hpv82T9754Gh10eRuHU2ZkUVqYud
         GPA5oPsmltCR0py5dEjYYfkKNvQi/Ji6VHetAHJP/isRBsI4hNdabt7UFwz2EqqJ7Uso
         hlWe50KnrAmaP0whoe2wsMahWg70yh/XsufB8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pkMTu2cnGg47Dq/vpnq9W4pTmWvUYEKL4hOvDkRKsB0=;
        b=KVMQOwqBJY/VM1LqtRp6Dsq5vRpb3UvIoRHNiNOUT0OFmAG1aiYSAXVSx0/4Y84ngL
         27N90Egy4BvF1eEK23B6khEv12eDZPlMNL9OjGBOMUyyRwNRhn5g1VFtWMcvsuzNsMkd
         fGyDV54b6Wl++v7s11XDsmBfoiwvN41Gh7PORxtjbdtdAzamNjI1Pdq1Z6GbsJ1DJm8h
         OfUM/CJRDq8sCIc6idXwv8LSbCHBGajqIZHQYIBpLBdEyF5QOCuQPIU7EyiV+FM1SI+a
         2PQw4WvWax0uur72iBG4ntD/C9aRXWMsTLhB+z+306r4RXUlvUt2nGPPIbjsuHLeXg7K
         V6ug==
X-Gm-Message-State: AHQUAubhCOi66bi6L1oWXdMQrr4NFTAhSg+A8pYKlN3sakgFz5PPFVsG
        RYN7R9tt8fw4XjlhBWJJCBRLzoMexkY=
X-Google-Smtp-Source: AHgI3IYWw8T0gov9qM0X5fNf2MRQesszFwOFd44Omjt7bKtGks1HI3kSzCWIjHEQLTGv+fZSXfk+BA==
X-Received: by 2002:a50:a2e5:: with SMTP id 92mr4887796edm.169.1550009056523;
        Tue, 12 Feb 2019 14:04:16 -0800 (PST)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com. [209.85.208.53])
        by smtp.gmail.com with ESMTPSA id t12sm4095664edq.11.2019.02.12.14.04.15
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Feb 2019 14:04:16 -0800 (PST)
Received: by mail-ed1-f53.google.com with SMTP id m12so220698edv.4
        for <linux-wireless@vger.kernel.org>; Tue, 12 Feb 2019 14:04:15 -0800 (PST)
X-Received: by 2002:a17:906:1f98:: with SMTP id t24mr4160952ejr.247.1550009054319;
 Tue, 12 Feb 2019 14:04:14 -0800 (PST)
MIME-Version: 1.0
References: <1548820940-15237-1-git-send-email-yhchuang@realtek.com>
 <1548820940-15237-4-git-send-email-yhchuang@realtek.com> <20190131223609.GA191502@google.com>
 <F7CD281DE3E379468C6D07993EA72F84D17A3A5E@RTITMBSVM04.realtek.com.tw>
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D17A3A5E@RTITMBSVM04.realtek.com.tw>
From:   Brian Norris <briannorris@chromium.org>
Date:   Tue, 12 Feb 2019 14:04:02 -0800
X-Gmail-Original-Message-ID: <CA+ASDXMGtktTQtwoyCtaYmc9n5+OkXWMJn8FK-nGnoOLrbFe+w@mail.gmail.com>
Message-ID: <CA+ASDXMGtktTQtwoyCtaYmc9n5+OkXWMJn8FK-nGnoOLrbFe+w@mail.gmail.com>
Subject: Re: [PATCH v4 03/13] rtw88: hci files
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Feb 11, 2019 at 10:19 PM Tony Chuang <yhchuang@realtek.com> wrote:
> > From: Brian Norris [mailto:briannorris@chromium.org]
> > On Wed, Jan 30, 2019 at 12:02:10PM +0800, yhchuang@realtek.com wrote:
> > > diff --git a/drivers/net/wireless/realtek/rtw88/pci.c
> > b/drivers/net/wireless/realtek/rtw88/pci.c
> > > new file mode 100644
> > > index 0000000..ef3c9bb
> > > --- /dev/null
> > > +++ b/drivers/net/wireless/realtek/rtw88/pci.c
> > > @@ -0,0 +1,1210 @@
> >
> > ...
> >
> > > +static int rtw_pci_init_rx_ring(struct rtw_dev *rtwdev,
> > > +                           struct rtw_pci_rx_ring *rx_ring,
> > > +                           u8 desc_size, u32 len)
> > > +{
> > > +   struct pci_dev *pdev = to_pci_dev(rtwdev->dev);
> > > +   struct sk_buff *skb = NULL;
> > > +   dma_addr_t dma;
> > > +   u8 *head;
> > > +   int ring_sz = desc_size * len;
> > > +   int buf_sz = RTK_PCI_RX_BUF_SIZE;
> > > +   int i, allocated;
> > > +   int ret = 0;
> > > +
> > > +   head = pci_zalloc_consistent(pdev, ring_sz, &dma);
> > > +   if (!head) {
> > > +           rtw_err(rtwdev, "failed to allocate rx ring\n");
> > > +           return -ENOMEM;
> > > +   }
> > > +   rx_ring->r.head = head;
> > > +
> > > +   for (i = 0; i < len; i++) {
> > > +           skb = dev_alloc_skb(buf_sz);
> > > +           if (!skb) {
> > > +                   allocated = i;
> > > +                   ret = -ENOMEM;
> > > +                   goto err_out;
> > > +           }
> > > +
> > > +           memset(skb->data, 0, buf_sz);
> > > +           rx_ring->buf[i] = skb;
> > > +           ret = rtw_pci_reset_rx_desc(rtwdev, skb, rx_ring, i, desc_size);
> > > +           if (ret) {
> > > +                   allocated = i;
> > > +                   goto err_out;
> > > +           }
> > > +   }
> > > +
> > > +   rx_ring->r.dma = dma;
> > > +   rx_ring->r.len = len;
> > > +   rx_ring->r.desc_size = desc_size;
> > > +   rx_ring->r.wp = 0;
> > > +   rx_ring->r.rp = 0;
> > > +
> > > +   return 0;
> > > +
> > > +err_out:
> > > +   dev_kfree_skb_any(skb);
> >
> > Maybe I'm misreading but...shouldn't this line not be here? You properly
> > iterate over the allocated SKBs below, and this looks like you're just
> > going to be double-freeing (or, negative ref-counting).
>
> Yeah, I think I should move this line above after reset_rx_desc failed.

Ah yes, so it's not technically incorrect, it's just a bit strange to
read. Yes, moving it up to the failure location would make it clearer
IMO. Thanks.

> > > +   for (i = 0; i < allocated; i++) {
> > > +           skb = rx_ring->buf[i];
> > > +           if (!skb)
> > > +                   continue;
> > > +           dma = *((dma_addr_t *)skb->cb);
> > > +           pci_unmap_single(pdev, dma, buf_sz, PCI_DMA_FROMDEVICE);
> > > +           dev_kfree_skb_any(skb);
> > > +           rx_ring->buf[i] = NULL;
> > > +   }
> > > +   pci_free_consistent(pdev, ring_sz, head, dma);
> > > +
> > > +   rtw_err(rtwdev, "failed to init rx buffer\n");
> > > +
> > > +   return ret;
> > > +}
> > > +

...

> After some testing, this function I think can be removed.
> (rtw_pci_parse_configuration)

Why was it here in the first place? Were there any hardware quirks
that this was covering? Or, are you just saying that the default
values are already correct (plus, the PCI framework already brings you
out of D3)? I do also see that removing this function doesn't actually
have a net effect on the the PCI configuration, judging by lspci
-vvvxxxx.

Brian
