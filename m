Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f204.google.com ([209.85.221.204]:41978 "EHLO
	mail-qy0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbZFKSsb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2009 14:48:31 -0400
Received: by qyk42 with SMTP id 42so94470qyk.33
        for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2009 11:48:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A30CE70.4050605@web.de>
References: <4A30CE70.4050605@web.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 11 Jun 2009 11:48:13 -0700
Message-ID: <43e72e890906111148w1c242bd1qf97cb668a98f883e@mail.gmail.com>
Subject: Re: compat-wireless: ridiculous build speed
To: Jan Kiszka <jan.kiszka@web.de>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 11, 2009 at 2:29 AM, Jan Kiszka<jan.kiszka@web.de> wrote:
> Hi,
>
> while watching compat-wireless-2009-06-11 doing baby-steps building all
> its modules, I wonder what slows this down so horribly. No other
> external module build package I know is that slow (I would say *at
> least* one order of magnitude slower than normal). Is this really required?
>
> [ Hurray, it's finished! ]

I think the many depmod -ae are the culprit. This is in place to
account for all the crap of madwifi which may be present or older
drivers which have been renamed.

This could be improved. Patches are welcomed.

Ps. Try building with make -j 2, etc.

  Luis
