Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:35615 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011AbYIZGmt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 02:42:49 -0400
Received: by fg-out-1718.google.com with SMTP id 19so548579fgg.17
        for <linux-wireless@vger.kernel.org>; Thu, 25 Sep 2008 23:42:46 -0700 (PDT)
Message-ID: <1ba2fa240809252342x4b85b7e3u8341bb96a03b95a7@mail.gmail.com> (sfid-20080926_084255_427594_3222C0DC)
Date: Fri, 26 Sep 2008 09:42:46 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: Kernel panic in wireless-testing-2008-09-24 with rtl8187
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Hauke Mehrtens" <hauke@hauke-m.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <48DC51AF.6000900@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <48DBE5E8.2000507@hauke-m.de> <48DC0008.2070802@lwfinger.net>
	 <1ba2fa240809251436j500e1435ldf165b43451aa628@mail.gmail.com>
	 <48DC51AF.6000900@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 26, 2008 at 6:06 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Tomas Winkler wrote:
>> wild guess try to revert:
>> 'mac80211: make master iface not wireless'
>
> You win the prize. Bisection shows that
> 84b0ba8ed0423a3c56a28e701b735daae3e15766 is first bad commit
>
> commit 84b0ba8ed0423a3c56a28e701b735daae3e15766
> Author: Johannes Berg <johannes@sipsolutions.net>
> Date:   Tue Sep 16 14:18:59 2008 +0200
>
>    mac80211: make master iface not wireless
>
>
> The actual crash is in the following routine from include/net/wireless.h:
>
> /**
>  * wiphy_priv - return priv from wiphy
>  */
> static inline void *wiphy_priv(struct wiphy *wiphy)
> {
>        BUG_ON(!wiphy);
>        return &wiphy->priv;
> }
>
> I'm still looking to see where it goes wrong.

What do you mean?  The root cause is written in the commit log.
Tomas
