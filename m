Return-Path: <SRS0=K8Xh=QX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8853BC43381
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Feb 2019 23:45:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C45221A49
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Feb 2019 23:45:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=ibsgaard-io.20150623.gappssmtp.com header.i=@ibsgaard-io.20150623.gappssmtp.com header.b="yaM/TIwp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbfBPXpc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Feb 2019 18:45:32 -0500
Received: from mail-it1-f173.google.com ([209.85.166.173]:40901 "EHLO
        mail-it1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727144AbfBPXpb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Feb 2019 18:45:31 -0500
Received: by mail-it1-f173.google.com with SMTP id i2so32759108ite.5
        for <linux-wireless@vger.kernel.org>; Sat, 16 Feb 2019 15:45:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ibsgaard-io.20150623.gappssmtp.com; s=20150623;
        h=mime-version:from:date:message-id:subject:to;
        bh=Y1TJvqDE02uJjxzTpbaUOcN1F2UOZ3+kZDTAMMbpyec=;
        b=yaM/TIwpeuVA6U1rypIXYOcwpms9oEarHPSXj8Sqm9NBEwWW1LhQh+FFMotGMDiRVl
         y6xynEIb0zl/LjhlELP/HNDlxsAjP2rKW4IYHpYgNRh5ee5GCOXRmFKowjGI/R03Cry7
         WtnaxcYILJtcQDfVHelIXmBMnC6F+ItJpNZ4nn/qQ1vKhW/yEznOOsD2apyEo6nxbbfY
         V2s3DnwGy6qQWw4ruXoXMxxPr3uZRY9f68NVVYZkopzX8OohoczvUAXCu/tp3t5jLmrU
         l5H3L2Os/qWaTihW64T9E0DYOwpmmmrnzl42X22B8nUAmj7J4wHdYv4SFZQMbt79S6Px
         pZBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=Y1TJvqDE02uJjxzTpbaUOcN1F2UOZ3+kZDTAMMbpyec=;
        b=WfV85AnAovVxxQ76rkTkJZgsZeP3KTNO7wlXx7IZX26XqukmW2tytDmE3OuY+zdKYk
         g1BwK3J3CX9VEuEvpmX6cTSaxb8cYbF2kWzTE3dLaQ6jnuO1EICGjFycvCdOgq5Q9H9u
         lRgKQdOx3VZ/KQpGTikBOO6IvtBAkCDAL7lNLci/Lx3HsXo2aPPOh3S1UVdBBGxMKnG1
         CIEjHxaoLj0vBKkiZoIdHnm+/sgBEjWYDg7ujQzHcoU1ArnvEc1ZIybDEkHy/16s/7T1
         2liDSbH43yLcCtqj9IJpMItGtUuXRC8kix7cH+MER/68G8uw7hv/+kbNMn9rOW4GCPFT
         TOkw==
X-Gm-Message-State: AHQUAuZHlKP+yWKkc0pPCN/SWtFHhjmBSzX0xAC0CC+h3BdA4/0OgHte
        wQkrdK7BVGEDF4KjwdRE+T5JlnHvzgo4mN3K8c7AuFS2nZg=
X-Google-Smtp-Source: AHgI3IZVcAwz0aC9cTmTeZrk8BgHT77LB2ZfLPT65fKFGyL+NuctHRa4eklhqItjwHWnqAsYsrHE3d1S0F9vVToAkzs=
X-Received: by 2002:a02:8899:: with SMTP id n25mr9235062jaj.7.1550360730958;
 Sat, 16 Feb 2019 15:45:30 -0800 (PST)
MIME-Version: 1.0
From:   thomas pedersen <thomas@ibsgaard.io>
Date:   Sat, 16 Feb 2019 15:45:20 -0800
Message-ID: <CABWD38man7mGiConmvmK0V=35P9zV7uvhVoY-8eSQQeO9W2+Qw@mail.gmail.com>
Subject: preparing for 802.11ah channels
To:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello,

I'm working on defining new channels for S1G PHYs in mac80211. These
are in the 900MHz range and center frequency for the 1MHz channels are
on a half MHz, while the existing channel definitions are in units of
MHz.

In order to support the new channels we could change the internal
center frequency units to KHz and extend the nl80211 API so
NL80211_FREQUENCY_ATTR_FREQ and NL80211_ATTR_WIPHY_FREQ get _KHZ
variants while renaming the original attributes to _MHZ to reflect the
units.

From looking at the code it looks like this should be fairly
straightforward, if involving a lot of changes since the driver
declarations would have to change too. Am I missing something
obviously wrong, or does this sound reasonable?

Thanks,

Thomas
