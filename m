Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f194.google.com ([209.85.223.194]:57364 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab0AGPpe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2010 10:45:34 -0500
Received: by iwn32 with SMTP id 32so2406752iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jan 2010 07:45:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100107140137.GA32125@mail.wantstofly.org>
References: <1262710858.28653.5.camel@johannes.local> <20100107140137.GA32125@mail.wantstofly.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 7 Jan 2010 07:45:14 -0800
Message-ID: <43e72e891001070745i334b7515kf78a95d12b981b95@mail.gmail.com>
Subject: Re: mac80211: fix queue selection for packets injected via monitor
	interface
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 7, 2010 at 6:01 AM, Lennert Buytenhek
<buytenh@wantstofly.org> wrote:
> Commit 'mac80211: fix skb buffering issue' added an ->ndo_select_queue()
> for monitor interfaces which can end up dereferencing ieee802_1d_to_ac[]
> beyond the end of the array for injected data packets (as skb->priority
> isn't guaranteed to be zero or within [0:7]), which then triggers the
> WARN_ON in net/core/dev.c:dev_cap_txqueue().  Fix this by always setting
> the priority to zero on injected data frames.
>
> Signed-off-by: Lennert Buytenhek <buytenh@marvell.com>

The other patches are for stable as well, so this should be for stable too?

  The stable wireless whore, Luis
