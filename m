Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E144AC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 02:12:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A81F620685
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 02:12:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ub2ObQAk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbfCSCM6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Mar 2019 22:12:58 -0400
Received: from mail-ot1-f45.google.com ([209.85.210.45]:46038 "EHLO
        mail-ot1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbfCSCM6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Mar 2019 22:12:58 -0400
Received: by mail-ot1-f45.google.com with SMTP id i12so16269385otp.12
        for <linux-wireless@vger.kernel.org>; Mon, 18 Mar 2019 19:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=ECHqIDgyiZuOO/nIbEsxrz+23N5YuzGAFg1rpoJL4qo=;
        b=ub2ObQAkVaPOqkHmT5KJfuxN499J1mB7z0LOWcpzAcLYxTxovQMK7GMPfeQ8Pj5x5i
         joisZ4QPCf322ts+ZFHy32Emr2uXUwKnAuhzbtP927u2rKBWgykS6hDeQKdb13JMgimG
         gfe6U/yRo9jaxsYjLjoMN0G0bo7lbzpGlDboLMsEPXtEeV6gY7GT+64q/gHe65qSkGSU
         qdeZfAXVMjVE8WDzFcG74NFO5aq5DBO/gqA7qIMvPYnwPy4fyznKtWTOs/eG4BgmA6B2
         2RJrIgpA5JvKexoyH/miXOiMa9ynJEfelo9n2vUFDXvx007Rx64RdGbGgEruJnPn9Jdb
         o3IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=ECHqIDgyiZuOO/nIbEsxrz+23N5YuzGAFg1rpoJL4qo=;
        b=HF7qIx9ojjs42IKXaCPralJZ5LXiH1XLvp/2V84viI8/cplAhByLO7q2pUb9w/kMNE
         YVz2DGyOYbMHg+ZEw1tY+HDR4CCayPI9NLSMmLe0rtIwTFr+2GQS+/ibQXUnEtLdPQI5
         I6Xjxo71z5F5WjQllxUyW6VXnu24U8MxYmLxiAt3A6g3dYx7ESDsKDnq0deaZVXLvCot
         10Gy36QkuwvhVFu4b8YUVJfz2JYRA9c9/ydRjmInOH4ZleAVZq3C7CDmn561wFDcjdM3
         CrUaGpf1dcZY+uPsJ8FDJpwpmz2kdj76tqQ0kzNYgXh3dGrdOc9t4b/AGYYzkxzokOsz
         E5ZA==
X-Gm-Message-State: APjAAAW6vCcnqVML527yrnmVsP1TuElJhws0tfUQGsqPOREwrDw+hJwM
        U3Z2UsG77bjCexo2YqUpTMrxUoRUwUdm9hf/MCcblEWA
X-Google-Smtp-Source: APXvYqxJnE+1+fadUKuBvJ5JI40x8+5QYJEn2hntC0UNzreH6UTBCOCu5MH/zjudmU0Od+wc7itj07liQ1sJVrtONpU=
X-Received: by 2002:a9d:7d82:: with SMTP id j2mr25428otn.270.1552961577720;
 Mon, 18 Mar 2019 19:12:57 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:628c:0:0:0:0:0 with HTTP; Mon, 18 Mar 2019 19:12:57
 -0700 (PDT)
In-Reply-To: <1552384303-29529-5-git-send-email-sgruszka@redhat.com>
References: <1552384303-29529-1-git-send-email-sgruszka@redhat.com> <1552384303-29529-5-git-send-email-sgruszka@redhat.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Tue, 19 Mar 2019 03:12:57 +0100
Message-ID: <CAKR_QVLxxye1-QCz4nOzTJALRMoBp_Mvy9V3ZaUoAbVPCThaTQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] rt2x00: do not print error when queue is full
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 12/03/2019, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> This make MT7620 OpenWRT routers more stable, what was reported
> by various users.

Confirmed.
