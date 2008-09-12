Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.226]:59300 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754297AbYILCcj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2008 22:32:39 -0400
Received: by qb-out-0506.google.com with SMTP id f11so1254151qba.17
        for <linux-wireless@vger.kernel.org>; Thu, 11 Sep 2008 19:32:38 -0700 (PDT)
Message-ID: <f488382f0809111932v1cc1eb44kbe0bc0e97347c834@mail.gmail.com> (sfid-20080912_043249_942747_D4773FAD)
Date: Thu, 11 Sep 2008 19:32:37 -0700
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: I need help with a sparse warning
Cc: LKML <linux-kernel@vger.kernel.org>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <48C9D040.8010107@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <48C9D040.8010107@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 11, 2008 at 7:13 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> In file drivers/net/wireless/p54/p54common.c, the statement
>
>       priv->rx_mtu = (size_t) le16_to_cpu((__le16)bootrec->data[10]);
>
> generates the sparse warning
>
> .../p54common.c:185:29: warning: cast to restricted __le16
>
> where bootrec->data is u32, and priv->rx_mtu is u16.
>

(Whoops, didn't CC the mailing lists. Sorry about the double-message, Larry.)

If priv->rx_mtu is u16, I'm surprised it doesn't get noisy about the
size_t cast. Unless the machine it's being compiled on is 16-bit, that
should throw a truncation warning, because size_t should be a 32-bit
integer on 32-bit machines (typically).

I think if you change the (__le16) cast to (__le16 __force) it will
stop warning you about that particular issue.

- Steven
