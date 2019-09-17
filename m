Return-Path: <SRS0=ULv+=XM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 767FFC4CECD
	for <linux-wireless@archiver.kernel.org>; Tue, 17 Sep 2019 16:33:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D64120665
	for <linux-wireless@archiver.kernel.org>; Tue, 17 Sep 2019 16:33:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="dgmHFsLV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730351AbfIQQdI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 17 Sep 2019 12:33:08 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:44995 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730281AbfIQQdI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Sep 2019 12:33:08 -0400
Received: by mail-lf1-f68.google.com with SMTP id q11so3376638lfc.11
        for <linux-wireless@vger.kernel.org>; Tue, 17 Sep 2019 09:33:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iQDRRInEfkOmolUWUlkWs8+kiucdxwd5FC1fGShr5c4=;
        b=dgmHFsLVgUDYlzKnx2AI9EBhRyfdronIQPVc9nmshBfpBav41pgLiKHS47u1qbTMRV
         /OwRABb4gyj/8eMrwgTXTZKo1ZEr3OZ650q9RGo2V85QlQDznn7pVQpcjv7vyWQko1kV
         m46DsLgVSgceBujZfIRs97mCBeZ7wHovtGGcM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iQDRRInEfkOmolUWUlkWs8+kiucdxwd5FC1fGShr5c4=;
        b=S7f68G/jur2LcXZWk56/awkfZ1vnS20OAQrbffdoAEq5dgfHkq/59pC88LvXB4VVOI
         6BKpem1tgJM3frnbs5AbrfrQKj8QajqyrPLoZA0rJJ/OtrYgibpwbIHjkZE7ZjMJoSDA
         tA3IQyLBGy43d6fegDOaqkeG9U3Z7HUnomkRt3mK5W9P6A6QfoLYvfW1uK3aJBHvem6v
         CkjzhqAtONPGFkB5O5fjYtb9sWXMbAW+JmoigNKyz54d1PZkDV3KAkIYT/VZJyrQpXfr
         3LvoAKo812ay/SN+V70uKWRbS9J0DAouCqVR/XzNwEMjubAcsI1CZaAHK4+ok1vdQD1A
         vKmA==
X-Gm-Message-State: APjAAAXZZliSgLeBqpRWR6Oejhhn8HrLu212MDI8fIOerWLsqlTormYx
        WSNDwiQSp5GWLaTzKjEipXgESHPcViM=
X-Google-Smtp-Source: APXvYqwD4XddxF/zaidnE3Bmn8FDxarSmtRy/ggzuk7/X/L2N1h0q6dkFjF/ooPrJtsAX1cZtCjhQQ==
X-Received: by 2002:a19:6455:: with SMTP id b21mr2626927lfj.167.1568737986211;
        Tue, 17 Sep 2019 09:33:06 -0700 (PDT)
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com. [209.85.208.171])
        by smtp.gmail.com with ESMTPSA id h9sm517287lfp.40.2019.09.17.09.33.04
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Sep 2019 09:33:05 -0700 (PDT)
Received: by mail-lj1-f171.google.com with SMTP id a22so4253947ljd.0
        for <linux-wireless@vger.kernel.org>; Tue, 17 Sep 2019 09:33:04 -0700 (PDT)
X-Received: by 2002:a2e:8592:: with SMTP id b18mr2284561lji.18.1568737984442;
 Tue, 17 Sep 2019 09:33:04 -0700 (PDT)
MIME-Version: 1.0
References: <1534402113-14337-1-git-send-email-wgong@codeaurora.org> <20181114225910.GA220599@google.com>
In-Reply-To: <20181114225910.GA220599@google.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Tue, 17 Sep 2019 09:32:52 -0700
X-Gmail-Original-Message-ID: <CA+ASDXMh7vdfkA5jtJqWEU-g-4Ta5Xvy046zujyASZcESCGhAQ@mail.gmail.com>
Message-ID: <CA+ASDXMh7vdfkA5jtJqWEU-g-4Ta5Xvy046zujyASZcESCGhAQ@mail.gmail.com>
Subject: Re: [PATCH v3] ath10k: support NET_DETECT WoWLAN feature
To:     Wen Gong <wgong@codeaurora.org>
Cc:     ath10k@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Since Wen has once again suggested I use this patch in other forums,
I'll ping here to note:

On Wed, Nov 14, 2018 at 2:59 PM Brian Norris <briannorris@chromium.org> wrote:
> You've introduced a regression in 4.20-rc1:

This regression still survives in the latest tree. Is it fair to just
submit a revert?

Brian
