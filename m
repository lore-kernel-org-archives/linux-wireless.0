Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57126 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbYJHUDb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Oct 2008 16:03:31 -0400
Date: Wed, 8 Oct 2008 16:02:50 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Stefanik =?iso-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH] rtl8187: do not report ACKs if USB Tx status is
	non-zero
Message-ID: <20081008200250.GD32472@tuxdriver.com> (sfid-20081008_220334_786679_E009768A)
References: <1223407098-23060-1-git-send-email-linville@tuxdriver.com> <20081008184205.GB32472@tuxdriver.com> <69e28c910810081238m612ece22l2c26b38a88aba608@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <69e28c910810081238m612ece22l2c26b38a88aba608@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 08, 2008 at 09:38:49PM +0200, Stefanik G=E1bor wrote:

> Another weird thing: the code above essentially attempts to do this:
> Wait for an ACK
> If not TX_CTL_NO_ACK:
>    If acked:
>       Report the packet as acked.
>    Endif
>    If no ACK until timeout:
>       Report packet as unacked
>    Endif
> Endif
>=20
> This would be better, as it doesn't waste time waiting for an ACK for
> unacked frames:
>=20
> If not TX_CTL_NO_ACK:
> Wait for an ACK
>    If acked:
>       Report the packet as acked.
>    Endif
>    If no ACK until timeout:
>       Report packet as unacked
>    Endif
> Endif
>=20
> Of course, this only works if "Wait for an ACK" actually works.

Well as I understand it, the only waiting is related to the URB
submission (which is asynchronous anyway).  I don't really see how
we could avoid it.

John
--=20
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
