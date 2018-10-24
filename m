Return-Path: <SRS0=AjP+=NE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BACF7C004D3
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 12:09:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 709F920824
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 12:09:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WlMzVvby"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 709F920824
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727354AbeJXUhq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Oct 2018 16:37:46 -0400
Received: from mail-ot1-f50.google.com ([209.85.210.50]:46920 "EHLO
        mail-ot1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726360AbeJXUhq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Oct 2018 16:37:46 -0400
Received: by mail-ot1-f50.google.com with SMTP id u26so3597494otk.13
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2018 05:09:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=MBXgBanvCS1nrKQtjSWlr2YzhpzItb/srf4mT2j5WY4=;
        b=WlMzVvbybrDduNpXBgs8WE/9m69Lk1DLTsiT3oR/YlUS7CIl3eI1E6VwY6pAw+DnsO
         BgRGhaBtRgJFGI499bwHgkKw77SrNA5lr0rIIau6uPruO6L2zfrJ3f8mTxeY2TABXvLo
         VqrolMEOoQiusnGwo0o9x1NGQHQaLm+hrflrPYoxW+DM7KhJ6oaHzuU6cIVJYWAnHZ0u
         VOjk430KZEAb7rCaoqjY7MBxjNBPaZc7ovfWQWWzk3H0O+JrPSNtteePbrOWDc8eOGbW
         XZFSTQL4fH6GgYMA9EWsXI8Me/885V7i1dB+ACQB5mfIqvzHonzeYipuinAlg204Yb6X
         1DDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=MBXgBanvCS1nrKQtjSWlr2YzhpzItb/srf4mT2j5WY4=;
        b=s5u3BjnCfyn5Dra688HH6gcS3SN5fhyjkogt90cID3JAdSBowz+xfJYb+Ns3koV4B8
         4WUuJ319wEazOsJbFwDCyNKT75MGgvgeOdPAoabLAkiNJ+vmcaeK5GTUdIf7C4xpSnQg
         aoPmnUvKFToorOhxuIu0Ufc9uTHhiYBKmgbOWYO0mJ16VMMFkQQL7cYzKlQ/wZAKAGFb
         bGfoSbHkucRqLvDaVb1m+BlNAA9KSBg/nNZaChKYLlCrJyu9ey4Dm2H+mNM2/ph03QKQ
         S0Hotguxhykr/etxC+1DTItZecY0Ot66yYwBMRHSaXtofKIy4bPMlT0fGHkDsEmbtH0A
         TnPQ==
X-Gm-Message-State: AGRZ1gKb/xSwcS9B0iWILQ0wgWPbjYyHMa8iBYGPmzRBTH56CYmdlIIv
        N9OG8kCkigPiT7rSmocgzksZAQq8pG70cwh0TyM=
X-Google-Smtp-Source: AJdET5fRazEc50MA7uzz7jOY3jwJNmAj6Q0hP2QWVWG+j5nNbIFs7+hkzSozCeFlMKq/n8EJ8aZ93ZRD6k021E8zAEI=
X-Received: by 2002:a9d:ec:: with SMTP id 41mr1415953otk.322.1540382993793;
 Wed, 24 Oct 2018 05:09:53 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:2eab:0:0:0:0:0 with HTTP; Wed, 24 Oct 2018 05:09:53
 -0700 (PDT)
In-Reply-To: <ecb743be-ec4f-0f80-c598-c71826492b30@gmail.com>
References: <ecb743be-ec4f-0f80-c598-c71826492b30@gmail.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Wed, 24 Oct 2018 14:09:53 +0200
Message-ID: <CAKR_QV+xitANRgaH=_wEkRgizFU7fsqyY8JY7f+AzQTdgjQ1cg@mail.gmail.com>
Subject: Re: ath9k driver may be broken on ARM64 ?
To:     Ellie Revves <ellierevves@gmail.com>
Cc:     linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi

There was similar issue reported in forum recently:
https://forum.openwrt.org/t/wireless-card-atheros-ar9565/23608

Could you enable ath9k debug and post output?
