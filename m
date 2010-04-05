Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:59150 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750960Ab0DEHiN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Apr 2010 03:38:13 -0400
Date: Mon, 5 Apr 2010 10:38:01 +0300
From: Jouni Malinen <j@w1.fi>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: =?utf-8?B?0JvQtdC00L7QstGB0LrQuNGFINCd0LjQutC+0LvQsNC5INCS0LDQu9C10YA=?=
	 =?utf-8?B?0YzQtdCy0LjRhw==?= <nledovskih@mail.ru>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: fix ieee80211_meshconf_ie::meshconf_cap type
 to be u16
Message-ID: <20100405073801.GA28792@jm.kir.nu>
References: <1270375964-23668-1-git-send-email-jcmvbkbc@gmail.com>
 <20100404234549.9fba2292.nledovskih@mail.ru>
 <201004042359.52494.jcmvbkbc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201004042359.52494.jcmvbkbc@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 04, 2010 at 11:59:52PM +0400, Max Filippov wrote:
> > On Sun,  4 Apr 2010 14:12:44 +0400
> > Max Filippov <jcmvbkbc@gmail.com> wrote:
> > 
> > > According to the current 802.11s draft mesh capability field
> > > is 16 bits wide.

This does not match with the latest 802.11s draft. Please also specify
the draft version in the commit message to make this easier to notice.
802.11s is still a moving target and unless we have a clearly specified
older version of the draft that we try to follow, I don't see much point
in updating this field based on some older version (D4.0) when the field
has already changed since then (D5.0).

> > > -	u8 meshconf_cap;
> > > +	u16 meshconf_cap;

> My reference is 802.11s-D4.01, it says (7.3.2.95.1):

That is not the latest draft. IEEE P802.11s/D5.0 7.3.2.96.1 shows the
Mesh Capability to be a one octet field.

> Element id: 1 octet,
> Length: 1 octet,
> Active path selection protocol identifier: 1 octet,
> Active path selection metric identifier: 1 octet,
> Congestion control mode identifier: 1 octet,
> Synchronization protocol identifier: 1 octet,
> Authentication protocol identifier: 1 octet,
> Mesh formation info: 1 octet,
> Mesh capability: 2 octets.
> 
> The length field is set to 8.

Length is still 8, but there is a new field (Mesh Peering Protocol
Identifier) before Mesh Formation Info (and Mesh capability is 1 octet).

-- 
Jouni Malinen                                            PGP id EFC895FA
