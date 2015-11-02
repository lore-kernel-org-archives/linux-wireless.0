Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from max.feld.cvut.cz ([147.32.192.36]:56742 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754014AbbKBSjD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2015 13:39:03 -0500
From: Michal Sojka <sojkam1@fel.cvut.cz>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org, bernd.lehmann@volkswagen.de,
	s.sander@nordsys.de, wireless-regdb@lists.infradead.org,
	ath9k-devel@lists.ath9k.org, ath9k-devel@qca.qualcomm.com,
	Jan =?utf-8?Q?Kaisrl=C3=ADk?= <kaisrja1@fel.cvut.cz>
Subject: Re: [PATCH v2] ath9k: Add support for ITS-G5 band (5.9 GHz)
In-Reply-To: <20151102174637.GA2350@w1.fi>
References: <1446459777-5944-1-git-send-email-sojkam1@fel.cvut.cz> <20151102165516.GA817@w1.fi> <87k2q0qpae.fsf@steelpick.2x.cz> <20151102174637.GA2350@w1.fi>
Date: Mon, 02 Nov 2015 19:38:57 +0100
Message-ID: <87h9l4qm9q.fsf@steelpick.2x.cz> (sfid-20151102_193907_331253_1BF08AFA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 02 2015, Jouni Malinen wrote:
> On Mon, Nov 02, 2015 at 06:33:45PM +0100, Michal Sojka wrote:
>> Can this be solved by having proper/new regulatory flags on these
>> channels that would prohibit running AP or scanning on these channels?
>
> I'm not sure that alone is sufficient, but yes, I think this should be
> done as part of the solution. On the 5.9 GHz band, cfg80211 should allow
> only the operations modes that are appropriate for that band.

We discussed that about a year ago [1]. The thing is that regulatory
documents do not talk about modes (at least in Europe). They only talk
about channel widths, EIRP etc. and say that the band is designated for
Intelligent Transportation System (ITS) applications. Only the ITS
standards (e.g. ETSI EN 302 663) talk about OCB mode. From the last
year's discussion I took away that we should not restrict these bands to
OCB only, because regulatory documents do not require it. But I might
get it wrong.

[1] http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg656581.html
>
>> I expect that there will be quite a lot applications/devices that will
>> need to communicate in this band. From technical point of view, it might
>> be beneficial if there is one solid implementation available in the
>> upstream Linux. I'm not sure about the legal point of view.
>
> I agree that it would be convenient and maybe even beneficial in the end
> as long as it is done in a way that meets the requirements for enforcing
> rules on the licensed band.
>
>> Can you image this "proper regulatory rule enforcement" as a part of
>> upstream Linux? Do you have an idea how it would look like?
>
> I'm not sure what would be sufficient. In general, I'm hesitant on
> enabling any licensed bands for Wi-Fi operations by default regardless
> of what the kernel configuration is.
>
>> Would kernel config option + custom regdb be sufficient?
>
> That would certainly be much closer to what I'd like to see from the
> regulatory enforcement view point; not sure how convenient this is to
> use with ath9k.

Hmm, ath9k is the hardware that we can currently play with. Can you
suggest another hardware that supports 5.9 GHz and a driver that would
be more convenient to develop with?

> I think the custom regdb route (i.e., require someone to knowingly
> generate the explicit rules to enable the licensed bands and only
> distribute the regdb with these changes to properly licensed users)
> was one of the approaches discussed in the past for this type of use
> cases.

Thanks for all the input. We will try to come up with another solution.

Regards.
-Michal
