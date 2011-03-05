Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41350 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab1CENwB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Mar 2011 08:52:01 -0500
MIME-Version: 1.0
In-Reply-To: <1299328260.4277.92.camel@localhost>
References: <1299108754-5492-1-git-send-email-bookjovi@gmail.com>
	<1299328260.4277.92.camel@localhost>
Date: Sat, 5 Mar 2011 21:52:00 +0800
Message-ID: <AANLkTimnSvBKSL6_d3RxufxUL_C9wCM+Fz66_B5Sc0KE@mail.gmail.com>
Subject: Re: [PATCH] net: mac80211: fix compilation warning
From: Jovi Zhang <bookjovi@gmail.com>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	"open list:NETWORKING [WIREL..." <linux-wireless@vger.kernel.org>,
	"open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 5, 2011 at 8:31 PM, Ben Hutchings <bhutchings@solarflare.com> wrote:
> On Wed, 2011-03-02 at 18:32 -0500, bookjovi@gmail.com wrote:
>> From: Jovi Zhang <bookjovi@gmail.com>
>>
>> this commit fix compilation warning as following:
>> net/mac80211/tx.c:1753: warning: unused variable mppath
> [...]
>
> You clearly didn't try building this with CONFIG_MAC80211_MESH enabled.
>
Sorry, indeed, maybe should be like this:

+#ifdef CONFIG_MAC80211_MESH
       struct mesh_path *mppath = NULL;
+#endif
