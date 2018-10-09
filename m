Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD99AC64EB0
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 22:14:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89081214DA
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 22:14:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="t/uuyYk0"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 89081214DA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbeJJFdc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 01:33:32 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:38621 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbeJJFdc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 01:33:32 -0400
Received: by mail-ot1-f67.google.com with SMTP id l1so3355101otj.5
        for <linux-wireless@vger.kernel.org>; Tue, 09 Oct 2018 15:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=2ZC8rZGJ+Uzn33Gl6wZNhp3Bss7rmYRY46cStI/RfUo=;
        b=t/uuyYk0+BqsJHb9qP2HoUl+x/XCSu+x457JCZnmk7wCciH34xPiX0qEb7RtNze4ZP
         pRgdKR5sbUVTLG0HjRMEefGQqLYfFKgO9w262tpXUM3dg5q5iy2hZ5GATDuHhzRfbx1O
         0wIaF5/bUJchBFiaqCiqyBtUwsGkzBTIwMxXswX45iO6869BzWBhTOtBmT9hBCcBMHay
         RTAX4Lo4FWkHpDuxGDKNbCeDfMg+hX16L81owg7tv8kcxhravkq0H3o0+hJqTVOASCqj
         +NQ6JY6WAxHoUN64FyeRoeG/UoKc6TShALva33zKY8XY1TmEpWy/qsHfwdA1yCSqMEB9
         Z4nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=2ZC8rZGJ+Uzn33Gl6wZNhp3Bss7rmYRY46cStI/RfUo=;
        b=gFcBC81tut8y1gpjRRiF63bOMTn9MTWX17Z3EHf2OwgTJp14Rr4erapnhTptT1XkqH
         Wzt/8BOeDCHAsZHBc1TpnyS5nQc01c2BK5NsKVWPl8FiJzWDKNrg1bYGbW3Y4w8l8jLj
         Fjz0M+M7+fgH8zhJReD2cz25MMWxu0XNDSQuzdq7mFcCYdkhizB1o/pfjxcgjFjLXTw5
         RCpLpAJ/rBwQpKmfK/MRZi9ZA2XwHVCpXu0xwaIYns1+WQQd06SRDK0jW12g4vTQ4Hcd
         Ya8k/nC09sijypXJ3h3ea2Y/ygE135Gd55XK4WkhUn2mIkqpc8S9YQ+eZdhi6LZxUyba
         8FIw==
X-Gm-Message-State: ABuFfoh3WSbeiQ/jt3HeD0Ha5BZ3fTw4+dphS0KQzgp+6HaRPhD68E+K
        HbCcNlGFH58WmFNCUB6T+lCE6rTv2KxMTNq81DU=
X-Google-Smtp-Source: ACcGV633OTAv6W7/up85GztrbK6AZlSzwqLVehntiValEmEz7b/T96Ie9gxQdY0YFMefz3FnkQOU4NEUavNZ8KifNeQ=
X-Received: by 2002:a9d:11b2:: with SMTP id v47mr16937608otf.281.1539123268620;
 Tue, 09 Oct 2018 15:14:28 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:2eab:0:0:0:0:0 with HTTP; Tue, 9 Oct 2018 15:14:28 -0700 (PDT)
In-Reply-To: <20181009110017.GB9259@redhat.com>
References: <1537201975-3032-1-git-send-email-pozega.tomislav@gmail.com> <20181009110017.GB9259@redhat.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Wed, 10 Oct 2018 00:14:28 +0200
Message-ID: <CAKR_QVK_UF6OMg8RAh1jaMoO+xt3OKtM6Q++zAO+FHuyRKwzFg@mail.gmail.com>
Subject: Re: [PATCH 1/5] rt2x00: set registers based on current band
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 09/10/2018, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> Patches 3-5 looks ok to me, I'll rebase and resend them.
>
> Thanks
> Stanislaw
>

and what about patches 1-2 ? did you find any regression?
