Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55264 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754758Ab0BWXzE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2010 18:55:04 -0500
Received: by pwj8 with SMTP id 8so4321244pwj.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Feb 2010 15:55:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100223231527.8028.84024.stgit@mj.roinet.com>
References: <20100223231527.8028.84024.stgit@mj.roinet.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 23 Feb 2010 15:54:43 -0800
Message-ID: <43e72e891002231554o7b1b8bc5g865381c1b0a9e019@mail.gmail.com>
Subject: Re: [PATCH] ath9k: never read from the AR_IMR_S2 register
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 23, 2010 at 3:15 PM, Pavel Roskin <proski@gnu.org> wrote:
> The AR_IMR_S2 register sometimes cannot be read correctly.  Instead of a
> valid value, 0xdeadbeef is returned.  The driver has been observed
> writing that value back to AR_IMR_S2 after changing a few bits.
>
> Cache the register value in ah->imrs2_reg and always write chached value
> to the register.
>
> Signed-off-by: Pavel Roskin <proski@gnu.org>

What hardware was this seen with ? Can you enable PS debug to see if
perhaps PS is left enabled when we try to configure hardware. When we
touch some registers PS needs to be enabled, this could be a PS issue,
unless of course you see this also when PS is disabled by default.

  Luis
