Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48652 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab1AFUqT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 15:46:19 -0500
Received: by iyi12 with SMTP id 12so15214807iyi.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jan 2011 12:46:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1294334198-20501-1-git-send-email-hauke@hauke-m.de>
References: <1294334198-20501-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 6 Jan 2011 12:45:58 -0800
Message-ID: <AANLkTi=-SNRtDy+oiUUcSTjqM5JU7VO7fTcFrLsgcxhw@mail.gmail.com>
Subject: Re: [PATCH] compat: backport kfifo
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 6, 2011 at 9:16 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> This is a copy of the hole kfifo implementation from a recent kernel
> version. When we ship this implementation we do not have to backport
> any kfifo related stuff any more.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Awesome stuff !! Just forgot the:

ifeq ($(CONFIG_COMPAT_KERNEL_36),y)
 export CONFIG_COMPAT_KFIFO=m
endif #CONFIG_COMPAT_KERNEL_36

on the Makefile but I'll add it. Thanks!

  Luis
