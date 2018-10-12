Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABE5EC43441
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 12:09:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6781E2086A
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 12:09:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="LPb5VNTY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6781E2086A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728617AbeJLTlj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 15:41:39 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:41410 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728483AbeJLTlj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 15:41:39 -0400
Received: by mail-lj1-f195.google.com with SMTP id u21-v6so11157403lja.8
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2018 05:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ohXSpvsbnmozTruB7n6Vl+ZohP5jo2cbULxaKoBjRW4=;
        b=LPb5VNTYqc6a5Hc1WG+F/KabNR4eksd/kEFLlK4eESjaTuNBjVxePC672Vp8iPQEOy
         bMDbt/TeGlmJPi42jfsPcJJDdcMNhTIAEY5lsmq8wkS9KryTsuaL2pnKfXHxnBEwJIdO
         F7E200tyfNKGCxGTdvJRKRyZMA7L8syZJBcOs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ohXSpvsbnmozTruB7n6Vl+ZohP5jo2cbULxaKoBjRW4=;
        b=rk03j0B0uozHlH0z1qXgJLjqxt1/+mdnFTij8iq4Zn+K8zvzj6pQpqxszV0U0XGwQZ
         EcOD7T8DrKsx3/q2ibe76Q8e9Pj/pokl72DfehZPq9ekFDIXnwOtI6NfF9o8LZwrRWqK
         29/5Vt5FiKTiLxtqxR5dbOWYs2IfygXeAur3OcQAYG+AYBQN2doX1QpOOMk5HO5quP3N
         HO0lqEycyicxdaLSvpT8xAP02xq/bt2FcS1MIc39t3snvMu1wTAZss5HusLX8Up71XkO
         BZhqzmn0g+3dYnjQa4YGxpaWI73HyFFgsp0xB5FHgXz3a/L3PW82VZiOTh/zbDukDoxE
         pm1g==
X-Gm-Message-State: ABuFfogXNHmMaRyWUjU2xYddkE7Ai760LA9h+qZwKPGenwBmhu+6KGou
        d9BDGuAreaTdwMcUntk0SxGm1g==
X-Google-Smtp-Source: ACcGV60SIxXhgQ14TsjIe4LShpN4214uP3E62xmE4jKN0fLY/kDHP0gKoquyYtd+dmZFqG3zlM17vA==
X-Received: by 2002:a2e:1b15:: with SMTP id b21-v6mr3410669ljb.104.1539346167908;
        Fri, 12 Oct 2018 05:09:27 -0700 (PDT)
Received: from centauri.lan (h-229-118.A785.priv.bahnhof.se. [5.150.229.118])
        by smtp.gmail.com with ESMTPSA id z4-v6sm205127lfh.74.2018.10.12.05.09.26
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Oct 2018 05:09:27 -0700 (PDT)
Date:   Fri, 12 Oct 2018 14:09:24 +0200
From:   Niklas Cassel <niklas.cassel@linaro.org>
To:     Brian Norris <briannorris@chromium.org>,
        Govind Singh <govinds@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     ath10k@lists.infradead.org, bjorn.andersson@linaro.org,
        andy.gross@linaro.org, devicetree@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v5 0/6] *** Add support for wifi QMI client handshakes ***
Message-ID: <20181012120924.GA1030@centauri.lan>
References: <20180815092637.11455-1-govinds@codeaurora.org>
 <20181009003628.GA253926@ban.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181009003628.GA253926@ban.mtv.corp.google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Oct 08, 2018 at 05:36:30PM -0700, Brian Norris wrote:
> + linux-msm
> 
> Hi Govind, Kalle,
> 
> On Wed, Aug 15, 2018 at 02:56:31PM +0530, Govind Singh wrote:
> > Add QMI client handshakes for Q6 integrated WLAN connectivity subsystem.
> > This module is responsible for communicating WLAN control messages to FW
> > over QMI interface. This patch series enables the qmi handshakes required for
> > WCN3990 chipset.
> [...]
> 
> What's the status of this patchset? It has seen various stages of
> review, and except for the fact that Govind seems to have dropped
> various Reviewed-by/Acked-by tags (which Rob noticed), I don't see any
> relevant feedback that should be blocking it.
> 
> I previously had concerns about the firmware boot sequence -- that it
> required a Qualcomm-specific TFTP service over QRTR, which had no open
> source implementations. There is now a published daemon that worked for
> me [1], as well as firmware releases that loaded modem and Wifi firmware
> together, such that this TFTP service is not needed at all. So my
> concerns there are no longer blocking.
> 
> And I think Rob already reviewed the relevant DT bindings (but again,
> Govind missed collecting that tag for this series).
> 
> So the only outstanding request I see is to collect the appropriate
> tags. Should Govind resend the whole series just for that?
> 
> FWIW, I've been using this series for a while now, and I reviewed
> earlier versions. I can provide this for the whole series:
> 
> Reviewed-by: Brian Norris <briannorris@chromium.org>

Hello Kalle,

I see that this patch series has been added to your master-pending branch.

It seems to be lacking Brians Reviewed-by tags (from above).


The diff between v4 and v5 is just:

+++ b/drivers/net/wireless/ath/ath10k/qmi.c
@@ -1010,10 +1010,10 @@ int ath10k_qmi_deinit(struct ath10k *ar)
        struct ath10k_snoc *ar_snoc = ath10k_snoc_priv(ar);
        struct ath10k_qmi *qmi = ar_snoc->qmi;
 
+       qmi_handle_release(&qmi->qmi_hdl);
        cancel_work_sync(&qmi->event_work);
        destroy_workqueue(qmi->event_wq);
-       qmi_handle_release(&qmi->qmi_hdl);
-       qmi = NULL;
+       ar_snoc->qmi = NULL;
 
        return 0;
 }

I've given my Acked-by on v4:
https://patchwork.kernel.org/cover/10540111/
The change between v4 and v5 does not warrant the removal of those tags,
so please re-add them.

Rob has given his Reviewed-by on the dt-binding on v4:
https://patchwork.kernel.org/patch/10540115/
The dt-binding hasn't changed between v4 and v5, so please re-add it.


I also noted that kbuild test robot complain about this series on x86:
http://lists.infradead.org/pipermail/ath10k/2018-October/012268.html
Are test errors still valid?

My patch series that makes QMI_HELPERS selectable for compile test
(e.g. x86), is queued up for 4.20~5.0:
https://git.kernel.org/pub/scm/linux/kernel/git/agross/linux.git/log/?h=qcom-drivers-for-4.20

Does this patch series make the errors go away, or are they unrelated?


Kind regards,
Niklas

> 
> If nothing else, I think it's important to get someone to merge the DT
> bindings from this series, because Govind is now trying to extend the DT
> binding and to enable the WCN3990 device node in the SDM845 device tree
> nodes.
> 
> Regards,
> Brian
> 
> [1] https://github.com/andersson/tqftpserv
> [2] See this series:
>     https://patchwork.kernel.org/cover/10621863/
>     Govind didn't send it to the right mailing lists yet, but we're
>     close...
