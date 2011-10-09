Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48631 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab1JIVCl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Oct 2011 17:02:41 -0400
Received: by bkbzt4 with SMTP id zt4so7589911bkb.19
        for <linux-wireless@vger.kernel.org>; Sun, 09 Oct 2011 14:02:39 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Adrian Chadd <adrian@freebsd.org>
Subject: Re: [patch] fix the definition of AR9170_PHY_REG_CURRENT_RSSI
Date: Sun, 9 Oct 2011 23:02:26 +0200
Cc: linux-wireless@vger.kernel.org, Felix <ic.felix@gmail.com>
References: <CAJ-VmomAP-LZdVkh1snpsTOxU18yPMxXut=KzjTwP+AkN9XidQ@mail.gmail.com>
In-Reply-To: <CAJ-VmomAP-LZdVkh1snpsTOxU18yPMxXut=KzjTwP+AkN9XidQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201110092302.26965.chunkeey@googlemail.com> (sfid-20111009_230244_732131_85B2A8CE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, October 04, 2011 02:30:51 AM Adrian Chadd wrote:
> Although it currently isn't used anywhere, I thought it'd be
> worthwhile fixing the definition of AR9170_PHY_REG_CURRENT_RSSI.
> It's at AR_PHY(271) rather than AR_PHY(263).
>
> -#define        AR9170_PHY_REG_CURRENT_RSSI
> (AR9170_PHY_REG_BASE + 0x041c)
> +#define        AR9170_PHY_REG_CURRENT_RSSI
> (AR9170_PHY_REG_BASE + 0x043c) 

Hello again,

I had some time to check what is on 0x043c.
With AR9170 it looks like to be "0". This
wouldn't be surprising, however the old reg
0x041c seems to jumps around a lot [as
expected from the current rssi].
Adrian, are you sure the source is accurate?

Felix, do you know something about the
CURRENT_RSSI register?

Regards,
	Chr
