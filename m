Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:4307 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbYIZHGQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 03:06:16 -0400
Received: by yx-out-2324.google.com with SMTP id 8so142019yxm.1
        for <linux-wireless@vger.kernel.org>; Fri, 26 Sep 2008 00:06:15 -0700 (PDT)
Message-ID: <43e72e890809260006kfc833fdsccbe3f22b3ad4c56@mail.gmail.com> (sfid-20080926_090620_873947_CBB0BF41)
Date: Fri, 26 Sep 2008 00:06:15 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: Kernel panic in wireless-testing-2008-09-24 with rtl8187
Cc: "Tomas Winkler" <tomasw@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Hauke Mehrtens" <hauke@hauke-m.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <48DC51AF.6000900@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <48DBE5E8.2000507@hauke-m.de> <48DC0008.2070802@lwfinger.net>
	 <1ba2fa240809251436j500e1435ldf165b43451aa628@mail.gmail.com>
	 <48DC51AF.6000900@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 25, 2008 at 8:06 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
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

Actually wouldn't you get a stack trace here?

  Luis
