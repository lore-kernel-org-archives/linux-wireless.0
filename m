Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:24940 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbYCQTMs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 15:12:48 -0400
Received: by wa-out-1112.google.com with SMTP id v27so6513281wah.23
        for <linux-wireless@vger.kernel.org>; Mon, 17 Mar 2008 12:12:47 -0700 (PDT)
Message-ID: <1ba2fa240803171212s36f85306i6f47ed9fa725b90@mail.gmail.com> (sfid-20080317_191251_410798_1F966AFB)
Date: Mon, 17 Mar 2008 21:12:47 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [ipw3945-devel] [PATCH 1/5] mac80211: allows driver to request a Phase 2 key
Cc: "Reinette Chatre" <reinette.chatre@intel.com>,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1205761758.1614.79.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1205366762-12828-1-git-send-email-reinette.chatre@intel.com>
	 <1205591906.15910.44.camel@johannes.berg>
	 <1ba2fa240803161721q5d01bve2292f99d3fe9eb8@mail.gmail.com>
	 <1205747912.1614.19.camel@johannes.berg>
	 <1ba2fa240803170320i4805e055ofebbbd9928a59354@mail.gmail.com>
	 <1205751455.1614.25.camel@johannes.berg>
	 <1ba2fa240803170540n2e6fb398p84abfb34e4124042@mail.gmail.com>
	 <1205758276.1614.45.camel@johannes.berg>
	 <1ba2fa240803170636t6158c0a8vb180f71352208548@mail.gmail.com>
	 <1205761758.1614.79.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>  >
>  > Isn't if on integer faster then comparing 6 bytes?
>
>  Probably. Does it matter though? Setting keys isn't going to be
>  performance critical in any way.

Yes but at least you do IF on something that is real not hacking with address.
>
>  > >  Is that really done though? I mean, does wpa_supplicant not also use
>  > >  encodeext for WEP keys?
>  > >
>  > Unfortunately yes.
>
>  So that doesn't really help us either way, no?

What is happening in case of static WEP is that IW_AUTH_CIPHER_NONE
IW_ENCODE_ALG_WEP are set.
Which is enough.

>
>  > First of all we don't need 4 keys per station but for the whole
>  > system.
>
>  Not sure I understand this. You need pairwise (per-station) keys as well
>  as four default keys, no?

You need only one unicast key for pairwise key.  4 keys are used only
for static WEP key.
For pairwise/dynamic WEP and TKIP you use key index in the packet but
it changes only when supplicant change the key it self. You don't have
the key alive in driver.



>
>  > Even in AP mode with multiple SSID meaning multiple security
>  > setting you cannot distinguish between networks in static WEP key
>  > setting so 4 is enough.
>
>  Not sure I get what you're thinking here.

BSS defines security setting which  defined by key management for
pairwise and group key + cipher method for both .
You can run multiple SSIDs over single single BSSID. This is done
using VLANs So you can maintain multiple security settings in for one
AP.  However this is not possible when using static WEP since the key
is global and the key is not attached to any address.

There are more details into it I'm sorry if I'm not 100 clear here.
The bottom line is that you don't need more 4 WEP keys both in AP and
station mod. Same you need to maintain only one pairwise key for
station both in AP and STA mode. In AP mode you need to maintain also
one group key for each station because of the case of multiple SSIDs.

>
>  > Beside that you need place holder for group key. They might be
>  > multiple groups key in case of multiple SSIDs in AP mode, iwlwifi
>  > doesn't support it in HW but in general it is possible.
>
>  Well, no, because we can add multiple keys with a zeroed MAC address,
>  since we have the local MAC address in there as well. Also, in an AP,
>  these are only used for TX so it doesn't matter since mac80211 does the
>  key selection completely on its own.

See above. anyhow still don't like the trick with invalid address.

>
>  > We need a flag in set_key which says whether the WEP key is static or not.
>
>  Let's actually try to gather all the cases first.
>
>  Is this it?
>
>   * TKIP/CCMP/WEP group or pairwise key
>   * WEP legacy ('static') key

That's correct

>  where the first is completely covered by what we have now
Yes
and the
>  assumption is that if only WEP keys are present then it'll be a legacy
>  WEP key?
Nop. Still you  can have <WEP, WEP>  for <pairwise,group key> valid
setting - This is not static key. The two keys may differ. Under your
assumption the group key will override pairwise key

Tomas




>  johannes
>
