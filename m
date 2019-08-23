Return-Path: <SRS0=oGbZ=WT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44368C3A5A2
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Aug 2019 06:37:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1969022CEC
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Aug 2019 06:37:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=endlessm-com.20150623.gappssmtp.com header.i=@endlessm-com.20150623.gappssmtp.com header.b="d0p3cB9w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404609AbfHWGhe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 23 Aug 2019 02:37:34 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:37368 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404002AbfHWGhe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Aug 2019 02:37:34 -0400
Received: by mail-pg1-f193.google.com with SMTP id d1so5214814pgp.4
        for <linux-wireless@vger.kernel.org>; Thu, 22 Aug 2019 23:37:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=endlessm-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6tbH7ms3h4uM5U9Ws6DAqfHnohIIVbIkwpqBSedRmlM=;
        b=d0p3cB9w0XEvZNGh/sT2OplEKsIxAB3wVwUy9GQCSdE9+kmR4zjvRI6sUCjM9qNq6+
         kqFN87bnXgu0pqReGQwC1LnjpFejNbSxg8F/4Ct9SoPPct6cEKjsKiQwD12QxpMRIuo/
         zy9f9W3YFNthLQv+zl6Em4HM5mhAb+YH8qmoQolhR8LwfWGhHnW+prF4XEmX9gxC3L4Y
         yqrVY04g/3kVdbIZyVdqdFYF0qyt12ap7lncAljl6/4VQgfGvH7AQV+htU/ZJdCGpfz0
         hC0AAQkvGHv6tKE/KjfY+QKApQ2XLbOpI93/sO4AdZiJ5P5/HWIoajH6fQxUOCH53PyO
         WziQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6tbH7ms3h4uM5U9Ws6DAqfHnohIIVbIkwpqBSedRmlM=;
        b=LvCVZZljYDvhmAcIU/7Gt1hXqG6dSZCfFtsQOPdSfxGkDKvaCMKeUBaRpH8BMWjKfg
         53VZ9ozLam36eos+SqMYqKbPgKtgr+dW8RSXmKVd6sZ2meOaSztgMi3Y+TkHwtIwJTup
         sPUg2iWhWGTCihJxqaZpVDl9E6zJOJM2NA/GKYEUsqZD9CcBZzskiyK9MzrImr3feuV1
         ySt+UBtWo/gG6INnssElmg7FcjU4cMj+n1QxOCw+ymRY1JRqq5hesUAHqz+jVbrwcmJg
         6PfIr5prtHDbpW7UPsLmVoK2OM4x8NnJV11jZZUuVy1zvpVPGGliD5/bDIoy64CdwANb
         lTMg==
X-Gm-Message-State: APjAAAU1Rl8ZwlX3CvUdWrVTyviDfRDYPv9wwGTGV1DAgHPrnZboNRCn
        9UyrsoFwh/vqcK6XDVZ0OGYrEg==
X-Google-Smtp-Source: APXvYqwXxybST867ll8fPC2LrVM088u7XKUQe2ZACdhxtvL7S+6qAwYcCFMJlzjhufpykZLaXHBdXg==
X-Received: by 2002:a62:3744:: with SMTP id e65mr3502237pfa.69.1566542253388;
        Thu, 22 Aug 2019 23:37:33 -0700 (PDT)
Received: from limbo.local (123-204-46-122.static.seed.net.tw. [123.204.46.122])
        by smtp.gmail.com with ESMTPSA id g19sm1552016pfh.27.2019.08.22.23.37.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Aug 2019 23:37:32 -0700 (PDT)
From:   Daniel Drake <drake@endlessm.com>
To:     yhchuang@realtek.com
Cc:     briannorris@chromium.org, gojun077@gmail.com,
        jano.vesely@gmail.com, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, linux@endlessm.com
Subject: Re: [PATCH v2] rtw88: pci: enable MSI interrupt
Date:   Fri, 23 Aug 2019 14:37:28 +0800
Message-Id: <20190823063728.14117-1-drake@endlessm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <1565166487-22048-1-git-send-email-yhchuang@realtek.com>
References: <1565166487-22048-1-git-send-email-yhchuang@realtek.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> +	rtw_pci_disable_interrupt(rtwdev, rtwpci);

I checked the discussion on the v1 patch thread but I still don't follow
this.

You're worried about the case where we're inside the interrupt handler and:
 1. We read the interrupt status to note what needs to be done
 2. <another interrupt arrives here, requiring other work to be done>
 3. We clear the interrupt status bits
 4. We proceed to handle the interrupt but missing any work requested by
    the interrupt in step 2.

Is that right?

I'm not an expert here, but I don't think this is something that drivers
have to worry about. Surely the interrupt controller can be expected to
have a mechanism to "queue up" any interrupt that arrives while an
interrupt is being handled? Otherwise handling of all types of
edge-triggered interrupts (not just MSI) would be overly painful across the
board.

See e.g. https://patchwork.kernel.org/patch/3333681/ as a reference for
what correct interrupt controller behaviour should look like.

> +		ret = pci_enable_msi(pdev);

pci_enable_msi() is "deprecated, don't use"

Thanks
Daniel

