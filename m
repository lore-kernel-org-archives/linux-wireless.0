Return-Path: <SRS0=8CYu=OJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D471FC04EB8
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Nov 2018 21:00:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9718D20663
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Nov 2018 21:00:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="NW7BOVuO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9718D20663
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbeLAIKi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 1 Dec 2018 03:10:38 -0500
Received: from mail-io1-f44.google.com ([209.85.166.44]:33860 "EHLO
        mail-io1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbeLAIKg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 1 Dec 2018 03:10:36 -0500
Received: by mail-io1-f44.google.com with SMTP id f6so5671239iob.1
        for <linux-wireless@vger.kernel.org>; Fri, 30 Nov 2018 13:00:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+OZW+mgJ+I72x3su7oeWvAOHTBaHHSjOQyXXHNjFeDM=;
        b=NW7BOVuOTEfqbnIzjC3iWvSxRlMbofFIk2/SjhwWn1+xQCwp6KUuEDRuBjEgt9zUfI
         aRAQrIiiy4MPrbMOph61zMN+Bg5PhUUs9AiRQHYAd97+ZCB43i15slBpMQwTr7M14Wek
         GZsWRsiFw0pZxPYpBLwS+Ds7YM/SCGOpRbnCA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+OZW+mgJ+I72x3su7oeWvAOHTBaHHSjOQyXXHNjFeDM=;
        b=sm3N7Up1NytagHixhgqRSDv21I6xvqXES0s93w9W8H2GbwphPi+/SKeWF5L0VAEfo0
         CURFiCN5FWmnG5OEeft9fiUFlRH87JbomeBGq+ygeFWYaQOvJfNxsCwfpj+min5R3WHp
         etvugXChDCvzwkTkZryntXky3nNgpcF5FDAAjTZRXIKzRx8H67KIhbqDW637VjCoGAeR
         aNgDR+Yfn5UcT8hWhJMBgr/wTdU3Z2XVaeMCk+PUP3dJ6SZwWqwmqkjU+MsQhi23cmyM
         fbNz64luIQFDSZQ8g0UPRMdn92bZgeaw1djq5ky2yD6Um4Hqhl3qIqDzHvELPTEIwBd5
         sXEw==
X-Gm-Message-State: AA+aEWbFnRETrUMY5Skd0VadbJDjUScpLQ0OV0l/xRyYdWcOz14I8Ab/
        FIrV15l8BQ9liGjvkqokdyapgIWYSiM=
X-Google-Smtp-Source: AFSGD/UkniFCS3U41hHtf9/oFQXebu0nGVvw4Q7o94JOMuNCm94T1/H9vrJac9Vnixe30RQLsc0nIQ==
X-Received: by 2002:a6b:750a:: with SMTP id l10mr2634571ioh.120.1543611602535;
        Fri, 30 Nov 2018 13:00:02 -0800 (PST)
Received: from mail-it1-f177.google.com (mail-it1-f177.google.com. [209.85.166.177])
        by smtp.gmail.com with ESMTPSA id 137sm130230itm.21.2018.11.30.13.00.01
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Nov 2018 13:00:01 -0800 (PST)
Received: by mail-it1-f177.google.com with SMTP id c9so491953itj.1
        for <linux-wireless@vger.kernel.org>; Fri, 30 Nov 2018 13:00:01 -0800 (PST)
X-Received: by 2002:a05:660c:1cc:: with SMTP id s12mr295452itk.33.1543611600889;
 Fri, 30 Nov 2018 13:00:00 -0800 (PST)
MIME-Version: 1.0
References: <20181129042522.11767-1-govinds@codeaurora.org>
In-Reply-To: <20181129042522.11767-1-govinds@codeaurora.org>
From:   Brian Norris <briannorris@chromium.org>
Date:   Fri, 30 Nov 2018 12:59:49 -0800
X-Gmail-Original-Message-ID: <CA+ASDXMOqzXk9HrX9AS58cUfKOHeXA7zN_ME3+zDZXQcok_0Tg@mail.gmail.com>
Message-ID: <CA+ASDXMOqzXk9HrX9AS58cUfKOHeXA7zN_ME3+zDZXQcok_0Tg@mail.gmail.com>
Subject: Re: [PATCH] ath10k: Move non-fatal warn logs to dbg level
To:     govinds@codeaurora.org
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Nov 28, 2018 at 8:25 PM Govind Singh <govinds@codeaurora.org> wrote:
>
> During driver load below warn logs are printed in the console.
> Since driver may not implement all wmi events sent by fw and
> all of them are non-fatal, move this log to debug level to
> remove un-necessary warn message on console.
>
> [  361.887230] ath10k_snoc a000000.wifi: Unknown eventid: 16393
> [  361.907037] ath10k_snoc a000000.wifi: Unknown eventid: 237569
>
> Signed-off-by: Govind Singh <govinds@codeaurora.org>

Alternatively, you could add these ignored commands to wmi-tlv.h, and
just ignore them specifically. That's better documentation, in case
new WMI events come along that *are* important to notice when we
ignore them. There are other recent examples of that sort of patch
being merged.

Brian
