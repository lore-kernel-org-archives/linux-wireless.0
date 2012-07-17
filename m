Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:38683 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab2GQNEI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jul 2012 09:04:08 -0400
Message-ID: <1342530237.8139.5.camel@jlt3.sipsolutions.net> (sfid-20120717_150411_727969_B9F4F0C4)
Subject: Re: [ath5k-devel] [PATCH 2/2] mac80211: Remove control.sta from
 struct ieee80211_tx_info and restructure tx-path
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: coelho@ti.com, brcm80211-dev-list@broadcom.com,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, users@rt2x00.serialmonkey.com,
	ilw@linux.intel.com, ath9k-devel@lists.ath9k.org,
	b43-dev@lists.infradead.org, chunkeey@googlemail.com,
	dsd@gentoo.org, buytenh@wantstofly.org
Date: Tue, 17 Jul 2012 15:03:57 +0200
In-Reply-To: <5005613F.1000004@net.t-labs.tu-berlin.de>
References: <1342205545-45382-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
	 <1342205545-45382-3-git-send-email-thomas@net.t-labs.tu-berlin.de>
	 (sfid-20120713_205245_114771_49FF4AC7) <1342518290.7427.9.camel@jlt3.sipsolutions.net>
	 <5005613F.1000004@net.t-labs.tu-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-07-17 at 14:57 +0200, Thomas Huehn wrote:

> > Ok first of all, please actually compile the tree after your changes. It
> > doesn't. When it does, please fix
> 
> I always do compile the compat-wireless-tree after changes I introduce,
> and it compiles without errors in the case of this mac80211:sta-remove
> patch. But as my build tree is based on the OpenWrt environment, it
> might be not 100% in sync. Could you be a bit more explicit where does
> it brake in you case (which function, driver...) ?

No, I'm not going to play that game. Make sure it compiles on
wireless-next.

> I guess you refer to the comment in mac80211.h, struct tx_info that I
> removed:
> - * The TX control's sta pointer is only valid during the ->tx call,
> - * it may be NULL.
> 
> I am not sure what you want me to keep here as comment. As the sta
> pointer is moved into the new struct tx_control and the remaining
> pointers in the tx_info->control structure (vif, hw_key) are ALL only
> valid during the ->tx call and may be NULL. So I could think of adding a
> comment to tx_control about the sta been NULL, but anything more ?

It's also not allowed to copy the pointer, due to RCU, which is
information you lost.

johannes

