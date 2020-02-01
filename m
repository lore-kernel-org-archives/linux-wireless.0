Return-Path: <SRS0=cHPN=3V=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1C57C35246
	for <linux-wireless@archiver.kernel.org>; Sat,  1 Feb 2020 12:58:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C76A0206E3
	for <linux-wireless@archiver.kernel.org>; Sat,  1 Feb 2020 12:58:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q5qRgiBq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgBAM6n (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 1 Feb 2020 07:58:43 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55337 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726297AbgBAM6m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 1 Feb 2020 07:58:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580561921;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o0Icocazkr7fGvThFR2+DwDJx6Tjm7Bl4s6ULVOoWQ8=;
        b=Q5qRgiBqeiFdeSQKLlRihv6J9tXcVPER2Y9aNY64e/L45kFWP4hHPLz96rmhvrjOLlbFV0
        9ClV2Pb30aXXVLXZRkEWk012WoE142ddq0RV1BeE9m8c5WSyKihAJZF5tIKj7SR2TjS42H
        AqnpEtGQkgea4hZIPFAONF5lj4MbGf8=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-rj2OCMGtP4OYkmmbRCr83g-1; Sat, 01 Feb 2020 07:58:39 -0500
X-MC-Unique: rj2OCMGtP4OYkmmbRCr83g-1
Received: by mail-lj1-f199.google.com with SMTP id d14so2447209ljg.17
        for <linux-wireless@vger.kernel.org>; Sat, 01 Feb 2020 04:58:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=o0Icocazkr7fGvThFR2+DwDJx6Tjm7Bl4s6ULVOoWQ8=;
        b=m04X0ynCWtem18sLTieSTIPSFISWMwEa53GVIFJa0IeFSzTVu7kojT3H+BSZwl2T9A
         mS4fvsYhIrFjElgxHnhXLIf619zuJ/+BO0wd44koLkK/uhaJ2M9GDNSAZHMatQlsacTR
         mxSNwh7IgsboAiA6F7VdI5vJbmoNVMMUhAeX23Rw6E4e5uDswaIae2GWkCqW+eqjrhmJ
         PxCvUs8gFDY7C7uAbrs0g2rQgcCSSdf3Lc7ZVcecr7sGl0XFVfn9ePHUGg4TD3gqaoLz
         qi0JrJphTzwe6WTPiZ4DkyT4TQBUGnQbLX6HDMCr1fCcyQ3y0CpgMBJYSbeRwKdMfeEb
         38wQ==
X-Gm-Message-State: APjAAAXgd1j5kr4Kbc6BWqR7oA4eOtKrNM/eYE4ax2x+qXl6BYhT751/
        Re1awqyom478U+aWZt1pDijjDcUYVZOfrKz80nJ4eln+uhUpJw8oeGr2iiHl/UIpaAn5OeFJdjL
        GYSNZ8URxaVFsK4r93l8tFMrqDmc=
X-Received: by 2002:ac2:523c:: with SMTP id i28mr7758558lfl.104.1580561917677;
        Sat, 01 Feb 2020 04:58:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqxr1RpS5ihMCBTE/ENagRS/wac/StuWa9qld+9sNiDq1xYn1UeLJ5ctEvsprVEVJosnSoTMYw==
X-Received: by 2002:ac2:523c:: with SMTP id i28mr7758553lfl.104.1580561917456;
        Sat, 01 Feb 2020 04:58:37 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([85.204.121.218])
        by smtp.gmail.com with ESMTPSA id l16sm5992670lfh.74.2020.02.01.04.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Feb 2020 04:58:36 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B65D7180082; Sat,  1 Feb 2020 13:58:33 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/5] mt76: enable Airtime Queue Limit support
In-Reply-To: <20200127181754.2810-5-nbd@nbd.name>
References: <20200127181754.2810-1-nbd@nbd.name> <20200127181754.2810-5-nbd@nbd.name>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Sat, 01 Feb 2020 13:58:33 +0100
Message-ID: <875zgqfoqu.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> It is supported by all drivers
>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>

Nice!

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

