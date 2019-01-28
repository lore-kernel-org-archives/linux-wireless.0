Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26C38C282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 20:15:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6AA02171F
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 20:15:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tCoQzfUN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727274AbfA1UPC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 15:15:02 -0500
Received: from mail-ot1-f46.google.com ([209.85.210.46]:41021 "EHLO
        mail-ot1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727165AbfA1UPB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 15:15:01 -0500
Received: by mail-ot1-f46.google.com with SMTP id u16so15828481otk.8
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jan 2019 12:15:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=nYXEcDzMBzLbs3WcvawOOsJRAUau9/4MmBfADwiVzy8=;
        b=tCoQzfUNoT4SmDJ594nQS+VIUDOCSWMDLx3p+V7vbenWendH3HRsROYASxsOuSwhVu
         mZZXtX7TBkuhNkI1SOuKmKm0trky/AE6KMyC8xtXr376oq6ZDubPiGgUSzZpXykARuBm
         LmlFJY5PLae92yzXZjH60v/TvwAU6Bu8y1MBTVWkVXKiAh/VMMHfJsQ8r7FdO3SJuhVl
         7GKaZDBbpoau6oVDwyCdJaXiQnwhcM77HAEp+eMwLoPyxqtGwZE76HsLdjXwPtRXDR2G
         w4774fZHiyFm/gdmj+Mbj8EPV55AlyXsnugOlbHvitplls7hehFJPzMQyNSv5FYkNb6g
         DjjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=nYXEcDzMBzLbs3WcvawOOsJRAUau9/4MmBfADwiVzy8=;
        b=aEcfdiTHzI6Wk9xGABFCu5pA2Tu6ETzT2aGjHG8UKMgYMJPdznsnPIag/ntWUptvRv
         YV7Gx7tpiRQAkV+WhhUMQ4OddGQiTGWhoIHicWsJq6tddWs8yXbhe2kKSppC1NSm/pP2
         7dfRWssJ7o26JyL/soWta9QYLLu5jchOmDu36wy8pTCSPf5z4tfYLRQJRfwqKyaWEz8d
         YT8QTSz8VioPGAB2kvDUQaPaFlgqoGfuCuPARNnPgcE91V3WN+C4wY6xZ+rP67W3tutp
         Kdq2PPYIni0UxzjD8KevRhlk7J0QY0fyVxcRhbsgJFFZwqTDhVuOOtki013om1rLcFpl
         4jEg==
X-Gm-Message-State: AJcUukdT4vkmizw3BM/jxxQ/yoeuJ1fbfv7L6d3Yxc5Bwwdr1qvC5gqW
        S987oTAlb1xIaKw+rH8js65hc5a8uydFCEM61Ldt6SYtWP8=
X-Google-Smtp-Source: ALg8bN4D9pbNQCmuKIn/o+SJ8S4bzjyHKz1Pdr7HJE0HggcXjvXfiAR9DsAmjrIw9Iajij9NtKzXrowwnB8EbToBeP4=
X-Received: by 2002:a9d:751a:: with SMTP id r26mr17689760otk.273.1548706500557;
 Mon, 28 Jan 2019 12:15:00 -0800 (PST)
MIME-Version: 1.0
From:   Rosen Penev <rosenp@gmail.com>
Date:   Mon, 28 Jan 2019 12:14:49 -0800
Message-ID: <CAKxU2N9choD2mdQd+Qwf5047VNWdwKOPB_YRXvw4i6BtLn6vxQ@mail.gmail.com>
Subject: [mt76x2e] minipcie card is not working
To:     linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

I have a full height production sample mt7612e card that does not work
in either Access Point or Client mode. Monitor mode does not work
either (no packets received/transmitted).

dmesg shows everything to be fine:

[    5.801993] mt76x2e 0000:2b:00.0: enabling device (0000 -> 0002)
[    5.802122] mt76x2e 0000:2b:00.0: ASIC revision: 76120044
[    6.466527] mt76x2e 0000:2b:00.0: ROM patch build: 20141115060606a
[    6.468999] mt76x2e 0000:2b:00.0: Firmware Version: 0.0.00
[    6.469000] mt76x2e 0000:2b:00.0: Build: 1
[    6.469001] mt76x2e 0000:2b:00.0: Build Time: 201507311614____
[    6.496042] mt76x2e 0000:2b:00.0: Firmware running!
[    6.497999] mt76x2e 0000:2b:00.0 wlp43s0: renamed from wlan0

This is on 5.0-rc3.

Tested with a desktop running Ubuntu 18.04 (custom kernel) and an
mvebu device (Turris Omnia) running OpenWrt on kernel 4.14.
