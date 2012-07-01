Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:50543 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753178Ab2GAQzr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jul 2012 12:55:47 -0400
Message-ID: <1341161747.2032.25.camel@joe2Laptop> (sfid-20120701_185551_632945_B19FCCEC)
Subject: Re: [PATCH 60g v1 0/5] Infrastructure for 60g (802.11ad)
From: Joe Perches <joe@perches.com>
To: Vladimir Kondratiev <vkondrat@qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	"John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Sun, 01 Jul 2012 09:55:47 -0700
In-Reply-To: <3398883.J9mbiBD70h@lx-vladimir>
References: <1341125155-628-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1341141808.6603.1.camel@jlt3.sipsolutions.net>
	 <3398883.J9mbiBD70h@lx-vladimir>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2012-07-01 at 19:28 +0300, Vladimir Kondratiev wrote:
> On Sunday, July 01, 2012 01:23:28 PM Johannes Berg wrote:
> > Please fix indentation better :-)
> I am confused a bit. What is "proper" identation for this case?
> Immediately following code idents with 4 spaces:
> 
>                 if (cfg80211_disable_40mhz_24ghz &&
>                     band == IEEE80211_BAND_2GHZ &&
>                     sband->ht_cap.ht_supported) {
>                         sband->ht_cap.cap &= ~IEEE80211_HT_CAP_SUP_WIDTH_20_40;
>                         sband->ht_cap.cap &= ~IEEE80211_HT_CAP_SGI_40;
>                 }

Yes.

> This is what I did initially, to comply with surrounding code style.
> Fragment in question is:
> 
> 		if (WARN_ON((band != IEEE80211_BAND_60GHZ) &&
> 				!sband->n_bitrates))
> 			return -EINVAL;
> 
> 
> Should I ident line containing
> !sband->n_bitrates))
> with:
>  - 4 spaces as next code fragment,
>  - one tab (same level as 'return')
>  - 2 tabs (one level more then 'return')
>  - other (what?)

Align subsequent line to character after parenthesis depth.
Maximally fill with tabs, use 0 to 7 spaces to indent
		   1       23                            2
                   v       vv                            v
		if (WARN_ON((band != IEEE80211_BAND_60GHZ) &&
			    !sband->n_bitrates))

There is an unnecessary parenthesis here around the first
test and this is perhaps better written as:

		if (WARN_ON(band != IEEE80211_BAND_60GHZ &&
			    !sband->n_bitrates))

You could also use "scripts/checkpatch.pl --strict" and
it should tell you.


