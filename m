Return-Path: <SRS0=AjP+=NE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06FEBC004D3
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 14:31:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4B2B207DD
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 14:31:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A4B2B207DD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=canonical.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbeJXW7j (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Oct 2018 18:59:39 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42014 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbeJXW7i (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Oct 2018 18:59:38 -0400
Received: from mail-pf1-f198.google.com ([209.85.210.198])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1gFKBp-0004uL-2l
        for linux-wireless@vger.kernel.org; Wed, 24 Oct 2018 14:31:17 +0000
Received: by mail-pf1-f198.google.com with SMTP id t28-v6so3665106pfk.21
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2018 07:31:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=7jbk9UNpYAd7Qjtsoh58/kMRtGSwwo31ehTndVr8Gmk=;
        b=Rnk4pDK48fWzQt/x9INvV176vdUafaOHZPT0yATcKwU0Axwc5o14EEzUO4DBsHYw8I
         4ZiNLbEzALQTrGCYGIK1iPzjOY8G753v3+ve/aFSz3hRk5li5zdNqf0IS13bVRTpODs5
         fZjICpQFeDaBlEG83l0crX/AMbVJVqV4SPNbPUh+IQLBD9uMaoRC7iOP3RWvtEIt9aXy
         x40O9hL7IedU2Hd97gxROs//P+uZq/tyozeQDyTbVleUezA15ltuR3frHfHooWfAz4VI
         MCHxOdKOz6VAT449XWRVnkTL7bdb8FhpU8+bNC8uw+0tCOR4DjZe3ZDD7eQ3QG+HDZUK
         INxQ==
X-Gm-Message-State: AGRZ1gI0ppRVlalfPTG/HIe3PJ9/7tW0eIDPuNqVJiXLnPgmhkDGsS0a
        jBIEjE+RBKL0ivo4x7ki/Qzg7Qrg5HExZmtxnyS0DRrRDB82tp1LBdijyynK86mgsEbScumBb+u
        SopzSR9Xbh1DtvwnrwxX7q5qA77uMCOccros/bmPkQ5iO
X-Received: by 2002:a63:db48:: with SMTP id x8mr2679452pgi.365.1540391474600;
        Wed, 24 Oct 2018 07:31:14 -0700 (PDT)
X-Google-Smtp-Source: AJdET5dZGCKK4uWl1UrrBodkmoOONxRBShgrWShnkShPF2sSMTA55++gXoVEJe6EnrEciejwesf9NQ==
X-Received: by 2002:a63:db48:: with SMTP id x8mr2679420pgi.365.1540391474060;
        Wed, 24 Oct 2018 07:31:14 -0700 (PDT)
Received: from localhost (h59.232.132.40.static.ip.windstream.net. [40.132.232.59])
        by smtp.gmail.com with ESMTPSA id h6-v6sm6106780pfc.6.2018.10.24.07.31.13
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 24 Oct 2018 07:31:13 -0700 (PDT)
Date:   Wed, 24 Oct 2018 08:31:12 -0600
From:   Seth Forshee <seth.forshee@canonical.com>
To:     wireless-regdb@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [ANN] wireless-regdb: master-2018-10-24
Message-ID: <20181024143112.GD8750@ubuntu-xps13>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

A new release of wireless-regdb (master-2018-10-24) is available at:

https://www.kernel.org/pub/software/network/wireless-regdb/wireless-regdb-2018.10.24.tar.gz

The short log of changes since the 2018-09-07 release is below.

Thanks,
Seth

---

Hauke Mehrtens (1):
      wireless-regdb: remove dependency to python attr

Seth Forshee (1):
      wireless-regdb: update regulatory database based on preceding changes

Sven Eckelmann (2):
      wireless-regdb: Sync FR with ETSI EN 301 893 V2.1.1 (2017-05)
      wireless-regdb: Sync DE with ETSI EN 301 893 V2.1.1 (2017-05)
