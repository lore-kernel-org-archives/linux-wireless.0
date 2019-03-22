Return-Path: <SRS0=qAgV=RZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E382DC43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 08:44:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA09B20811
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Mar 2019 08:44:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HUEs8eeN";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hqYJ3/T2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727666AbfCVIoL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Mar 2019 04:44:11 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48722 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbfCVIoL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Mar 2019 04:44:11 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 0845F60E73; Fri, 22 Mar 2019 08:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553244250;
        bh=mLSVzZ6ZW6/w/eZPSeeUkRQ9FSyFubHDjWa+lazwUhs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=HUEs8eeNkKF7tifaZMEDgpBEBHz/CJ2yZb3+Hmqot7RsRVnC4TlugaIOhc1Vx5uDj
         XUs06mEoi411yS1UtNcktxBCNhP/Hpv2rGQ9vblcgH2uMHIVRlqxfNIK3pXQYNbCLf
         hOvgcOmRVPyb32ScZRPntxHKg4NC5ak04UwBI3U4=
Received: from x230.qca.qualcomm.com (unknown [195.39.71.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C8FF660312;
        Fri, 22 Mar 2019 08:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1553244249;
        bh=mLSVzZ6ZW6/w/eZPSeeUkRQ9FSyFubHDjWa+lazwUhs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=hqYJ3/T22EH5RnzD6cUScyCLzFtRflO9efSSVKw49ljhigY0oorHEo+9aI5pEMiek
         A77aWqr85rWvLBnarvBZTIm4wDKiNnIn10dH8lk4z+a2KaHdFW0WXd6z3S9C0ROURs
         NIVGyZK/PSRFwR/+2UkegivGMBkLij9cO4R13dbU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C8FF660312
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc:     "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: Re: [PATCH 12/14] qtnfmac: fix debugfs entries for multiple cards on the same host
References: <20190320100340.14168-1-sergey.matyukevich.os@quantenna.com>
        <20190320100340.14168-13-sergey.matyukevich.os@quantenna.com>
        <874l7xzlmo.fsf@purkki.adurom.net>
        <20190320151641.3477cx3kuc3ipqam@bars> <8736ngsms9.fsf@codeaurora.org>
        <20190321082600.smb64hxdn2lpiqd5@bars>
Date:   Fri, 22 Mar 2019 10:44:07 +0200
In-Reply-To: <20190321082600.smb64hxdn2lpiqd5@bars> (Sergey Matyukevich's
        message of "Thu, 21 Mar 2019 08:26:06 +0000")
Message-ID: <874l7vnvs8.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:

> Hello Kalle,
>
>> >> > Fix creation of debugfs entries for qtnfmac wireless card: use separate
>> >> > directories for different wireless cards. This commit enables support
>> >> > for multiple qtnfmac wireless cards on the same PCIe host.
>> >> >
>> >> > Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
>> >> > ---
>> >> >  drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c | 6 +++++-
>> >> >  1 file changed, 5 insertions(+), 1 deletion(-)
>> >> >
>> >> > diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
>> >> > index b561b75e4433..56fc6d49c121 100644
>> >> > --- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
>> >> > +++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
>> >> > @@ -130,6 +130,8 @@ static int qtnf_dbg_shm_stats(struct seq_file *s, void *data)
>> >> >
>> >> >  int qtnf_pcie_fw_boot_done(struct qtnf_bus *bus)
>> >> >  {
>> >> > +     struct qtnf_pcie_bus_priv *priv = get_bus_priv(bus);
>> >> > +     char card_id[64];
>> >> >       int ret;
>> >> >
>> >> >       bus->fw_state = QTNF_FW_STATE_BOOT_DONE;
>> >> > @@ -137,7 +139,9 @@ int qtnf_pcie_fw_boot_done(struct qtnf_bus *bus)
>> >> >       if (ret) {
>> >> >               pr_err("failed to attach core\n");
>> >> >       } else {
>> >> > -             qtnf_debugfs_init(bus, DRV_NAME);
>> >> > +             snprintf(card_id, sizeof(card_id), "%s:%s",
>> >> > +                      DRV_NAME, pci_name(priv->pdev));
>> >>
>> >> Can you give an example for the path?
>> >>
>> >
>> > For instance:  /sys/kernel/debug/qtnfmac_pcie:0000:01:00.0
>> 
>> TBH not really fond of that. What about
>> "/sys/kernel/debug/qtnfmac/pcie:0000:01:00.0"? IIRC iwlwifi used
>> something like that.
>> 
>> And please add an example path to the commit log.
>
> Ok, will be fixed and resubmitted in v2.

Thanks.

> Or, alternatively, if the other patches are ok for you,
> feel free to drop the questionable ones and apply all
> the others. I will rework the rejected pieces and
> resubmit them, adding more pending fixes.

A good point, that's easier. So I have dropped patch 12.

-- 
Kalle Valo
