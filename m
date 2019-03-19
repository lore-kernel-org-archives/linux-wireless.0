Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4692C4360F
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 05:35:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74FF42133D
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 05:35:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726644AbfCSFfP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 01:35:15 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34055 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbfCSFfO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 01:35:14 -0400
Received: from mail-pf1-f197.google.com ([209.85.210.197])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1h67P6-0001Ko-K4
        for linux-wireless@vger.kernel.org; Tue, 19 Mar 2019 05:35:12 +0000
Received: by mail-pf1-f197.google.com with SMTP id n63so8093860pfb.14
        for <linux-wireless@vger.kernel.org>; Mon, 18 Mar 2019 22:35:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=01RdgrXzNpnQt4YP8FNkbK+PJ4yhiMVXPg2bVVNmVdY=;
        b=kYZn1LBo5o9PcsjzkMalLITFoM/JPSr4W6e+KKeSt0AHPbjgoXKQeOTd1QLqplfOZu
         DgOkDvVt0yAMAKLN90jV+dnIZm3eiQ31i+EVj05YE/nQVxLaSc2NSFDmNj13gWtRdVdv
         DWR7IlI6ChIrZ/Nr1Nm4vIt6LPQqDC5EzU7tjZnUiJEvHHXhctCZOWE7IN/txf2Cy1Yi
         t9x6BLfaCOG9V8DD+psMd6JFr3L8DiiFQtzDEj4SgCLadle8Fj8ZH6KUOdSSjVqcDUTQ
         cgQUh0g20GFdA2A5ZiasMszERnLLWyEEc9w+eFQ9iSubvcjWzvxVN2xTYBNepOBJG5zg
         6mEA==
X-Gm-Message-State: APjAAAWlkLTOlcB5PD8cwkctScNuMhwMODxu3Qrj6ZsaldSycL+6Wv2J
        0YDrHHqaeVBGAnT8F3mcabkAKqOkjl5jNpd1BdcsQv6YPaRfd778ptC4hcRYthPaAkPyGyuBYZ7
        ITGvLl7pVNdVcSwwbPs5V49dLgfs6WZYJtzKEWtMMaBCj
X-Received: by 2002:a62:4117:: with SMTP id o23mr22905301pfa.248.1552973711016;
        Mon, 18 Mar 2019 22:35:11 -0700 (PDT)
X-Google-Smtp-Source: APXvYqz/Jc5zZyHKva6SDGuRytaGPNH3EG+FP2kNt042Tr+R9FJYA9kwbpn+jYtbHOF0A2Umw2owZQ==
X-Received: by 2002:a62:4117:: with SMTP id o23mr22905285pfa.248.1552973710702;
        Mon, 18 Mar 2019 22:35:10 -0700 (PDT)
Received: from 2001-b011-380f-14b9-4986-1e4d-ccc9-b05a.dynamic-ip6.hinet.net (2001-b011-380f-14b9-4986-1e4d-ccc9-b05a.dynamic-ip6.hinet.net. [2001:b011:380f:14b9:4986:1e4d:ccc9:b05a])
        by smtp.gmail.com with ESMTPSA id a66sm24924660pfj.153.2019.03.18.22.35.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 18 Mar 2019 22:35:09 -0700 (PDT)
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
Content-Type: text/plain;
        charset=utf-8;
        delsp=yes;
        format=flowed
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Subject: Ath10k on XPS 9380 regularly disconnects
Message-Id: <042C2903-585B-47BA-8657-8819D225EEA8@canonical.com>
Date:   Tue, 19 Mar 2019 13:35:07 +0800
Cc:     Anthony Wong <anthony.wong@canonical.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
X-Mailer: Apple Mail (2.3445.102.3)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Kalle,

There’s an issue that ath10k disconnects at regular basis [1], on Linux  
kernel 4.18.

Unfortunately I can’t reproduce the issue on XPS 9380 at my hand.

Is there already a fix in upstream kernel?

[1] https://bugs.launchpad.net/bugs/1818881

Kai-Heng
