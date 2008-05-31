Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:41483 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbYEaRGq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2008 13:06:46 -0400
Subject: Re: Wireless-testing's b43 panics in b43_generate_txhdr on packet
	transmit
From: Pavel Roskin <proski@gnu.org>
To: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: "bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux-kernel@vger.kernel.org
In-Reply-To: <69e28c910805310954s6c478001h837415a6a63d26f0@mail.gmail.com>
References: <69e28c910805310723j2b721030x2609cc9e866abafa@mail.gmail.com>
	 <1212252522.2766.8.camel@rd>
	 <69e28c910805310954s6c478001h837415a6a63d26f0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Date: Sat, 31 May 2008 13:06:44 -0400
Message-Id: <1212253604.2766.15.camel@rd> (sfid-20080531_190654_290926_104A0125)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-05-31 at 18:54 +0200, Stefanik G=E1bor wrote:
> On Sat, May 31, 2008 at 6:48 PM, Pavel Roskin <proski@gnu.org> wrote:
> > It's strange that other drivers (b43legacy, ath5k) use
> > info->control.hw_key->hw_key_idx under the same conditions (see how
> > use_encryption is calculated), but don't have any problems on the s=
ame
> > network (but I need to recheck).
>=20
> Hmm... does ath5k use hardware crypto?

No, it doesn't, at least with WEP, if I understand ath5k_set_key()
correctly.

> B43 does (but not with
> nohwcrypt - and that appears to be a valid workaround), b43legacy
> doesn't AFAIK.

Although the code with use_encryption is present in b43legacy, it don't
see any references to "set_key", so I guess you are right.

Well, that explains something.

--=20
Regards,
Pavel Roskin
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
