Return-Path: <SRS0=mmBG=5H=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C78BC4332E
	for <linux-wireless@archiver.kernel.org>; Sun, 22 Mar 2020 12:21:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D032120769
	for <linux-wireless@archiver.kernel.org>; Sun, 22 Mar 2020 12:21:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L0BfSbfd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgCVMUy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 22 Mar 2020 08:20:54 -0400
Received: from mail-io1-f42.google.com ([209.85.166.42]:35933 "EHLO
        mail-io1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgCVMUy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 22 Mar 2020 08:20:54 -0400
Received: by mail-io1-f42.google.com with SMTP id d15so11239398iog.3
        for <linux-wireless@vger.kernel.org>; Sun, 22 Mar 2020 05:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=7QNRpvHh2+Z2ktcDQ/2OATAhgr9xyuJzJVtsOXM/sMk=;
        b=L0BfSbfdbhw3xubU6axhSgTCWX/o/GNdzj7wqzHVNxBXOuogQbUyzkWCGwAwBi19RA
         JJleiWBSgShyvgXje6VcQChP4EtmoHcdQpM1kP7Vc2lp2kNgmvUq5qhnpUwZFPVoUdaG
         mXKRG2ygUHrkowa5gqaQPLWMDQ5LnSamDtTys0OgI+aZTiYePGFhNjygqiZMFG/cOoxn
         CN+anoWx3LXRwSeGQh+5gO1risyMQzjrQqkPGrh3wzB5gtUOYPTLjhT9bXZIUy0h/7CO
         rqH9pbeTO3gtw9GC8/v4z10OihiS+ASGBIFOLzNkErxWgP69L22bWQvc2j7FG7ZM5ECv
         rGUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=7QNRpvHh2+Z2ktcDQ/2OATAhgr9xyuJzJVtsOXM/sMk=;
        b=mr94DaxsDyU4zaMXl+50v89stPoP2onEf5GaKsPbCpnzAo8XSw+oJMEOxrPm26227/
         MaMF95v8zOHc5u4NJjSXZ4O2g6LukbOrh4uYzoWFIjZQtR0hVG3G8W7ipQU+n05fl+CR
         6qhAe15/XOtUY0KldkMWDuIcJF3FtC0CQNxVwtt+9bnqLgocO8VSJVXKw3KTWDbLpMPy
         gJaMOXk0NmFbWcw1p6TnVj9hTbmJODhcMXTc1bcljumP6Kzx/VH1ruHWd88btbyNPydh
         KU+MnPEKEny19loJvZfRN7tXZ0qC3E79pMoE3MfcVyqckLkffYoY6uXmMxMjyi4ZGs6x
         RI7Q==
X-Gm-Message-State: ANhLgQ3MZxvoJM6dyRW2mRPzXMzMlvj3LWlaZGn9bdjWzc0HpnU3m3St
        HRKPS7VC681lIQskVHB6vlMnFCY9W91Eovso9C0=
X-Google-Smtp-Source: ADFU+vvRXQAaSaqhickCFmQwGkN0Wcs3UevR4btQWJ4ug4xGaeMvVE+2pvumR6MHBK2bdHI5IK1AJ8hwxH9VEZi7+yM=
X-Received: by 2002:a02:cbc3:: with SMTP id u3mr15344571jaq.114.1584879651760;
 Sun, 22 Mar 2020 05:20:51 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac0:8742:0:0:0:0:0 with HTTP; Sun, 22 Mar 2020 05:20:51
 -0700 (PDT)
From:   youling 257 <youling257@gmail.com>
Date:   Sun, 22 Mar 2020 20:20:51 +0800
Message-ID: <CAOzgRdZ9jzhg5a5T89WVWFan=KOfxuff7qxnX9mXXv5cc-nznQ@mail.gmail.com>
Subject: brcmfmac43430a0-sdio wifi speed only 30Mbps under 40Mhz
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

my Cherry trail ezpad 6 tablet has a brcmfmac43430a0-sdio wifi, wifi
speed only 30Mbps under 40mhz.
my Bay trail tablet has a rtl8723bs sdio wifi, wifi speed can 70Mbps
under 40mhz.

so i can guess the brcmfmac43430a0-sdio wifi not support 40mhz?
