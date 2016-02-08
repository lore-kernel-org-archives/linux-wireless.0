Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:35359 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbcBHTwG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2016 14:52:06 -0500
Received: by mail-ob0-f181.google.com with SMTP id xk3so166309156obc.2
        for <linux-wireless@vger.kernel.org>; Mon, 08 Feb 2016 11:52:06 -0800 (PST)
Subject: Re: rtlwifi: fix broken VHT support
To: Dan Carpenter <dan.carpenter@oracle.com>
References: <20160208182224.GC18802@mwanda>
Cc: linux-wireless@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <56B8F1E2.6050509@lwfinger.net> (sfid-20160208_205212_738447_5ADB6F65)
Date: Mon, 8 Feb 2016 13:52:02 -0600
MIME-Version: 1.0
In-Reply-To: <20160208182224.GC18802@mwanda>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/08/2016 12:22 PM, Dan Carpenter wrote:
> Hello Larry Finger,
>
> The patch d76d65fd2695: "rtlwifi: fix broken VHT support" from Feb 1,
> 2016, leads to the following static checker warning:
>
> 	drivers/net/wireless/realtek/rtlwifi/rc.c:144 _rtl_rc_rate_set_series()
> 	warn: impossible condition '(wireless_mode == 256) => (0-255 == 256)'
>
> drivers/net/wireless/realtek/rtlwifi/rc.c
>     135                  if (sgi_20 || sgi_40 || sgi_80)
>     136                          rate->flags |= IEEE80211_TX_RC_SHORT_GI;
>     137                  if (sta && sta->ht_cap.ht_supported &&
>     138                      ((wireless_mode == WIRELESS_MODE_N_5G) ||
>     139                       (wireless_mode == WIRELESS_MODE_N_24G)))
>     140                          rate->flags |= IEEE80211_TX_RC_MCS;
>     141                  if (sta && sta->vht_cap.vht_supported &&
>     142                      (wireless_mode == WIRELESS_MODE_AC_5G ||
>     143                       wireless_mode == WIRELESS_MODE_AC_24G ||
>     144                       wireless_mode == WIRELESS_MODE_AC_ONLY))
>                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Not possible.  sta_entry->wireless_mode is u8 and WIRELESS_MODE_AC_ONLY
> is 0x100.
>
>     145                          rate->flags |= IEEE80211_TX_RC_VHT_MCS;
>     146          }
>     147  }
>
>

Dan,

Thanks for the heads-up. Obviously, wireless_mode needs to be u16, but I will 
need some time to consider any side effects as the underlying variable in the 
private space is used by several of the rtlwifi family.

Larry


