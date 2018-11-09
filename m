Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B63CC43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 13:51:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1604F20827
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 13:51:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1604F20827
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728085AbeKIXbo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 18:31:44 -0500
Received: from mail-wr1-f45.google.com ([209.85.221.45]:35270 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727781AbeKIXbo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 18:31:44 -0500
Received: by mail-wr1-f45.google.com with SMTP id z16-v6so1982556wrv.2
        for <linux-wireless@vger.kernel.org>; Fri, 09 Nov 2018 05:51:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=i0Oz62XSBokjw6mNdKyt+0v++lf9VOHOZU+h0anJUmQ=;
        b=NlZWCX13aMdEIiLSzrA2xX1lSWrpkbLs+Hj0CWT/717lXUjpf0IMQIpKpzxM22Lp0d
         /prKOKqxA/X2qOvaEJJ4iwavuZZ+2QXI5t/wxTgnDvP9fF59rV7RSfqXLrGBvI9WNUQg
         Kkhn8Geqlpe1rDJif8cYpzPns1FpjVs4XMUivHwf4mayVgHDGRgZLnwRu/hWTt4jA1i6
         d4nD2BFzDenH2M7N4h5dUx9gy17cuIKMullQKuANWuMe+W12j7N2op6nwGQPwGhMoBN6
         G1sNXMe/zCzYgocPSqXsKlAGXqx1ObcwVb0MNRUJCvSN8fNie5yNdga7J1dCSIuvtQJC
         N3lw==
X-Gm-Message-State: AGRZ1gLUzJd1TOd/9hHg+0lMEDx3TiyJrwgCww3vIXpL+LTlgs7eEH68
        QONtuH/fbrMkZM7VerR0miffTg==
X-Google-Smtp-Source: AJdET5dGUEL5pGYMnqaINAxm/WIzJL4GZ7CUa20+mu5PJ3nfO7p+grZA0dwdOg1b9T2G+zUt//kuWw==
X-Received: by 2002:adf:9dd1:: with SMTP id q17-v6mr7857809wre.12.1541771460016;
        Fri, 09 Nov 2018 05:51:00 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id a126-v6sm1049679wmh.4.2018.11.09.05.50.59
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 09 Nov 2018 05:50:59 -0800 (PST)
Date:   Fri, 9 Nov 2018 14:50:55 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] mt76: remove wait argument from mt76x02_mcu_calibrate
Message-ID: <20181109135054.GC9453@localhost.localdomain>
References: <1541760970-26622-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1541760970-26622-1-git-send-email-sgruszka@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> We always wait for CMD_CALIBRATION_OP mcu message, but wait argument is used
> for do additional MT_MCU_COM_REG0 register operations, which are needed
> for mt76x2e devices and we can use appropriate check instead of wait argument.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---

Reviewed-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
