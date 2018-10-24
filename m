Return-Path: <SRS0=AjP+=NE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97F53C004D3
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 14:26:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3C7EE207DD
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 14:26:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OeewyqC9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3C7EE207DD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbeJXWzR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Oct 2018 18:55:17 -0400
Received: from mail-oi1-f179.google.com ([209.85.167.179]:36405 "EHLO
        mail-oi1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbeJXWzR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Oct 2018 18:55:17 -0400
Received: by mail-oi1-f179.google.com with SMTP id p125-v6so4235400oic.3
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2018 07:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=rHJ9uZ6xGCIBdHBqQBNlInGkVxMfyT7ldkuhA3m5Dh8=;
        b=OeewyqC9ud5l4TJRqAhGV1Ar3RYvLlVFDnkAUDIbqFRnV/xwUxszng/g+mE/9+6mKU
         YLJT1gHr8NxMKHoiKoB5BF8j+XfL1eZwXTD7ohTATBYB4hg0m2xg90+lC7C7XWkxE1Is
         F2Fvi5lYGXPYElt1TXOMrEplgP7NIePTJNbredET3qIYuh1dVuBBD15xvsXdynfVCyX1
         eb3L2tpWIgUbmdIfII2zCPbPKl+zB7fs5Z77Z2GyuFi/jWzj7OJG03ekhbjvH8zWgyWs
         cZbjtP3J6txuA21hwRq7fLNd57hC2SVks6gRpiN8CZGBLp7/iEflm91x1o24kdkmDS82
         7hQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=rHJ9uZ6xGCIBdHBqQBNlInGkVxMfyT7ldkuhA3m5Dh8=;
        b=rqdWV0Ln0+y41TQRgLPgaEoKuY0c9dljGcmdyG5ajBJXZJYfWB1xPpvGFG8Dtsm2f7
         y6QnPVTQSrmL7UHWGy+DhcUCJI7omfa6NidjqqnOj1V4CAy9uOLks9Lf9pcgZFk8u8rZ
         CnxTWbUSuCn8LxVBifeAaGhEktTsjl8iaZtxgVpHD1Saz8itgADHnQIfYrYt0nAodyCV
         3xIURdA7/+KUyMOO5cCXLggQhKS6bmF/69RgVylLqLOsWsm+QsO1Hk+FgPXaR5IzsD2K
         hWgZaQKkOgC4QxrwVkgXQkBTMbr5I5qC3VEw1kpg5Fc2m1ogKKGKPeY3KiweLgfrpseX
         kLmw==
X-Gm-Message-State: AGRZ1gJGzD5vMaGjnZZMdKMEYVN3piPjTJFyN6xMexlC4qIiGUCwk2MM
        OUBlnN+/iLKr2CcceOzJC7e0B6qcnV9htSOxVx43rg==
X-Google-Smtp-Source: AJdET5fshsPaBqd9nyl79LbY80CfP/ZVnt3d9Ll8h2t9yh1a2pNhJBGoESe+5J0hPai1vztnpgR6lwZJNe/1aD58EKI=
X-Received: by 2002:aca:4806:: with SMTP id v6-v6mr1556914oia.163.1540391217156;
 Wed, 24 Oct 2018 07:26:57 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:2eab:0:0:0:0:0 with HTTP; Wed, 24 Oct 2018 07:26:56
 -0700 (PDT)
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Wed, 24 Oct 2018 16:26:56 +0200
Message-ID: <CAKR_QVJC8OTUEmvQrA4cDC=COQ2ZAk7=rEHno0B8rw8uCpyPVQ@mail.gmail.com>
Subject: dynack slows down network when enabled on AR9462 card
To:     linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi

Running several tests with dynack enabled on AR9462 card I can see
throughput drop in 10-30Mbps range.

The card is running on 4.9.135 kernel (same issue was present on
3.2.11 with backports4.4.2) while QCA9531 router is running 4.9.111.

Distance between the two is less than 1m. Results:

QCA9531 auto distance + AR9462 default -> 10Mbps higher RX bandwidth
on client (AR9462), RX bandwidth remain unchanged

QCA9531 default + AR9462 auto distance -> at least 10Mbps lower RX
bandwidth and up to 30Mbps (depending on window size) lower TX
bandwidth on client

QCA9531 auto distance + AR9462 auto distance -> at least 10Mbps lower
RX bandwidth and up to 30Mbps (depending on window size) lower TX
bandwidth on client

Given that the bandwidth improves when executed iw phy0 set distance
auto on router and degrades in any case same command is executed on
client PC running AR9462 seems like there are some timers
misconfiguration in ath9k regarding this card. Any thoughts on this?

Regards, Tom
