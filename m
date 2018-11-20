Return-Path: <SRS0=1os+=N7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30EC2C4161D
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Nov 2018 19:34:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8441820989
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Nov 2018 19:33:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JIHWC2MB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8441820989
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbeKUGEY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Nov 2018 01:04:24 -0500
Received: from mail-lj1-f171.google.com ([209.85.208.171]:32875 "EHLO
        mail-lj1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbeKUGEY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Nov 2018 01:04:24 -0500
Received: by mail-lj1-f171.google.com with SMTP id v1-v6so2703955ljd.0
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2018 11:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=z1s2rk+Y2cHtO9gMqNO208d+mN6qxd4exH9gn+cNzC0=;
        b=JIHWC2MBQIAw0R+FohSVmmYO8BkeFKz88MXXwtBHlye9mJf5HBYT20uVWUu2W0r08c
         GSiatLztfT0vYF+o5K+zYLGCwMkwzle9Z6fjwL/OGjROCDsILkcmy3fV6sYzEH7Pj+Vh
         fzUvLNvLEogopdY9tBnwyoGWuC17etlO8qNq7/C6MzWHeXSoirAjcdN36EjrfxzPtoip
         Nx37bkpFXlp57Fc4XxF/1ujnaksZDlN7dGb3jlo4rSWKd1Et1BLnHe547WxzrdiM1KrB
         1hOfadEizm/x6b5CEGZIJZQAcTF/nws75JDTWTVsvb79hg1M5vNMyUoJRzfmhC3o/FZl
         ZRLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=z1s2rk+Y2cHtO9gMqNO208d+mN6qxd4exH9gn+cNzC0=;
        b=dvZJzC0e2KQJTaHiLj++50SEIY/AxmCgRhxb0zhciRxzZP6LNencicegOVoYuPQzu9
         dPck/jI/g01+rxGHcjUclagk+kqMgkqymG845SRs1oDWKqfRZc5xJUHB9vV+NhmlVSep
         7rrAJyjTMVV4DqRW6A/9FGxnUxELO4b+yE/cJAFydadqgzHKlnmUXZz5YNH82bpDvsc3
         3Sk1pQxT4KTRVuyupPrbWI0MLhqFTeplrjsw277qBLiVsjWvn+kiW0cdejDOftrsmL0d
         w4nLD43GcC9iuFSH4R1iCzUEv+LshoJsbwXu/PtInIMGMKHrCER6oSTX+zBAf8OPZKL9
         7K5g==
X-Gm-Message-State: AA+aEWb8ahWbBqS4dfzTwYsXh6JSnB71LlaFwhLWfWnm6QFvPz2cAgE1
        0iC27gc4+TQ9ompQ0IL5Kg7MgvZP4HxiGLWGIjhVSANn
X-Google-Smtp-Source: AFSGD/UedPw2UIaULsFgWQDVwEVe3QATuDqJztjEd5a0C0Mq4PFx136PFIfx+nGSb8oCXmbQCMSkQVJ1bjmfBR3e3bU=
X-Received: by 2002:a2e:9a84:: with SMTP id p4-v6mr1973259lji.73.1542742416641;
 Tue, 20 Nov 2018 11:33:36 -0800 (PST)
MIME-Version: 1.0
From:   Ramon Fontes <ramonreisfontes@gmail.com>
Date:   Tue, 20 Nov 2018 16:33:25 -0300
Message-ID: <CAK8U23bW5ov=FfD0xBnio7FwS9NTjoyewfHWZhHAmZNPsA16Jw@mail.gmail.com>
Subject: mac80211_hwsim: multiple antennas
To:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Would be possible to simulate (or even add support to) multiple
antennas? I was trying to extend wmediumd to 802.11n according the
rates provided by http://mcsindex.com/, but the maximum rate I get is
~33Mbps, even if I set the MCS index to 15. Given the result, I
thought that it could be related to the number of antennas. Is my
assumption correct?

regards,
Ramon
