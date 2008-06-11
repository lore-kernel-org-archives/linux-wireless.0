Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:10798 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbYFKMyv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2008 08:54:51 -0400
Received: by py-out-1112.google.com with SMTP id p76so1391975pyb.10
        for <linux-wireless@vger.kernel.org>; Wed, 11 Jun 2008 05:54:50 -0700 (PDT)
Message-ID: <1ba2fa240806110554s7b1d2bfybd692ac61a89a758@mail.gmail.com> (sfid-20080611_145457_359605_3A9CCF22)
Date: Wed, 11 Jun 2008 15:54:49 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH RFC] mac80211_hwsim
Cc: "Jouni Malinen" <j@w1.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <90792e191e13c5c2955689833ca3118a.squirrel@secure.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080610105058.GA6961@jm.kir.nu>
	 <1213096575.3668.6.camel@johannes.berg>
	 <20080610123007.GB1571@tuxdriver.com>
	 <1213103469.3668.13.camel@johannes.berg>
	 <20080610152418.GD13267@tuxdriver.com>
	 <20080610183722.GA7377@jm.kir.nu>
	 <1213124444.3668.48.camel@johannes.berg>
	 <20080611065719.GB7377@jm.kir.nu>
	 <90792e191e13c5c2955689833ca3118a.squirrel@secure.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 11, 2008 at 3:07 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Jouni Malinen wrote:
>> That sounds better. net/wireless.h was bit confusing on this part since
>> it has the "filled by the core" notice only for
>> IEEE80211_RATE_MANDATORY_* flags, not for IEEE80211_RATE_ERP_G. Looks
>> like this should be added to the ERP flag, too.
>
> good point.
>
>> OK, I'll remove it. With the current bands this seems to be fine, but
>> how would that work with 10 MHz and 5 MHz channels? I haven't verified,
>> but I would assume they could use same center frequency with 20 MHz
>> channels..
>
> Yeah... that isn't really supported yet.
>

We've added support for FAT channels 40Mhz, but that uses negative
logic i.e. whether it's not supported. This is due to fact that FAT
channel may expand to above or bellow channel.
Isn't usage of  10Mhz and 5Mz being slowly deprecated anyway?

Tomas.
