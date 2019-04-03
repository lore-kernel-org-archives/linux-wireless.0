Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D2FAC4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 20:07:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDFE12084B
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 20:07:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="RZcnSL0g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbfDCUGO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 16:06:14 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:33915 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbfDCUGO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 16:06:14 -0400
Received: by mail-lf1-f65.google.com with SMTP id y18so95267lfe.1
        for <linux-wireless@vger.kernel.org>; Wed, 03 Apr 2019 13:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c0fUpszyaU0eo3jzEjpIPrcZxMYMGoAQsGXKQStbdNI=;
        b=RZcnSL0gbqz0cb1HFPnjmNNan30QhfCGXjbio6paWx4A84UvIh9snrIsBoobcAdfI2
         gifkprfyv/6kz4NP+L11dCMpUEkRiDsPMKoxfiHsCOcqLHhazVZCmTk1P1J6bm192d+O
         Gx19UQpGy0fgSjgjzcrhSTRo37KXWlbuFz7nQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c0fUpszyaU0eo3jzEjpIPrcZxMYMGoAQsGXKQStbdNI=;
        b=K4jOoMvtehg96wKhluq7ZZAnZ6AUXe/TLZK0wZa7AqNIAOQeuK2FwdgYC2Y0eeMjrt
         vLmErHAUaf/Lv1hhoMjShZkAnq7RrpqM+gwXhK2IPxDqGv0IsazHVuqnS+O6eqxtpMLc
         yHiFlP8IUpkFdSCHwpNnkpF5pZhrgxGEjgVFtUZ3JoMmYr7SoD3C8BmgN9hNyeiTVHEW
         TV9WEfDbpKHQIShxAsLvnvbFWD+UgCXDNReB4JlKR4L6Nhm8nBkPN6AXzgsY07AyCr6P
         Y3Zves1ly13t4q3yfzxQuWvZks1azy3/8foIC6tE5xbtubRQabvni4HFTPbTTAesndBk
         V3Vg==
X-Gm-Message-State: APjAAAVq9Pgw2ARBg7fE6E2Hn1Uia9nBxP38HiQ+9VALx5bg9QY3QYr1
        QehpVclotgwJaTlHN4M5hSxss5rqa74=
X-Google-Smtp-Source: APXvYqxdw+clCR2nl40W7FvAuTSMJTFB0FUiQW1MuNr9TXFik2nZsiD/geZAxOgKSY809q6DEHJPGQ==
X-Received: by 2002:a19:7d84:: with SMTP id y126mr925021lfc.124.1554321971790;
        Wed, 03 Apr 2019 13:06:11 -0700 (PDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id v4sm471923ljh.40.2019.04.03.13.06.10
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Apr 2019 13:06:10 -0700 (PDT)
Received: by mail-lj1-f182.google.com with SMTP id v22so11355126lje.9
        for <linux-wireless@vger.kernel.org>; Wed, 03 Apr 2019 13:06:10 -0700 (PDT)
X-Received: by 2002:a2e:9211:: with SMTP id k17mr974224ljg.46.1554321969605;
 Wed, 03 Apr 2019 13:06:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190402070338.GB15171@kadam>
In-Reply-To: <20190402070338.GB15171@kadam>
From:   Brian Norris <briannorris@chromium.org>
Date:   Wed, 3 Apr 2019 13:05:58 -0700
X-Gmail-Original-Message-ID: <CA+ASDXPrTo2b=o--Sik7iufZQ1J6c5LANDyYWof=LGAZA3ALOg@mail.gmail.com>
Message-ID: <CA+ASDXPrTo2b=o--Sik7iufZQ1J6c5LANDyYWof=LGAZA3ALOg@mail.gmail.com>
Subject: Re: [PATCH] mwifiex: add a bounds check in mwifiex_process_sta_rx_packet()
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Apr 2, 2019 at 12:03 AM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> Smatch complains that "local_rx_pd->priority" can't be trusted because
> it comes from skb->data and it can go up to 255 instead of being capped
> in the 0-7 range.  A few lines earlier, on the other side of the if
> statement, we cap priority so it seems harmless to add a bounds check
> here as well.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Seems right to me:

Reviewed-by: Brian Norris <briannorris@chromium.org>
