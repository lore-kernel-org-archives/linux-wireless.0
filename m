Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f50.google.com ([209.85.214.50]:46346 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab3KDPr5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Nov 2013 10:47:57 -0500
Received: by mail-bk0-f50.google.com with SMTP id v4so3016211bkz.37
        for <linux-wireless@vger.kernel.org>; Mon, 04 Nov 2013 07:47:56 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	alexandre.f.demers@gmail.com, linville@tuxdriver.com
Subject: Re: r92su: status and will it be merged anytime soon?
Date: Mon, 04 Nov 2013 16:47:53 +0100
Message-ID: <2241712.PWvD8zsTbX@blech> (sfid-20131104_164804_181538_4F8FA020)
In-Reply-To: <5277BE84.7020808@lwfinger.net>
References: <5277AC85.5050104@gmail.com> <5277BE84.7020808@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday, November 04, 2013 09:34:28 AM you wrote:
> On 11/04/2013 08:17 AM, Xose Vazquez Perez wrote:
> > Christian Lamparter wrote:
> >
> >> The issue with r92su is: The driver is ready, but it's fundamentally
> >                                        ^^^^^^^^
> >> incompatible with the rtlwifi framework and mac80211.
> >
> > _anything_ is better than a staging driver.
> >
> > There are distributions that don't build staging drivers.
> 
> As a result, they force their users to build out-of-tree drivers!
> 
> > So, please, replace and delete staging/rtl8712 with r92su.
> 
> You seem not to understand. Any new wireless driver that does not use mac80211 
> *must* go into staging. AFAIK, that rule is absolute, and r92su cannot go into 
> the regular wireless tree.

Be careful ;-). mac80211 is great for softmac/umac/halfmac/semimac devices.
However the rtl8712 firmware interface is fullmac-like, so it needs cfg80211.
... and r92su uses cfg80211 exclusively. There's no more WEXT or realtek ioctl
legacy API support.

Regards,

Christian
