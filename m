Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f51.google.com ([74.125.83.51]:50966 "EHLO
	mail-gw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab1CGEPD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 23:15:03 -0500
MIME-Version: 1.0
In-Reply-To: <4D72650D.8070503@lwfinger.net>
References: <1299108754-5492-1-git-send-email-bookjovi@gmail.com>
	<1299328260.4277.92.camel@localhost>
	<AANLkTimnSvBKSL6_d3RxufxUL_C9wCM+Fz66_B5Sc0KE@mail.gmail.com>
	<4D72650D.8070503@lwfinger.net>
Date: Mon, 7 Mar 2011 12:15:02 +0800
Message-ID: <AANLkTi=GHOyeSWA96UUokmYSdHHc5cuY53xJuhVzBNwz@mail.gmail.com>
Subject: Re: [PATCH] net: mac80211: fix compilation warning
From: Jovi Zhang <bookjovi@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ben Hutchings <bhutchings@solarflare.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	"open list:NETWORKING [WIREL..." <linux-wireless@vger.kernel.org>,
	"open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 6, 2011 at 12:30 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 03/05/2011 07:52 AM, Jovi Zhang wrote:
>>
>> On Sat, Mar 5, 2011 at 8:31 PM, Ben Hutchings<bhutchings@solarflare.com>
>>  wrote:
>>>
>>> On Wed, 2011-03-02 at 18:32 -0500, bookjovi@gmail.com wrote:
>>>>
>>>> From: Jovi Zhang<bookjovi@gmail.com>
>>>>
>>>> this commit fix compilation warning as following:
>>>> net/mac80211/tx.c:1753: warning: unused variable mppath
>>>
>>> [...]
>>>
>>> You clearly didn't try building this with CONFIG_MAC80211_MESH enabled.
>>>
>> Sorry, indeed, maybe should be like this:
>>
>> +#ifdef CONFIG_MAC80211_MESH
>>        struct mesh_path *mppath = NULL;
>> +#endif
>
> Linville likes "struct mesh_path *mppath __maybe_unused = NULL;" over the
> ifdef form.

That's better, Thanks.
