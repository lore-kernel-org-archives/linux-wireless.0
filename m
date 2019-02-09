Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13AC8C282C4
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 11:11:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BCBCE218D2
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 11:11:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PB+I/E3k"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfBILLE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 06:11:04 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:35653 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfBILLE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 06:11:04 -0500
Received: by mail-ot1-f65.google.com with SMTP id z19so6207274otm.2
        for <linux-wireless@vger.kernel.org>; Sat, 09 Feb 2019 03:11:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=WoPKj3h+zXaw0bKXqCIC4f3FoR8HORFVIlqOaBAUkvg=;
        b=PB+I/E3kar6GKkZfsCiTZT8M14M7NMzmHVCNe72YKseUZr39RE/3WEM1xPBS5S9fD0
         xa51jjMxzQ4giFF7BVg7x2jtcytF/eoNpktYuVGyKUCBZFWVq1dc/9t7y7nj+3afssay
         yz7Zo1spk7hXF3FXDKGyOjo1k5M2IyGbJCRJlMhrdG6X/qXE1hI5nvgm4SN/v7/ogzJH
         6e/B5Lz2Z/mTfZJB/F4CqNhXkQemBEb3G/1cw02AVgqtq9YH5MoeRvqPyOdHBGRAZbJN
         0jcNqwIBBtC1AJYFP/J/5m7jiA5cwotofqLGOh4V5cCidG47Q3OzA4bJBbwvsFwHXO/k
         8I+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=WoPKj3h+zXaw0bKXqCIC4f3FoR8HORFVIlqOaBAUkvg=;
        b=ejmYUhqHdg3jsMyQHAS2GlTOy0+yV84ZQZisFNt4Pn4OOdx4YcM2jlwrJw2y/elRc+
         jLI0pEpDUFX9RZbpkaAOEEoxXmcjH2yTM3pulWsesjmY8QnhFa+EXdH6zSGbpfN9cR1v
         X6CSDDWkMgeYcOryQalvGLPZduHDLTjmbmiAq6OXvVxZMmjPC7FYiNs1vL9E00X6+WaV
         7a2YL1gktwVFjlRDMUF8j93xfWekAGzM0dZxgFkfFRCLfm2J3sZldc5jFZ6DyGsxqKFa
         HXQ9i0rzHh+cT/gj69t12tsZHUTo2aYV0251t/5sDk73sez4RRHspuqyN1zhvUTsld+n
         mRmA==
X-Gm-Message-State: AHQUAuYVbDDODI/lrT/NhTlyaGheqMmmhfUYU6Zj4zmDUVDY6EyotsOT
        wH4aarxK9yv0X0azsinIBdyP93SPwqJs2slv9Rk=
X-Google-Smtp-Source: AHgI3IZSZIKhk9sAxiq8C3HotnsZy/h5zPQSeZdz9sMEJu7O+l4bOpPvNbSb2vWZUVzg2pctTI44OE1sjnz3XyIx4bw=
X-Received: by 2002:a9d:6a50:: with SMTP id h16mr3984061otn.95.1549710664104;
 Sat, 09 Feb 2019 03:11:04 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a9d:4b14:0:0:0:0:0 with HTTP; Sat, 9 Feb 2019 03:11:03 -0800 (PST)
In-Reply-To: <20190209110259.GA14900@redhat.com>
References: <1545318971-28351-1-git-send-email-sgruszka@redhat.com>
 <1545318971-28351-3-git-send-email-sgruszka@redhat.com> <CAKR_QVJeteexpQX=pJm17WrrarmihYw56hKuTbsNagbcA6U96A@mail.gmail.com>
 <20181221095938.GA29536@redhat.com> <CAKR_QVKQMcGGpY_3ur9kFjuYpaKgca=YfUJxjSjLEfP1HELuJw@mail.gmail.com>
 <20181227102535.GA25885@redhat.com> <CAKR_QVK_2j6a9YiwUEKuWF+ss0-pr808Sr=AUrX4a6L3Zw=F0w@mail.gmail.com>
 <20190102081934.GA5300@redhat.com> <20190209110259.GA14900@redhat.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Sat, 9 Feb 2019 12:11:03 +0100
Message-ID: <CAKR_QVK7N_NGFR+_2+6fP5iZ0j3dDbvdxJOQt3Yjwn7DMBUfYA@mail.gmail.com>
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

Can you reproduce interface freeze with this patch if you enable debug
options to print all dbg messages?
