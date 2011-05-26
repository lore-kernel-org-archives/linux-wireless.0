Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:42454 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754934Ab1EZHiE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2011 03:38:04 -0400
Date: Thu, 26 May 2011 10:37:52 +0300
From: Jouni Malinen <j@w1.fi>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	Matt Smith <Matt.Smith@atheros.com>, hostap@lists.shmoo.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Initial automatic channel selection implementation
Message-ID: <20110526073752.GB4426@jm.kir.nu> (sfid-20110526_093819_826389_650973A5)
References: <BANLkTi=-MDn9eAsRsoXtAetDOZehkMEhJw@mail.gmail.com>
 <201105241627.49201.helmut.schaa@googlemail.com>
 <BANLkTikcEsKYo=c=ZmzJRbmfgjmrFmx9bg@mail.gmail.com>
 <BANLkTin4MvdbqugTjtXvmjz5N8_TyTY7OA@mail.gmail.com>
 <BANLkTi=xfv_0C1mVAtO=w5JqyXLvh=vtAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <BANLkTi=xfv_0C1mVAtO=w5JqyXLvh=vtAQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 25, 2011 at 07:37:31AM -0700, Luis R. Rodriguez wrote:
> Nice, yeah I was thinking of using the offchannel operation if we want
> to spend more time there for inspection and if associated. For first
> iteration it should be possible to just move around. In fact for AP
> purposes I suppose one will want to just start AP mode ASAP and then
> later do offchannel operations to do the inspection on the ideal
> channel. Otherwise we sit there idle until we complete the Automatic
> Channel Selection thingy.

For P2P use cases, it would be convenient to maintain some information
about what could be the best channel on 2.4 GHz and 5 GHz band all the
time. This does not have to be the best possible channel, but something
reasonably good. There is no time to go through additional scanning of
all channels in number of P2P protocol exchanges, so this type of
information is needed before starting GO Negotiation (which could be
started by other devices, too). It is possible to change channels later
if a considerably better alternative becomes known after the group has
been started.

-- 
Jouni Malinen                                            PGP id EFC895FA
