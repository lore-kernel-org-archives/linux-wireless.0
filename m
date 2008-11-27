Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.190]:35160 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816AbYK0XpI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2008 18:45:08 -0500
Received: by mu-out-0910.google.com with SMTP id g7so997339muf.1
        for <linux-wireless@vger.kernel.org>; Thu, 27 Nov 2008 15:45:06 -0800 (PST)
Message-ID: <3ace41890811271545q73401ae7x53d925f4471fae23@mail.gmail.com> (sfid-20081128_004514_350701_CF869D43)
Date: Thu, 27 Nov 2008 23:45:06 +0000
From: "Hin-Tak Leung" <hintak.leung@gmail.com>
To: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
Subject: Re: [RFC] rtl8187: Do not wait for an ACK when IEEE80211_TX_CTL_NO_ACK is set
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Herton Ronaldo Krzesinski" <herton@mandriva.com.br>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <69e28c910811261431u26e341d3p51ebadca807f4b61@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <69e28c910811261431u26e341d3p51ebadca807f4b61@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 26, 2008 at 10:31 PM, Stefanik G=E1bor
<netrolller.3d@gmail.com> wrote:
> (Patch also available as an attachment in case Gmail decides to linew=
rap it.)
>
> Currently we always wait for an ACK even if IEEE80211_TX_CTL_NO_ACK i=
s set.
> This is just the opposite of what other drivers do.
> Change both RTL8187L and RTL8187B to skip waiting for an ACK when no
> ACK was requested.
>
> Signed-off-by: G=E1bor Stefanik <netrolller.3d@gmail.com>
Tested-by: Hin-Tak Leung <htl10@users.sourceforge.net>

I have it running and it doesn't seem to do anything bad, but there is
a curious issue - normally when I swap over
a new version of of the kernel module, wpa_supplicant/NetworkManager
kicks in soon afterwards; but this
(or latest wireless-testing - I haven't tried unpatched - I was
swapping from 2.6.27.7) seems to get ignored by wpa_supplicant
and requires a manual selection. Is there any possibility that this
might affect wpa_supplicant/NetworkManager for scanning for available
AP and/or associate/re-associate?

Hin-Tak
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
