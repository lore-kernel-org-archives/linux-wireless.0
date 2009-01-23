Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36538 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758478AbZAWPpt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 10:45:49 -0500
Date: Fri, 23 Jan 2009 10:31:44 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	barreyromartin@gmail.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8187: Fix driver to return TX retry info for
	RTL8187L
Message-ID: <20090123153144.GA13658@tuxdriver.com> (sfid-20090123_164608_999727_B7EC3B59)
References: <49790961.JdcKIZyYlMNFSiuO%Larry.Finger@lwfinger.net> <4979DD39.9000601@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <4979DD39.9000601@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 23, 2009 at 04:07:37PM +0100, Hauke Mehrtens wrote:
> Larry Finger wrote:
> > Current code for the RTL8187 is not returning valid retry informati=
on, thus the
> > rate-setting mechanism is not functioning. As a further complicatio=
n, this info
> > is only obtained by reading a register, which cannot be read while =
in interrupt
> > context.
> >=20
> > This patch implements the TX status return to mac80211 through the =
use of a
> > work queue.
> >=20
> > Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> > Tested-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> > Tested-by: Mart=EDn Ernesto Barreyro <barreyromartin@gmail.com>
> > Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>
>=20
> I have tested this patch in compat-wireless-2009-01-23 (kernel 2.6.27=
,
> ubuntu) with my rtl8187 card (build on Asus P5B Delux Wifi, 0bda:8187
> Realtek Semiconductor Corp. RTL8187 Wireless Adapter) and for me it d=
oes
> not work.
>=20
> With this patch I get a connection to the AP, but the bandwidth is ve=
ry
> low. After a reboot it was connected to the AP, but the connection wa=
s
> unusable for me, no traffic went through the connection at all.

Just curious if you tried limiting the rate to 11Mb as Larry said
someone else had done?  Did that work any better?

John
--=20
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
