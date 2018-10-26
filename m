Return-Path: <SRS0=rthY=NG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEBF5C6786E
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 12:06:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7C37F20856
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 12:06:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="YbVlXD5B"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7C37F20856
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbeJZUnl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Oct 2018 16:43:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727491AbeJZUnl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Oct 2018 16:43:41 -0400
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0F8420869
        for <linux-wireless@vger.kernel.org>; Fri, 26 Oct 2018 12:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1540555610;
        bh=wqknGW/ST7oBy+cI2W6mybnqi3I80pIqwiDcxX8stKE=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=YbVlXD5BnBwV+iCgyBDCcUxhWWwdJkagXBWTm3eogDdmw+oNwmO95R9gfGDfuoSmh
         fCpWlGp7d44IqOYGJmz9ujGbkJq5+A4O6PAbQWpkWxXmK+bNaJ7HENvyFwCoF4BgZe
         VwzN4aiHCe1a2H+aWyoGxz0bB0YHt5zXa8TIg2lw=
Received: by mail-qt1-f178.google.com with SMTP id q41-v6so855939qtq.10
        for <linux-wireless@vger.kernel.org>; Fri, 26 Oct 2018 05:06:49 -0700 (PDT)
X-Gm-Message-State: AGRZ1gKGki9+UaZEf6Hsle7sW7K/g/BXVTxX1VkOzCh+AbMtKqTTInWc
        B/rLW7S3W2UttCd4/Bmas21TiEP+r/yfyd0d2tI=
X-Google-Smtp-Source: AJdET5cmvIFApLTxq2x0gYPruRdmFUdSPyIFBn//XlVuqRBw9XpK0Qq7Wn1TQpyhoSW3PWY3wMdgeH6C4QqHMQLux8Y=
X-Received: by 2002:a0c:ae76:: with SMTP id z51-v6mr2961332qvc.108.1540555609172;
 Fri, 26 Oct 2018 05:06:49 -0700 (PDT)
MIME-Version: 1.0
References: <1540210566-3192-1-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1540210566-3192-1-git-send-email-sgruszka@redhat.com>
From:   Josh Boyer <jwboyer@kernel.org>
Date:   Fri, 26 Oct 2018 08:06:37 -0400
X-Gmail-Original-Message-ID: <CA+5PVA5ujUo=GaZKsrGW+HhcEctYdkx9HYgRog1eYR0Yz=VO1Q@mail.gmail.com>
Message-ID: <CA+5PVA5ujUo=GaZKsrGW+HhcEctYdkx9HYgRog1eYR0Yz=VO1Q@mail.gmail.com>
Subject: Re: [PATCH] linux-firmware: add firmware for mt7650e
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Linux Firmware <linux-firmware@kernel.org>,
        linux-mediatek@lists.infradead.org,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        lorenzo.bianconi@redhat.com, sean.wang@kernel.org,
        steven.liu@mediatek.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Oct 22, 2018 at 8:16 AM Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>
> Add binary firmware for mt7650e based devices
>
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> ---
>  WHENCE               |   2 ++
>  mediatek/mt7650e.bin | Bin 0 -> 382212 bytes
>  2 files changed, 2 insertions(+)
>  create mode 100644 mediatek/mt7650e.bin

Applied and pushed out.

josh
