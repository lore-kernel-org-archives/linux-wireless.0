Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:34201 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752603AbbKBRql (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2015 12:46:41 -0500
Date: Mon, 2 Nov 2015 19:46:37 +0200
From: Jouni Malinen <j@w1.fi>
To: Michal Sojka <sojkam1@fel.cvut.cz>
Cc: linux-wireless@vger.kernel.org, bernd.lehmann@volkswagen.de,
	s.sander@nordsys.de, wireless-regdb@lists.infradead.org,
	ath9k-devel@lists.ath9k.org, ath9k-devel@qca.qualcomm.com,
	Jan =?utf-8?B?S2Fpc3Jsw61r?= <kaisrja1@fel.cvut.cz>
Subject: Re: [PATCH v2] ath9k: Add support for ITS-G5 band (5.9 GHz)
Message-ID: <20151102174637.GA2350@w1.fi> (sfid-20151102_184645_356609_B2F63DD0)
References: <1446459777-5944-1-git-send-email-sojkam1@fel.cvut.cz>
 <20151102165516.GA817@w1.fi>
 <87k2q0qpae.fsf@steelpick.2x.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87k2q0qpae.fsf@steelpick.2x.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 02, 2015 at 06:33:45PM +0100, Michal Sojka wrote:
> Can this be solved by having proper/new regulatory flags on these
> channels that would prohibit running AP or scanning on these channels?

I'm not sure that alone is sufficient, but yes, I think this should be
done as part of the solution. On the 5.9 GHz band, cfg80211 should allow
only the operations modes that are appropriate for that band.

> I expect that there will be quite a lot applications/devices that will
> need to communicate in this band. From technical point of view, it might
> be beneficial if there is one solid implementation available in the
> upstream Linux. I'm not sure about the legal point of view.

I agree that it would be convenient and maybe even beneficial in the end
as long as it is done in a way that meets the requirements for enforcing
rules on the licensed band.

> Can you image this "proper regulatory rule enforcement" as a part of
> upstream Linux? Do you have an idea how it would look like?

I'm not sure what would be sufficient. In general, I'm hesitant on
enabling any licensed bands for Wi-Fi operations by default regardless
of what the kernel configuration is.

> Would kernel config option + custom regdb be sufficient?

That would certainly be much closer to what I'd like to see from the
regulatory enforcement view point; not sure how convenient this is to
use with ath9k. I think the custom regdb route (i.e., require someone to
knowingly generate the explicit rules to enable the licensed bands and
only distribute the regdb with these changes to properly licensed users)
was one of the approaches discussed in the past for this type of use
cases.

-- 
Jouni Malinen                                            PGP id EFC895FA
