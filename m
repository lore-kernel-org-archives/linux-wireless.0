Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2127BC6786C
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 12:51:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E282320865
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 12:51:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E282320865
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728307AbeJLUXj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 16:23:39 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:46156 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727816AbeJLUXj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 16:23:39 -0400
Received: by mail-io1-f67.google.com with SMTP id t7-v6so9111263ioj.13
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2018 05:51:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V+cSE0k0b6H2jzuhpCGslRT5HsC4fZ4q1ZY5xQMnI/Y=;
        b=YtIHKR0JCoGKa6ffFQ1MsoKd+M2MyjcZp6J3Kt6bmu0xgeHOyaxmIMMgHZWcncUVXy
         oaUae10MU+rnOe66i/PN3tNdBDLFz+pqI1aR7C3H/b+SpBlqFyd8D9uA85FU6N3RZmat
         NTx81vxj9rGkuVn/ImN/nO3IUgaS/aCwVWxDYRBYYqcV/mN6wX6tRetVnLVSqTzxCbn9
         pu86zUcrcy/L80WNvRqAnrHzX4QodEDyxcNTa/5toxtFmVRhoRCWAftkSEQSauT2Bc2X
         aT2Miy7WJtRYcViRFKKvYpRvjTAg4jDl+EVLGQqM6QONjvys9wkaYeLSKbYAnVCeY1MR
         uddA==
X-Gm-Message-State: ABuFfoi297jEJI4Resqyp9rKSRMxtvdliM/OyG6nChYj5WJLEk8/MKld
        Vvkm1ACkViyaW1ytGvavowJmjpfxTlMJFZTdcyM0SEWe
X-Google-Smtp-Source: ACcGV61AoG+XTpjQoIVGg9+lXBtSxQtV1+liRQAf+CM9Ey/SpCEXSiDVX+aB2KW8EyvBpDd0eMH3XWHBcd2KVASQNjQ=
X-Received: by 2002:a6b:c917:: with SMTP id z23-v6mr3930289iof.297.1539348679379;
 Fri, 12 Oct 2018 05:51:19 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1539338611.git.lorenzo.bianconi@redhat.com>
 <326458a15d0c242e7419e3bfc0033ccdc9083676.1539338611.git.lorenzo.bianconi@redhat.com>
 <20181012123259.GC2668@redhat.com>
In-Reply-To: <20181012123259.GC2668@redhat.com>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Fri, 12 Oct 2018 14:51:08 +0200
Message-ID: <CAJ0CqmVZLg0dF7ei3agFKvvkP8CKM16mqbTxvLbTheiMDpNcGg@mail.gmail.com>
Subject: Re: [PATCH 04/13] mt76x0: pci: introduce mt76x0_phy_calirate routine
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>
> On Fri, Oct 12, 2018 at 12:16:20PM +0200, Lorenzo Bianconi wrote:
> > Add mt76x0_phy_calirate routine in order to perform
> > phy calibration for mt76x0e devices.
> <snip>
> > @@ -671,9 +713,14 @@ int mt76x0_phy_set_channel(struct mt76x02_dev *dev,
> >       /* Vendor driver don't do it */
> >       /* mt76x0_phy_set_tx_power(dev, channel, rf_bw_band); */
> >
> > -     mt76x0_vco_cal(dev, channel);
> > -     if (scan)
> > -             mt76x02_mcu_calibrate(dev, MCU_CAL_RXDCOC, 1, false);
> > +     if (mt76_is_usb(dev)) {
> > +             mt76x0_vco_cal(dev, channel);
> > +             if (scan)
> > +                     mt76x02_mcu_calibrate(dev, MCU_CAL_RXDCOC, 1,
> > +                                           false);
> > +     } else {
> > +             mt76x0_phy_calibrate(dev, false);
> > +     }
>
> Why this should be diffrent for USB and PCI ? RF calibration seems
> not to be realted to bus type, so perhaps this should be based on
> mt76xx_rev() check?
>

actually mt76x0e is running a newer firmware version than mt76x0u one and
phy calibration is based on it (vco/full calibration cmds).
My plan is to update usb driver to use the same pcie fw (from some
preliminary tests
mt76x0u driver seems to work properly with pcie fw) but we are pretty
close to merging window
now for that kind of changes.
Moreover I guess we can do the same with mt76x2/mt76x2u

Regards,
Lorenzo

> Thanks
> Stanislaw

Regards,
Lorenzo
