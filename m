Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:50970 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbYIBX5m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2008 19:57:42 -0400
From: Christian Lamparter <chunkeey@web.de>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: [PATCH] p54usb: support LM87 firmwares
Date: Wed, 3 Sep 2008 02:00:50 +0200
Cc: linux-wireless@vger.kernel.org,
	"John W Linville" <linville@tuxdriver.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>
References: <200809022139.12969.chunkeey@web.de> <1ba2fa240809021614t4dfb1422sa82efeae8869ff6b@mail.gmail.com>
In-Reply-To: <1ba2fa240809021614t4dfb1422sa82efeae8869ff6b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809030200.50745.chunkeey@web.de> (sfid-20080903_015746_157245_A0C66350)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 03 September 2008 01:14:12 Tomas Winkler wrote:
> > diff -Nurp a/drivers/net/wireless/p54/p54common.c
> > b/drivers/net/wireless/p54/p54common.c ---
> > a/drivers/net/wireless/p54/p54common.c      2008-09-01 22:25:35.000000000
> > +0200 +++ b/drivers/net/wireless/p54/p54common.c      2008-09-02
> > 21:29:47.000000000 +0200 @@ -93,7 +93,10 @@ int p54_parse_firmware(struct
> > ieee80211_
> >                u32 code = le32_to_cpu(bootrec->code);
> >                switch (code) {
> >                case BR_CODE_COMPONENT_ID:
> > -                       switch (be32_to_cpu(*(__be32 *)bootrec->data)) {
> > +                       priv->fw_interface =
> > +                               be32_to_cpu(*(__be32 *)bootrec->data);
>
> what about be32_to_cpup?
> Tomas
whats the main difference between be32_to_cpu vs be32_to_cpus vs be32_to_cpup?
Does the extra p just stand for something like "pointer"?

hmm,
if yes, >>*<<(__be32 *)bootrec->data.
if no, please tell me more about it ;-). 

Regards,
	Chr
