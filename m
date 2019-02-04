Return-Path: <SRS0=6Uy3=QL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF678C282C4
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 18:32:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91FF42087C
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Feb 2019 18:32:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="L++MNUCf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729262AbfBDSch (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Feb 2019 13:32:37 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:45870 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727946AbfBDSch (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Feb 2019 13:32:37 -0500
Received: by mail-ed1-f66.google.com with SMTP id d39so717876edb.12
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2019 10:32:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oJM2kz1C9++EBQEWdnYTIr/U9JufikxjXn1M+L9D3Rg=;
        b=L++MNUCfGjS7akQ82w+QvWLdL6MUdKewSEwA4gw11xNGRMgMW50QfY/WIpKcG58+oi
         tE68K6pWZrZ0mHeLUWlc5Jw6YgLg7fVJNSg5p87dUycxO3mUAbhOIx5kJSUNWkjV38uC
         22sJ9dOMFeaRlcTMDMm1S3NcpoMPOFWLgR28M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oJM2kz1C9++EBQEWdnYTIr/U9JufikxjXn1M+L9D3Rg=;
        b=UbkZESSPulWpQCPe3u+vvqueECO1PhhNkq9DaWShFH3lDNeOezB/oJ6WxqxY4tHzGB
         NJVop3g5TeEBImdBubwWygHNaKe3/tLdWAGfEhJaArWfmVH4JnGDodWjODPcyLFVgi+j
         zuDzmMKfQq5vtpycVNnYJLkHc1jYYvQEn7sDzheu3wO5byXl9gvquzs4Fz7C5QRXv9wK
         i7WzEONzyy9psz++aAwvLHhTKcvJ7YY7f6L5iGwI9yPxVSADrn1maDoQuDtYbZIAz16g
         5SguG8TmQ1OZQQ49ahBls7rEqM7elTLBH6BlD6QzkttIZFNzF1hB9ptiad6cn5hMOiUJ
         qh7w==
X-Gm-Message-State: AHQUAuaaVh8OwqoDDlj721PeHLERFc0jG/KmH1UFSIxXprvUHI7/EF+W
        pbqLv/rCFJ7wlif3j5ZEdvydN01JdRM=
X-Google-Smtp-Source: AHgI3IYQb3NLWNTEeMRfixva+fdC4FioEYY8s1bD2mUBkt6YK142bwjZyK9O9Qm8yIMer+mf1qP1lg==
X-Received: by 2002:a50:8eea:: with SMTP id x39mr572552edx.177.1549305155376;
        Mon, 04 Feb 2019 10:32:35 -0800 (PST)
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com. [209.85.208.42])
        by smtp.gmail.com with ESMTPSA id l10sm2733006ejq.55.2019.02.04.10.32.33
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 04 Feb 2019 10:32:34 -0800 (PST)
Received: by mail-ed1-f42.google.com with SMTP id h15so768597edb.4
        for <linux-wireless@vger.kernel.org>; Mon, 04 Feb 2019 10:32:33 -0800 (PST)
X-Received: by 2002:a17:906:b886:: with SMTP id hb6mr539503ejb.71.1549305153379;
 Mon, 04 Feb 2019 10:32:33 -0800 (PST)
MIME-Version: 1.0
References: <20190114153558.972-1-chunkeey@gmail.com> <87tvhjd0c7.fsf@kamboji.qca.qualcomm.com>
 <4891660.4ehrp1WKpm@debian64>
In-Reply-To: <4891660.4ehrp1WKpm@debian64>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 4 Feb 2019 10:32:21 -0800
X-Gmail-Original-Message-ID: <CA+ASDXP5KFmsUXuOC2WfgBQX4VGAT7dqCHUTmPguxgeveYU5tA@mail.gmail.com>
Message-ID: <CA+ASDXP5KFmsUXuOC2WfgBQX4VGAT7dqCHUTmPguxgeveYU5tA@mail.gmail.com>
Subject: Re: [PATCH] ath10k: implement set_base_macaddr to fix rx-bssid mask
 in multiple APs conf
To:     Christian Lamparter <chunkeey@gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>,
        Mathias Kresin <dev@kresin.me>, Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Feb 4, 2019 at 10:10 AM Christian Lamparter <chunkeey@gmail.com> wrote:
> On Monday, February 4, 2019 4:45:12 PM CET Kalle Valo wrote:
> > Christian Lamparter <chunkeey@gmail.com> writes:
> > > --- a/drivers/net/wireless/ath/ath10k/core.c
> > > +++ b/drivers/net/wireless/ath/ath10k/core.c
> > > @@ -2649,6 +2649,13 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode,
> > >             goto err_hif_stop;
> > >     }
> > >
> > > +   status = ath10k_wmi_pdev_set_base_macaddr(ar, ar->mac_addr);
> > > +   if (status) {
> > > +           ath10k_err(ar,
> > > +                      "failed to set base mac address: %d\n", status);
> > > +           goto err_hif_stop;
> > > +   }
> >
> > Oh, and as the new parameter is not supported with WMI TLV interface
> > (QCA6174, WCN3990 etc) this will print an error on those.
>
> This also means that Brian won't be able to test/verify this anyway?

Well, I'd be able to tell you if this started dumping new errors to the log :)

And in fact, it seems this crashes my firmware:

[  150.091401] qcom-q6v5-mss 4080000.remoteproc: fatal error received:
err_qdi.c:456:EF:wlan_process:1:cmnos_thread.c:3921:Asserted in
wlan_dev.c:WLAN_GET_MAC_ID_FROM_WMI_PDEV_ID:536

Note that I'm running WCN3990, and I haven't configure any sort of PD
restart -- so any WiFi firmware assertions/crashes take down the
entire modem/WiFi.

IOW:

Tested-and-found-wanting-by: Brian Norris <briannorris@chromium.org>

Willing to test a v2!

Regards,
Brian
