Return-Path: <SRS0=9Upc=RP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65C7AC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 12:11:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FA65206BA
	for <linux-wireless@archiver.kernel.org>; Tue, 12 Mar 2019 12:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552392687;
	bh=5CA8OHRNT6hWyr946w04eCike7C6noOSyo7iFbxoGgg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=NS/UEaFwkEUXDEZ9lUa4h7sumReTwCRo0xavCm+G1iTJsgWW8Eo211bJ0Oq65xIwU
	 K5RMbIiYD4QAcrWATBhtbxiRijvxSI8uk1q3RaO7ya1DGkBjyYe5Ew1zifqs/c2Yvw
	 stIvDfOMKRPTRp2dYJ25uWLe66pVS4mzcyKBDcBY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726304AbfCLML0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 12 Mar 2019 08:11:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:48266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbfCLML0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Mar 2019 08:11:26 -0400
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C50220883
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2019 12:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552392685;
        bh=5CA8OHRNT6hWyr946w04eCike7C6noOSyo7iFbxoGgg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=qJ1rglxCtjOTny976+tI9oiKdUyXgmMkuqgDA5pOKUwgpYQmJFfi33MAuXW/Nl5Sw
         EoDMlbAX4D9GnjvjWtywcM5RjfXmLoeC1CKK0U3GX590Fr1qMAAcMGujI/i6/vd3xv
         7sVfl6uuRjRPpAQy/1kLXPHNTM150LJd/4ren5pM=
Received: by mail-qk1-f174.google.com with SMTP id i5so1201346qkd.13
        for <linux-wireless@vger.kernel.org>; Tue, 12 Mar 2019 05:11:25 -0700 (PDT)
X-Gm-Message-State: APjAAAWugj4Fmn7waERQL3YVAbPJuQNm2bS++lOl3t9n71JjbKum0C35
        +Wngz3SjJkyeCTVu/gtyxXvgSBRwqn+NeI7W7Nk=
X-Google-Smtp-Source: APXvYqx44xlRDZlP0E9FL8ViIzPPZkuR3CvWvKGzuLpv8HyMHW2itvFIuvAVgN+pd2RY94Xvf62WIqfvQjNaE8lxQdg=
X-Received: by 2002:a05:620a:1189:: with SMTP id b9mr13018631qkk.44.1552392684671;
 Tue, 12 Mar 2019 05:11:24 -0700 (PDT)
MIME-Version: 1.0
References: <1551688447-26712-1-git-send-email-yhchuang@realtek.com>
In-Reply-To: <1551688447-26712-1-git-send-email-yhchuang@realtek.com>
From:   Josh Boyer <jwboyer@kernel.org>
Date:   Tue, 12 Mar 2019 08:11:13 -0400
X-Gmail-Original-Message-ID: <CA+5PVA49dbX+__4EG2RSfjMoyA7cvrQGiFuBof3sZ_RUtn68yg@mail.gmail.com>
Message-ID: <CA+5PVA49dbX+__4EG2RSfjMoyA7cvrQGiFuBof3sZ_RUtn68yg@mail.gmail.com>
Subject: Re: [PATCH] rtw88: RTL8822C: update rtw8822c_fw.bin to v5.0
To:     yhchuang@realtek.com
Cc:     Linux Firmware <linux-firmware@kernel.org>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Mar 4, 2019 at 3:39 AM <yhchuang@realtek.com> wrote:
>
> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
>
> Add IQK support.
>
> Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>

Applied and pushed out.

josh
