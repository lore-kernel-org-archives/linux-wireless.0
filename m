Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:44538 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758962AbYLLQhW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 11:37:22 -0500
Date: Fri, 12 Dec 2008 18:34:29 +0200
From: Jouni Malinen <j@w1.fi>
To: Henning Rogge <hrogge@googlemail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Stefanik =?utf-8?B?R8OhYm9y?= <netrolller.3d@gmail.com>,
	Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Thomas d'Otreppe" <tdotreppe@aircrack-ng.org>
Subject: Re: [PATCH 3/3] mac80211: Add HT rates into radiotap
Message-ID: <20081212163429.GA19806@jm.kir.nu> (sfid-20081212_173728_683184_6A3B56B0)
References: <20081212123832.506588839@atheros.com> <1229093327.3600.12.camel@johannes.berg> <20081212151619.GA16981@jm.kir.nu> <200812121631.56952.hrogge@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200812121631.56952.hrogge@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 12, 2008 at 04:31:51PM +0100, Henning Rogge wrote:
> On Friday 12 December 2008 16:16:19 Jouni Malinen wrote:

> Changing the meaning of the old "txrate" field (by putting an index inside) is 
> a great way to break the userspace interface to any existing program. :(

Well, depends on what you mean with breaking ;-). In this particular
case, the output may show incorrect rate in a case where the previous
version showed incorrect rate (e.g., ath9k just reported the highest
legacy rate when HT rates were used). In context of Linux and radiotap,
there wasn't really anything working before that this would break.

> Just get a new field for the mcs index.

Unfortunately, that does not seem to be that easy a task.. I tried to
subscribe to the radiotap mailing list, but the info page is returning
403 Forbidden. Then I tried looking at the archive, and that returned
404.. If I've understood correctly, that has been the state of the
mailing list for a long time. Furthermore, many (most?) people working
with radiotap for Linux/*BSD/wireshark/tcpdump seem to have more or less
given up on the effort to come up with a shared specification for the
format.

-- 
Jouni Malinen                                            PGP id EFC895FA
