Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38015 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab2JATUU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Oct 2012 15:20:20 -0400
Message-ID: <1349119253.10330.44.camel@jlt4.sipsolutions.net> (sfid-20121001_212024_576656_FEDEE2BA)
Subject: Re: 802.11w   bip_aad() bug ?
From: Johannes Berg <johannes@sipsolutions.net>
To: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 01 Oct 2012 21:20:53 +0200
In-Reply-To: <BD54DDEB2546894FAB0731EA7B0EDF8D075EB5FF@RockMX01.rock.corp> (sfid-20121001_172613_798023_EF8A5536)
References: <BD54DDEB2546894FAB0731EA7B0EDF8D075EB5FF@RockMX01.rock.corp>
	 (sfid-20121001_172613_798023_EF8A5536)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-10-01 at 15:13 +0000, Chaoxing Lin wrote:
> Gentlemen,
> 
> In kernel/net/mac80211/wpa.c function bip_add is as below (in the end).
> 
> I think the aad[1] should be 
> aad[1] = skb->data[1] & ~(BIT(3) | BIT(4) | BIT(5));
> 
> 
> Reference 1: ieee802.11-2012 page 1212
> "FC-MPDU Frame Control field, with:
> 1) Retry bit (bit 11) masked to 0
> 2) Power Management bit (bit 12) masked to 0
> 3) More Data bit (bit 13) masked to 0"
> 
> Reference 2: ieee80211-2012, page 404, Figure 8-12
> 
> The bit 11 should be bit 3 of second byte.
> The bit 12 should be bit 4 of second byte.
> The bit 13 should be bit 5 of second byte.
> 
> 
> What did I miss??

Nothing, we just fixed that:
http://git.kernel.org/?p=linux/kernel/git/jberg/mac80211.git;a=commitdiff;h=33766368f6532313571534f9112b1796d6651bbe

(note that the URL might not be accessible yet, I pieced it together and
had evidently forgotten to push out this change before, so you may have
to wait for git.kernel.org to sync with the master)

johannes

