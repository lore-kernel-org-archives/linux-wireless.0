Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:48878 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934973AbcJXNmW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Oct 2016 09:42:22 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Antonio Quartulli <a@unstable.cc>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mac80211: passively scan DFS channels if requested
Date: Mon, 24 Oct 2016 15:42:18 +0200
Message-ID: <3178350.ZYYEYN7rIx@prime> (sfid-20161024_154224_969876_E47D2A04)
In-Reply-To: <1477316004.4085.17.camel@sipsolutions.net>
References: <1447464560-28104-1-git-send-email-antonio@meshcoding.com> <20161024121129.GA8925@prodigo.lan> <1477316004.4085.17.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1764233.q8U2H1WGkq"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart1764233.q8U2H1WGkq
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Monday, October 24, 2016 3:33:24 PM CEST Johannes Berg wrote:
> > > I think it would be reasonable only if the target channel is the
> > > one we are using and we have done CSA. But when scanning non-
> > > operative channels I don't think this could work.
> > 
> > this has been sleeping for a while.. :)
> > Would it make sense to rebase it and resubmit it for inclusion?
> > 
> > Given the previous discussion we could change the logic as:
> > * always passively scan DFS channels that are not usable
> > * always actively scan DFS channels that are usable (i.e. CAC was
> > performed).
> 
> Doesn't that contradict what you said above?
> 
> If we scan, don't we possibly lose our CAC result anyway, since we went
> off-channel? In FCC at least? In ETSI I think we're allowed to do that
> for a bit?

I believe going off-channel was allowed in general - in fact, some routers CAC 
all channels on boot up and then keep the "usable" state forever.

Otherwise, it would be pretty much impossible to perform CSAs to another DFS 
channel.

Cheers,
     Simon
--nextPart1764233.q8U2H1WGkq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIcBAABCgAGBQJYDg+6AAoJEKEr45hCkp6hEvwP/isjDZaJ0iXOkxdzEW8oiUJ5
L2RLV6Hutx9sJGQ39ouNP7yzl3Dw0BmRjTgMaqhBJxrEF6dyd3rDGrTqqNx6dZtT
XF7K06y8V7JUS+9GkvyT6ewMYPrqqCFYuVCOLS34PuAMYZIdHeQgvklIyyG+3EEb
RtUPRupsO3dkiFrqODRJYBjGvIqy0r2tBBeLnoHnRvUb9NtzVg4L+UdQHAUX4HSO
/yqTVK3RZEiBNrwhNyUA63OGMGvzkfvUvt/C0xiPChfQ0QFeAwIhnjvDzS1Jwy6F
BmnnKmH3eFcRBdZ9lggkH4m2PEvsMdKR1DDdM6qXRIFa24EowY8nnW/DJHFZsHbR
mkoV1qY/FVB5zEXJc6B+6C82coMbw7G+QjxS/MrS8Ldi4cLVB0zvcmWBSKhTkNL+
gDA1W6jyaKHHxleOH4WM+XzYOImntIptGIu6KcWnW4/e/jwa2LK/YhRf6tRx3Fbu
qCFfEtf0hYPidA8TVChszxazetfkb4nqTGgTuag+g/9ZiZSrAoR1mtul8HZivpHp
oJ+Pey0zqtdNx0M0/dREFL2aRpG8GZMCHj7FZc6nklSOJO6eR2Nv16fehtwA5+yk
aDTqqNk4xy22PCFDjIbn4iKRIXbUGe8NUt6qUJrfRanCNFfRhNgNieuEZqok0xCX
XDQBSU/nOAeEYXoizYoX
=2Xgk
-----END PGP SIGNATURE-----

--nextPart1764233.q8U2H1WGkq--
