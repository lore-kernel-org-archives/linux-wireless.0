Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:34216 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751834AbbKBS71 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2015 13:59:27 -0500
Date: Mon, 2 Nov 2015 20:59:23 +0200
From: Jouni Malinen <j@w1.fi>
To: Michal Sojka <sojkam1@fel.cvut.cz>
Cc: linux-wireless@vger.kernel.org, bernd.lehmann@volkswagen.de,
	s.sander@nordsys.de, wireless-regdb@lists.infradead.org,
	ath9k-devel@lists.ath9k.org, ath9k-devel@qca.qualcomm.com,
	Jan =?utf-8?B?S2Fpc3Jsw61r?= <kaisrja1@fel.cvut.cz>
Subject: Re: [PATCH v2] ath9k: Add support for ITS-G5 band (5.9 GHz)
Message-ID: <20151102185923.GA3707@w1.fi> (sfid-20151102_195930_686913_3CFDDB0C)
References: <1446459777-5944-1-git-send-email-sojkam1@fel.cvut.cz>
 <20151102165516.GA817@w1.fi>
 <87k2q0qpae.fsf@steelpick.2x.cz>
 <20151102174637.GA2350@w1.fi>
 <87h9l4qm9q.fsf@steelpick.2x.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87h9l4qm9q.fsf@steelpick.2x.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 02, 2015 at 07:38:57PM +0100, Michal Sojka wrote:
> We discussed that about a year ago [1]. The thing is that regulatory
> documents do not talk about modes (at least in Europe). They only talk
> about channel widths, EIRP etc. and say that the band is designated for
> Intelligent Transportation System (ITS) applications. Only the ITS
> standards (e.g. ETSI EN 302 663) talk about OCB mode. From the last
> year's discussion I took away that we should not restrict these bands to
> OCB only, because regulatory documents do not require it. But I might
> get it wrong.
> 
> [1] http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg656581.html

In some sense, I agree with that, but taken into account that I'm much
more concerned about accidentally using this band, I think there is
justification for adding that extra constraint of allowing only the OCB
mode to be used even if the regulatory requirements may not explicitly
say so. Especially the behavior of including these channels with active
scanning allowed in all full scans is something that really must not be
enabled.

> Hmm, ath9k is the hardware that we can currently play with. Can you
> suggest another hardware that supports 5.9 GHz and a driver that would
> be more convenient to develop with?

I don't think there is any hardware alternative that would be more
convenient for this type of efforts than chips supported by ath9k. It is
just that the needs of this project are somewhat in conflict with the
needs of regulatory rule enforcement for most other use cases.. :)

-- 
Jouni Malinen                                            PGP id EFC895FA
