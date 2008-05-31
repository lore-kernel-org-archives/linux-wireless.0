Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:36706 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbYEaRzM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2008 13:55:12 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: Wireless-testing's b43 panics in b43_generate_txhdr on packet transmit
Date: Sat, 31 May 2008 19:54:46 +0200
Cc: Stefanik =?iso-8859-1?q?G=E1bor?= <netrolller.3d@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>,
	linux-kernel@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
References: <69e28c910805310723j2b721030x2609cc9e866abafa@mail.gmail.com> <200805311841.46740.mb@bu3sch.de> <1212252636.2766.10.camel@rd>
In-Reply-To: <1212252636.2766.10.camel@rd>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200805311954.46639.mb@bu3sch.de> (sfid-20080531_195601_487797_48C525BE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 31 May 2008 18:50:36 Pavel Roskin wrote:
> On Sat, 2008-05-31 at 18:41 +0200, Michael Buesch wrote:
> > On Saturday 31 May 2008 18:34:29 Stefanik G=E1bor wrote:
> > > "BUG: unable to handle kernel NULL pointer dereference at 0000000=
4
> > > IP: [<f8dd3a99>] :b43:b43_generate_txhdr+0x6a9/0x790
> >=20
> > So can you put a few printks into the function to see where it dere=
ferences
> > a NULL pointer? (or use gdb to lookup the offset).
>=20
> u8 key_idx =3D info->control.hw_key->hw_key_idx;
>=20
> info->control.hw_key is NULL.

Is a NULL pointer supposed to tell "do not encrypt", or is this a mac80=
211 bug?

--=20
Greetings Michael.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
