Return-Path: <SRS0=458R=PC=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F4AAC43387
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Dec 2018 22:43:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DABF821726
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Dec 2018 22:43:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g1W/VOsd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbeLYWnL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Dec 2018 17:43:11 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:41923 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbeLYWnK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Dec 2018 17:43:10 -0500
Received: by mail-oi1-f193.google.com with SMTP id j21so11932702oii.8
        for <linux-wireless@vger.kernel.org>; Tue, 25 Dec 2018 14:43:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=zvhNfiO/2ggjIs++dXFc85hX8FhgBUdzj052uL9LvOw=;
        b=g1W/VOsdvk6AZMfS7BHyh6djIq7JXUvl7Fi1cGdudKhvwO8ooVpJCEvsYAVv8F/mtw
         lg0te+75nW/OnOR/sbDv7JaMUEUXHxmWZx86qLsjnK1zbHhsdN6LX+IDoWfIPvjNbUj7
         +1Y25qv6oLCa6Q+ekfHl/Mr6p5Tl1Mppc8NP3EKReLfkC7yZjwYqCKB3h12bXeps0F5G
         688zMO78U/Mj6yLNqLWEKUw5NP+hZRCS/3dnXjjRpVhFt6mQtlrTB6EWbfHWCHVUtswV
         rttXTFBRdgGU72pxogaRcCrKV5xGMNDB6/sS3ghDzs0tMfXJGb+QIIYU6AlS8cumBL6p
         Y9EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=zvhNfiO/2ggjIs++dXFc85hX8FhgBUdzj052uL9LvOw=;
        b=V4w2UNwBjPuRWoep8mMg7pFQwtZfRGezJdjPWHriuVJdNsbX0ViFek56ve+t0AawKa
         9VUeJIjd21WIgTuGlOZTu646dT3cwwc+y3HgBk/+6SA4AbFLNN3btugS/SaSuv7WWVbB
         MJPd46xgP1aAGlEh2BnFmlrDbp49QCrKDPv9cbGSWGypZ6U8PtLQ8MIc+L7Y9oqOUepZ
         0kuaZE7pn2zP6ixDKrDRwPzMfGYUHuT9y+6rWlPcf2ABGBGu8cYba96l9kZyHWlDwZgb
         3jl0ffErWF06IOIaPRNtdhAKCwKldeT5VBsKbngcDFPrUk8LZvvy87GJ4CB59WLqx/4o
         LLTQ==
X-Gm-Message-State: AA+aEWahFL6j1KM2zG8lr1D1id3cAK7BvHTcGqG9034cEGkQ3cFgsFWP
        f/bQTxfmMzJovvquyokvjtvRV8ZduuGS1mryPco=
X-Google-Smtp-Source: ALg8bN5FEJOgvoLd99p56Ko9Y36w7i4vy/y+8rVA0g+tpDqdERtx9cPy8Ws/Qc9fvqYZz9P99s5sk5WwL8PzbF0ytdM=
X-Received: by 2002:aca:915:: with SMTP id 21mr11455919oij.163.1545777789892;
 Tue, 25 Dec 2018 14:43:09 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a9d:6c19:0:0:0:0:0 with HTTP; Tue, 25 Dec 2018 14:43:09
 -0800 (PST)
In-Reply-To: <CAKR_QVKQMcGGpY_3ur9kFjuYpaKgca=YfUJxjSjLEfP1HELuJw@mail.gmail.com>
References: <1545318971-28351-1-git-send-email-sgruszka@redhat.com>
 <1545318971-28351-3-git-send-email-sgruszka@redhat.com> <CAKR_QVJeteexpQX=pJm17WrrarmihYw56hKuTbsNagbcA6U96A@mail.gmail.com>
 <20181221095938.GA29536@redhat.com> <CAKR_QVKQMcGGpY_3ur9kFjuYpaKgca=YfUJxjSjLEfP1HELuJw@mail.gmail.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Tue, 25 Dec 2018 23:43:09 +0100
Message-ID: <CAKR_QVJhTCPiOSV03z5b=zgzeWkd0BQwbD=VDChQzU2dJJbhhw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] rt2x00: do not print error when queue is full
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org,
        Randy Oostdyk <linux-kernel@oostdyk.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Even with your patches that are currently being tested i had interface
frozen yesterday. 2 android pads, 2 android phones and laptop with
intel card on win10. Wlan frozen about half an hour after bootup, had
to restart interface that revelaed more queue problems:

[  238.715836] IPv6: ADDRCONF(NETDEV_CHANGE): wlan1: link becomes ready
[  238.722681] br-lan: port 2(wlan1) entered blocking state
[  238.728107] br-lan: port 2(wlan1) entered forwarding state
[ 2403.051342] device wlan1 left promiscuous mode
[ 2403.056021] br-lan: port 2(wlan1) entered disabled state
[ 2403.213039] ieee80211 phy1: rt2800_config_channel: Warning - Using
incomplete support for external PA
[ 2403.522622] ieee80211 phy1: rt2x00queue_flush_queue: Warning -
Queue 0 failed to flush
[ 2403.817143] ieee80211 phy1: rt2x00queue_flush_queue: Warning -
Queue 1 failed to flush
[ 2404.058047] ieee80211 phy1: rt2x00queue_flush_queue: Warning -
Queue 2 failed to flush
[ 2404.299509] ieee80211 phy1: rt2x00queue_flush_queue: Warning -
Queue 3 failed to flush
[ 2404.566195] ieee80211 phy1: rt2x00queue_flush_queue: Warning -
Queue 0 failed to flush
[ 2404.806880] ieee80211 phy1: rt2x00queue_flush_queue: Warning -
Queue 1 failed to flush
[ 2405.047624] ieee80211 phy1: rt2x00queue_flush_queue: Warning -
Queue 2 failed to flush
[ 2405.288195] ieee80211 phy1: rt2x00queue_flush_queue: Warning -
Queue 3 failed to flush
