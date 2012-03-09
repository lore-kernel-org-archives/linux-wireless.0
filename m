Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44424 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756031Ab2CINaI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2012 08:30:08 -0500
Received: by pbcun15 with SMTP id un15so2533010pbc.19
        for <linux-wireless@vger.kernel.org>; Fri, 09 Mar 2012 05:30:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1331299538.3491.4.camel@jlt3.sipsolutions.net>
References: <1331298825-22314-1-git-send-email-helmut.schaa@googlemail.com>
	<1331299538.3491.4.camel@jlt3.sipsolutions.net>
Date: Fri, 9 Mar 2012 14:30:08 +0100
Message-ID: <CAGXE3d_M0w7KVB35aX9Kzd=MLU0qkQ27_r_=s84OHtygukbk_g@mail.gmail.com> (sfid-20120309_143018_310040_CCB17798)
Subject: Re: [PATCH] mac80211: Disable MCS > 7 in minstrel_ht when STA uses
 static SMPS
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 9, 2012 at 2:25 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2012-03-09 at 14:13 +0100, Helmut Schaa wrote:
>> Disable multi stream rates (MCS > 7) when a STA is in static SMPS mode
>> since it has only one active rx chain. Hence, it doesn't even make
>> sense to sample multi stream rates.
>>
>> Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
>> ---
>>
>> I haven't found a STA that makes use of static SMPS, so this is only compile tested.
>
> You can easily make a mac80211 use it with the debugfs file?

Thanks for the hint, doing some tests with iwlagn right now ...
