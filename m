Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39149 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473Ab0BPHSV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 02:18:21 -0500
Subject: Re: [PATCH 1/2] mac80211: Drop protected data frames that have not
 been decrypted
From: Johannes Berg <johannes@sipsolutions.net>
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
Cc: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4B79CC6B.5000905@free.fr>
References: <1266190653-2453-1-git-send-email-benoit.papillault@free.fr>
	 <69e28c911002141610q737465b4s1d825d6dcd3aea26@mail.gmail.com>
	 <4B78FBA5.7090109@free.fr> <1266226483.7084.1.camel@jlt3.sipsolutions.net>
	 <4B79CC6B.5000905@free.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Feb 2010 08:18:18 +0100
Message-ID: <1266304698.3771.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-02-15 at 23:36 +0100, Benoit PAPILLAULT wrote:

> Just for my own understanding. It seems the implementation has 2 
> different code path :
> - "real" monitor mode which is handled right after ieee80211_rx() so
> it 
> is not affected
> - "cook" monitor mode which is handled as part of the RX handlers.
> 
> BTW, why do we have 2 different code path? I'm sure I missed something
> 
> obvious here.

cooked monitor reports only usable, decrypted frames that the kernel
didn't know how to handle.

johannes

