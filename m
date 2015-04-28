Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49444 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932581AbbD1IiG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2015 04:38:06 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Jes.Sorensen@redhat.com
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net
Subject: Re: [PATCH 1/1] New driver: rtl8723au (mac80211)
References: <1427142300-28051-1-git-send-email-Jes.Sorensen@redhat.com>
	<1427142300-28051-2-git-send-email-Jes.Sorensen@redhat.com>
Date: Tue, 28 Apr 2015 11:37:59 +0300
In-Reply-To: <1427142300-28051-2-git-send-email-Jes.Sorensen@redhat.com> (Jes
	Sorensen's message of "Mon, 23 Mar 2015 16:25:00 -0400")
Message-ID: <87383kps0o.fsf@kamboji.qca.qualcomm.com> (sfid-20150428_103813_544059_4585429C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jes.Sorensen@redhat.com writes:

> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> This is an alternate driver for the Realtek 8723AU (rtl8723au) written
> from scratch utilizing the mac80211 stack.
>
> After spending months cleaning up the vendor provided rtl8723au
> driver, which comes with it's own 802.11 stack included, I decided to
> rewrite this driver from the bottom up.

Where is the vendor driver available, in staging or somewhere else? It
would be good to mention that in the commit log.

> Many thanks to Johannes Berg for 802.11 insights and help and Larry
> Finger for help with the vendor driver.
>
> The full git log for the development of this driver can be found here:
> git git://git.kernel.org/pub/scm/linux/kernel/git/jes/linux.git
>     branch rtl8723au-mac80211
>
> This driver is still experimental, but has proven to be rather stable
> for me. It lacks some features found in the staging driver, such as
> power management, AMPDU, and 40MHz channel support. In addition there
> is no AP and monitor support at this point.

It's nice to document in the commit log what features are verified to be
working.

Also I see incosistencies with driver naming, in some places I see
RTL8723au and elsewhere rtl8xxxu. And commit log title could be
improved, for example something like "rtl8xxxu: new wireless mac80211
driver for rtl8723au chipsets"

And I would like to understand the relationship with rtlwifi, can you
describe that a bit more? Why a separate driver instead of extending
rtlwifi? When I look at the directory drivers/net/wireless/rtlwifi/rtl8723ae 
I'm confused what's the bigger plan here. Larry?

>  MAINTAINERS                          |    8 +
>  drivers/net/wireless/Kconfig         |   19 +
>  drivers/net/wireless/Makefile        |    2 +
>  drivers/net/wireless/rtl8xxxu.c      | 4500 ++++++++++++++++++++++++++++++++++
>  drivers/net/wireless/rtl8xxxu.h      |  497 ++++
>  drivers/net/wireless/rtl8xxxu_regs.h |  941 +++++++

I think someone else already mentioned, but it would be better that has
it's own directory. Or should this actually be under rtlwifi directory?

> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8297,6 +8297,14 @@ S:	Maintained
>  F:	drivers/net/wireless/rtlwifi/
>  F:	drivers/net/wireless/rtlwifi/rtl8192ce/
>  
> +RTL8XXXU WIRELESS DRIVER (rtl8xxxu)
> +M:	Jes Sorensen <Jes.Sorensen@redhat.com>
> +L:	linux-wireless@vger.kernel.org
> +W:	http://intellinuxwireless.org

The link cannot be right.

> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jes/linux.git rtl8723au-mac80211

I doubt that this will be in active enough development that a separate
git tree is needed. wireless-drivers trees should be enough and this
line can be removed.

I'll do more detailed code review later, but my first impression was
that there was a lot of #if 0 code which is frowned upon.

And I pushed this to wireless-drivers-next.git pending branch so that
kbuild will run it's tests with this driver.

-- 
Kalle Valo
