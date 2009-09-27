Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f194.google.com ([209.85.216.194]:34263 "EHLO
	mail-px0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbZI0Uaq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Sep 2009 16:30:46 -0400
MIME-Version: 1.0
In-Reply-To: <1254076075.6583.6.camel@johannes.local>
References: <1254076075.6583.6.camel@johannes.local>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sun, 27 Sep 2009 13:30:30 -0700
Message-ID: <43e72e890909271330p236c5e6bsbf838119fee9acef@mail.gmail.com>
Subject: Re: [PATCH 2/2] cfg80211: fix wireless handlers assignment
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hugh Dickins <hugh.dickins@tiscali.co.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Sep 27, 2009 at 11:27 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> The point we assign dev->wireless_handlers at is too
> late, we need to do that before netdev_register_kobject()
> gets called, so use the new NETDEV_PRE_INIT notifier.
> The result of adding wireless_handlers too late is the
> disappearance of /sys/class/net/wlan0/wireless which a
> bunch of distro scripts still require.
>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> This should fix the regression Hugh reported (of course requires the
> other patch which unfortunately I forgot to CC you, Hugh, I'll send you
> a copy in private).

Are these stable fixes?

  Luis
