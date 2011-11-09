Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51339 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab1KIVfa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Nov 2011 16:35:30 -0500
Subject: Re: 3.2-rc1: system locks up upon inserting brcmsmac
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Arik Nemtsov <arik@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4EBAF088.2040406@broadcom.com>
References: <4EBAF088.2040406@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 09 Nov 2011 22:35:22 +0100
Message-ID: <1320874522.3845.109.camel@jlt3.sipsolutions.net> (sfid-20111109_223537_800102_1F9E325D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-11-09 at 22:28 +0100, Arend van Spriel wrote:
> Hi John,
> 
> I merged wireless-testing master with our main development branch and
> got a hanging system. So I tested your master branch after that and the
> same result. Given the kernel log it may be the commit mentioned below
> although I did not bisect it yet.
> 
> 077a91548 mac80211: support adding IV-room in the skb for CCMP keys

Yeah that commit looks like it would add the bug -- it should check
info->control.hw_key before the second test of
IEEE80211_KEY_FLAG_PUT_IV_SPACE in ccmp_encrypt_skb.

Try

-	if (info->control.hw_key->flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE)
+	if (info->control.hw_key && info->control.hw_key->flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE)

johannes

