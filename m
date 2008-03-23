Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:5780 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312AbYCWW2I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Mar 2008 18:28:08 -0400
Received: by wa-out-1112.google.com with SMTP id v27so3070447wah.23
        for <linux-wireless@vger.kernel.org>; Sun, 23 Mar 2008 15:28:07 -0700 (PDT)
Message-ID: <1ba2fa240803231528i4fc38343ifb49d44f5072c882@mail.gmail.com> (sfid-20080323_222814_154674_465D8FED)
Date: Mon, 24 Mar 2008 00:28:07 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: trigger ieee80211_sta_work after opening interface
Cc: "Jan Niehusmann" <jan@gondor.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Michael Wu" <flamingice@sourmilk.net>, "Jiri Benc" <jbenc@suse.cz>
In-Reply-To: <1206310595.16475.190.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080323192355.GA5773@x61s.gondor.com>
	 <1206310595.16475.190.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 24, 2008 at 12:16 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>  On Sun, 2008-03-23 at 20:23 +0100, Jan Niehusmann wrote:
>  > ieee80211_sta_work is disabled while network interface
>  > is down. Therefore, if you configure wireless parameters
>  > before bringing the interface up, these configurations are
>  > not yet effective and association fails.
>  >
>  > A workaround from userspace is calling a command like
>  > 'iwconfig wlan0 ap any' after the interface is brought up.
>  >
>  > To fix this behaviour, trigger execution of ieee80211_sta_work from
>  > ieee80211_open when in STA or IBSS mode.
>
>  What happens with this patch when you haven't set any configuration
>  items before bringing the interface up? We want it to do nothing, if
>  that behaviour is kept the patch should be fine.

Why should be possible to configure device when it's not up. Shouldn't
be there some order in which things are happening?

Thanks
Tomas

>  johannes
>
