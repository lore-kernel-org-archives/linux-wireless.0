Return-Path: <SRS0=SE/f=NZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18B96C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 07:49:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D51FD21780
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 07:49:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ljYO5RyN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D51FD21780
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727833AbeKNRvH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 14 Nov 2018 12:51:07 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:44626 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727375AbeKNRvH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Nov 2018 12:51:07 -0500
Received: by mail-qk1-f194.google.com with SMTP id n12so24146886qkh.11
        for <linux-wireless@vger.kernel.org>; Tue, 13 Nov 2018 23:49:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mRrwjCuR0iBjfMeQ5caWKL4jcTrSqDfzWoejHIrx6Ak=;
        b=ljYO5RyNPX7Bvu7bcjM4x4S7uoArolj4cVnpqcfwvTV6KjXDYK/l1HAtHGPsbK0XwY
         j68zC2rT727xGKF9qJDGAvNg2eIy6IQJQvpFZgy2sWycrBG+FkkhDUS8uPS2daoydjMu
         LbP1XFm6VWV2gjJOJ0fzgmkcImyya5+YqMIhOWrNlNwzoVZOUP3GuCGA9pyGfQ9w38DU
         hEdHKmRQVW+Gkbt3f/7CgOsqNk+TqZx3r4iOBHxXgeiWfLhDo68nl/xY190whKCogQDt
         nhP45ib09oD6JjGprS+XWNEvWrCmZFClIukVoxJAzSJH+X9Pn7SpWHWoxmYI6DL+0q/h
         p7Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mRrwjCuR0iBjfMeQ5caWKL4jcTrSqDfzWoejHIrx6Ak=;
        b=pyyuj697CMW2+P0zUjKkfRxylKB9poJQ3sIy+YrEcX47G35io0nMRZVnay487+J0ns
         NZYnGae71XuT9uvVgfX0aJZ61QEvFEpdWkHMb8ghqwfT0NDANNvE9v9atPyM/X8LqdZv
         +CJgK62R78WaNYNb9ALFz9uZ7FJdR/L+zht6YS0hrV9dK97S/4MqVFVIQ6Rdw1GrOb8W
         GnnlvQ4hYexmags5qiVycn8OKT0mpDk6rBbXGfwmjtzw2JPQhK2nS9iHDFFI2mgoEQFF
         DFGh39mIRC0KbdzE7LnSTIFdjXeTiX0lll1lsIr3a7srnllgCYKOt+oF/2YmoFAaFCXF
         lFLw==
X-Gm-Message-State: AGRZ1gJFbt5jKccbcY5NrcP6GuM8bfpYIUc+6aFAGpOokV5TNjaqSqdW
        HIMoT5fM8fQ3gLWJVeVSfvji6J9JHQ7QkW/fC7k=
X-Google-Smtp-Source: AJdET5eCd0Sa1ULdRsMO6RlbIJMoUhteOGMzuoBn+D5f62rLoYD3PbLs4TcJRPPkFjXPY9oH9bq2y0Zux5TV5SMHOrw=
X-Received: by 2002:ac8:2487:: with SMTP id s7mr731884qts.116.1542181741625;
 Tue, 13 Nov 2018 23:49:01 -0800 (PST)
MIME-Version: 1.0
References: <1542163824-795-1-git-send-email-wgong@codeaurora.org>
In-Reply-To: <1542163824-795-1-git-send-email-wgong@codeaurora.org>
From:   =?UTF-8?Q?Micha=C5=82_Kazior?= <kazikcz@gmail.com>
Date:   Wed, 14 Nov 2018 08:48:49 +0100
Message-ID: <CABvG-CWg-VXAtoN8HZumW-ZdP6dX9cO_8fWJ58C22kD2yDcXdw@mail.gmail.com>
Subject: Re: [PATCH] ath10k: Remove ATH10K_STATE_RESTARTED in simulate fw crash
To:     Wen Gong <wgong@codeaurora.org>
Cc:     ath10k@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 14 Nov 2018 at 03:51, Wen Gong <wgong@codeaurora.org> wrote:
>
> When test simulate firmware crash, it is easy to trigger error.
> command:
> echo soft > /sys/kernel/debug/ieee80211/phyxx/ath10k/simulate_fw_crash.
>
> If input more than two times continuously, then it will have error.
> Error message:
> ath10k_pci 0000:02:00.0: failed to set vdev 1 RX wake policy: -108
> ath10k_pci 0000:02:00.0: device is wedged, will not restart
>
> It is because the state has not changed to ATH10K_STATE_ON immediately,
> then it will have more than two simulate crash process running meanwhile,
> and complete/wakeup some field twice, it destroy the normal recovery
> process.

This was intended to allow testing not only firmware crash path (and
recovery) but also firmware crash while recovering from a firmware
crash.


Micha=C5=82
