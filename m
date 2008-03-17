Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:27719 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbYCQNgG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 09:36:06 -0400
Received: by wa-out-1112.google.com with SMTP id v27so6379989wah.23
        for <linux-wireless@vger.kernel.org>; Mon, 17 Mar 2008 06:36:05 -0700 (PDT)
Message-ID: <1ba2fa240803170636t6158c0a8vb180f71352208548@mail.gmail.com> (sfid-20080317_133617_203955_0E5F79BB)
Date: Mon, 17 Mar 2008 15:36:05 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [ipw3945-devel] [PATCH 1/5] mac80211: allows driver to request a Phase 2 key
Cc: "Reinette Chatre" <reinette.chatre@intel.com>,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1205758276.1614.45.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1205366762-12828-1-git-send-email-reinette.chatre@intel.com>
	 <1205366762-12828-2-git-send-email-reinette.chatre@intel.com>
	 <1205591906.15910.44.camel@johannes.berg>
	 <1ba2fa240803161721q5d01bve2292f99d3fe9eb8@mail.gmail.com>
	 <1205747912.1614.19.camel@johannes.berg>
	 <1ba2fa240803170320i4805e055ofebbbd9928a59354@mail.gmail.com>
	 <1205751455.1614.25.camel@johannes.berg>
	 <1ba2fa240803170540n2e6fb398p84abfb34e4124042@mail.gmail.com>
	 <1205758276.1614.45.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
>  Huh ok. But how would the WEP legacy station be able to determine that?

Legacy user get the key written on 'positit' yellow paper :).

>  Or does it just try to use WEP and succeed? TBH, I was unaware that this
>  existed, this does make it a bit more of a problem than I thought then.
>

>  >
>  > On second thought is that AP has only TX group key while STA has only
>  > RX group key so I
>  > m not seeing here any need for flag.
>
>  Hm, well, I didn't really want to require the driver to keep track of
>  the current operating mode, so that's why I used 00:...:00 vs. FF:...:FF
>  for the group keys.

Isn't if on integer faster then comparing 6 bytes?

>
>  Is that really done though? I mean, does wpa_supplicant not also use
>  encodeext for WEP keys?
>
Unfortunately yes.
>
>  > /* IW_AUTH_PAIRWISE_CIPHER and IW_AUTH_GROUP_CIPHER values (bit field) */
>  > #define IW_AUTH_CIPHER_NONE   0x00000001
>  > #define IW_AUTH_CIPHER_WEP40  0x00000002
>  > #define IW_AUTH_CIPHER_TKIP   0x00000004
>  > #define IW_AUTH_CIPHER_CCMP   0x00000008
>  > #define IW_AUTH_CIPHER_WEP104 0x00000010
>  >
>  > It's not well defined in wext but we can at least define the interface
>  > from mac80211 point of view.
>
>  True. So what change do we need?
>
First of all we don't need 4 keys per station but for the whole
system. Even in AP mode with multiple SSID meaning multiple security
setting you cannot distinguish between networks in static WEP key
setting so 4 is enough.
Beside that you need place holder for group key. They might be
multiple groups key in case of multiple SSIDs in AP mode, iwlwifi
doesn't support it in HW but in general it is possible.

We need a flag in set_key which says whether the WEP key is static or not.


Actually second items is currently the show stopper for me the first
Item is just a cleanup.

Thanks
Tomas

>  johannes
>
