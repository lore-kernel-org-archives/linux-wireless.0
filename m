Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:42273 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758648Ab1CaQWw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 12:22:52 -0400
MIME-Version: 1.0
In-Reply-To: <20110328154046.GB2333@herton-IdeaPad-Y430>
References: <1301174394-12642-1-git-send-email-wuzhangjin@gmail.com>
	<4D8E5BA3.1090909@users.sourceforge.net>
	<AANLkTind3Va9J_tvZBDAPfbuyQtgxoAE+ZzG6VpU1b1q@mail.gmail.com>
	<4D8E8B1E.3030709@users.sourceforge.net>
	<4D8FBE88.3050907@lwfinger.net>
	<20110328154046.GB2333@herton-IdeaPad-Y430>
Date: Fri, 1 Apr 2011 00:22:51 +0800
Message-ID: <AANLkTinwG5BR5=S14XYcwZ39c3k0xc9+2VsQFS+JHB0f@mail.gmail.com>
Subject: Re: [RFC PATCH] rtl8187: Fix led support for rfkill
From: wu zhangjin <wuzhangjin@gmail.com>
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Hin-Tak Leung <htl10@users.sourceforge.net>,
	Herton Ronaldo Krzesinski <herton@canonical.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Roman Mamedov <rm@romanrm.ru>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 28, 2011 at 11:40 PM, Herton Ronaldo Krzesinski
<herton.krzesinski@canonical.com> wrote:
[...]
>>
>> My rtl8187 devices are both external USB sticks, thus they have no
>> interaction with a radio-kill switch. I will test your patch to make
>> sure it does no harm to my system.
>>
>> I think the commit message should be revised. A simple statement
>> like "the LED does not turn off when the rfkill switch is off"
>> should be sufficient.
>
> The patch should work, but I wonder if we should be fiddling with priv->vif
> for this, perhaps we should not assume vif to be valid after
> rtl8187_remove_interface (I don't see problems with current
> rtl8187/mac80211 code on a quick look, but...)
>

Yes, but seems only two places have touched the vif pointer.

$ grep "vif =" -ur drivers/net/wireless/rtl818x/rtl8187/
drivers/net/wireless/rtl818x/rtl8187/dev.c:	priv->vif = NULL;
drivers/net/wireless/rtl818x/rtl8187/dev.c:	priv->vif = vif;

> I cleaner solution may be to use a priv->mode like p54.

Yep, then, we may need to add a 'mode' member to rtl8187_priv and
update it properly like p54.

So, What do you prefer? I will prepare a new patch asap.

Best Regards,
Wu Zhangjin

>
>>
>> Larry
>>
>
> --
> []'s
> Herton
>
