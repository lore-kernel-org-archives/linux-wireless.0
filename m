Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38953 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758552Ab1CaQDK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Mar 2011 12:03:10 -0400
MIME-Version: 1.0
In-Reply-To: <4D8E8B1E.3030709@users.sourceforge.net>
References: <1301174394-12642-1-git-send-email-wuzhangjin@gmail.com>
	<4D8E5BA3.1090909@users.sourceforge.net>
	<AANLkTind3Va9J_tvZBDAPfbuyQtgxoAE+ZzG6VpU1b1q@mail.gmail.com>
	<4D8E8B1E.3030709@users.sourceforge.net>
Date: Fri, 1 Apr 2011 00:03:09 +0800
Message-ID: <AANLkTin48KZ0wc6SiB+E3VOkVAZ5-Xj9WdhstsgEO14z@mail.gmail.com>
Subject: Re: [RFC PATCH] rtl8187: Fix led support for rfkill
From: wu zhangjin <wuzhangjin@gmail.com>
To: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Herton Ronaldo Krzesinski <herton@canonical.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Roman Mamedov <rm@romanrm.ru>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 27, 2011 at 8:55 AM, Hin-Tak Leung
<htl10@users.sourceforge.net> wrote:
[...]
>
> Hmm, I seem to have the impression that there is code somewhere for
> switching a singular LED's behavior of the driver between one or the other,
> by echo'ing into sysfs or some other trickery? Or would that be a desired
> approach if that's not done at the moment?

Do you mean the interface: /sys/class/rfkill/rfkill0/state? or
something like /sys/class/leds/...::/brightness?

Seems the LED behavior can be triggered automatically by the rfkill
input event with the kernel config option(MAC80211_LEDS, RFKILL_LEDS),
so, echo'ing to such interface may be not a good idea ;-)

Best Regards,
Wu Zhangjin
