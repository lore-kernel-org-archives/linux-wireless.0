Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36587 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab2GRPYo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jul 2012 11:24:44 -0400
MIME-Version: 1.0
In-Reply-To: <1342168714-3361-1-git-send-email-zefir.kurtisi@neratec.com>
References: <1342168714-3361-1-git-send-email-zefir.kurtisi@neratec.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Wed, 18 Jul 2012 08:24:23 -0700
Message-ID: <CAB=NE6VPHdY0oZUwQk5rc9t+XTajr3qDW3VF_FFa0C5kzJRx6Q@mail.gmail.com> (sfid-20120718_172448_990231_90D15EAE)
Subject: Re: [PATCH] compat: fix system crash on 2.6.35 when flushing work
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: mcgrof@kernel.org, lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 13, 2012 at 1:38 AM, Zefir Kurtisi
<zefir.kurtisi@neratec.com> wrote:
> Ubuntu 10.10 stock kernel (2.6.35-22-generic) crashes in
> compat_flush_scheduled_work(), that is called e.g. when
> mac80211 module is unloaded.
>
> The problem was introduced with 80bf8a83
> compat: backport system work queues system_wq and system_long_wq
>
> The crash happens in compat_flush_scheduled_work() where both
> flush_workqueue() and flush_scheduled_work() are called successively.
> Removing one of them resolves the issue.
>
> All compat-wireless tarballs after 2012-03-18 are affected.
>
> Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>

Thanks! Applied and pushed and I'll roll this into the stable series
as well and make a new set of releases where this is applicable today.

  Luis
