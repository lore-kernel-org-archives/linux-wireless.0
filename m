Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33211 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab0JVJgs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 05:36:48 -0400
Received: by gyg4 with SMTP id 4so430824gyg.19
        for <linux-wireless@vger.kernel.org>; Fri, 22 Oct 2010 02:36:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTimqQqo2F+UD7j0OUXn_YF3EvkO5z6Njdo-=dhnY@mail.gmail.com>
References: <AANLkTimqQqo2F+UD7j0OUXn_YF3EvkO5z6Njdo-=dhnY@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 22 Oct 2010 02:36:26 -0700
Message-ID: <AANLkTik_Uj9adCUyOoMyx7t44AReK6yxcv_YLT_+Jm1U@mail.gmail.com>
Subject: Re: [PATCH] compat: Fixes missing sem member in struct device for RT
 PREEMPT prior to 2.6.34
To: Blaise Gassend <blaise@willowgarage.com>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 21, 2010 at 10:51 PM, Blaise Gassend
<blaise@willowgarage.com> wrote:
> The RT PREEMPT patch eliminates the sem member in struct device
> breaking device_lock, device_unlock and device_trylock in kernels
> prior to 2.6.34. The attached patch replaces the use of sem by a use
> of mutex.
>
> Signed-off-by: Blaise Gassend <blaise@willowgarage.com>

Alright, nice, thanks! Patch applied and I also propagated it to the
linux-2.6.36.y branch so that we can get this fix for the
compat-wireless-2.6.36 release as well. I should note your patch did
not apply as the offsets were way off but I did just read the patch
and merged it manually. What version of compat were you using?

  Luis
