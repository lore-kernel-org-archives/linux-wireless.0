Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:54733 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758048Ab3BTTHL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2013 14:07:11 -0500
Message-ID: <1361387228.3043.3.camel@joe-AO722> (sfid-20130220_200717_165244_6F5BF98C)
Subject: Re: [PATCH] ssb: fix unaligned access to mac address
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	Hauke Mehrtens <hauke@hauke-m.de>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Date: Wed, 20 Feb 2013 11:07:08 -0800
In-Reply-To: <51250E6B.3030308@lwfinger.net>
References: <1361021140-19871-1-git-send-email-hauke@hauke-m.de>
	 <CACna6ryaMfZ9x7VWHnRR9RF0wSN0A+H6vr3AC103Sn4G1XZdKQ@mail.gmail.com>
	 <1361381489.3065.1.camel@joe-AO722> <51250E6B.3030308@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-20 at 11:56 -0600, Larry Finger wrote:

> I like the looks of sprom_get_mac() over that ugly
> *(((__be16 *)out->il0mac) 
> construct, but this patch breaks ssb.
> The resulting MAC address is all ones.
[]
> > @@ -539,10 +533,8 @@ static void sprom_extract_r8(struct ssb_sprom *out, const u16 *in)
> >   			ARRAY_SIZE(out->core_pwr_info));
> >
> >   	/* extract the MAC address */
> > -	for (i = 0; i < 3; i++) {
> > -		v = in[SPOFF(SSB_SPROM8_IL0MAC) + i];
> > -		*(((__be16 *)out->il0mac) + i) = cpu_to_be16(v);
> > -	}
> > +	sprom_get_mac(out->il0mac, &in[SSB_SPROM8_IL0MAC]);

Yup, I did a stupid.

This one should be:

	sprom_get_mac(out->il0mac, &in[SPOFF(SSB_SPROM8_IL0MAC)]);


