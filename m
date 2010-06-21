Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:46428 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753046Ab0FUT0b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jun 2010 15:26:31 -0400
Message-ID: <4C1FBCDE.5090908@openwrt.org>
Date: Mon, 21 Jun 2010 21:26:22 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Helmut Schaa <helmut.schaa@googlemail.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: allow selection of minstrel_ht as default rc
 algo
References: <201006211059.58879.helmut.schaa@googlemail.com> <AANLkTinj36oA6QpEiYywGGkRqCmNRHSeR643HpiUsXC-@mail.gmail.com> <201006212118.06767.helmut.schaa@googlemail.com>
In-Reply-To: <201006212118.06767.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2010-06-21 9:18 PM, Helmut Schaa wrote:
> Am Montag 21 Juni 2010 schrieb Luis R. Rodriguez:
>> On Mon, Jun 21, 2010 at 1:59 AM, Helmut Schaa
>> <helmut.schaa@googlemail.com> wrote:
>> > Allow selection of minstrel_ht as default rate control algorithm. At the
>> > moment minstrel_ht can only be requested by the driver code but not selected
>> > as default in make menuconfig.
>> >
>> > Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
>> 
>> Shouldn't this just be enabled when you enable minstrel? I don't get
>> why we would split up the two.
> 
> Would be fine for me as well. But I'm not sure if we want minstrel_ht already
> as default and we want definitely keep the possibility to only select minstrel
> (if compiling on an embedded system with just bg wifi for example).
> 
> Felix, any objections against selecting minstrel_ht as default if minstrel
> was selected as default rc algo and minstrel_ht is compiled in?
> 
> In case of an embedded system without minstrel_ht minstrel would stay as default.
> 
> diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
> index 83eec7a..4d6f865 100644
> --- a/net/mac80211/Kconfig
> +++ b/net/mac80211/Kconfig
> @@ -69,6 +69,7 @@ endchoice
>  
>  config MAC80211_RC_DEFAULT
>  	string
> +	default "minstrel_ht" if MAC80211_RC_DEFAULT_MINSTREL && MAC80211_RC_MINSTREL_HT
>  	default "minstrel" if MAC80211_RC_DEFAULT_MINSTREL
>  	default "pid" if MAC80211_RC_DEFAULT_PID
>  	default ""
Looks good, I think we should do it this way.

- Felix
