Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.180]:31903 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367AbYCQTj4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 15:39:56 -0400
Received: by wa-out-1112.google.com with SMTP id v27so6524068wah.23
        for <linux-wireless@vger.kernel.org>; Mon, 17 Mar 2008 12:39:55 -0700 (PDT)
Message-ID: <1ba2fa240803171239l6b07ba4ch2b2aaca5e7fa0506@mail.gmail.com> (sfid-20080317_194000_062708_6D4A61DB)
Date: Mon, 17 Mar 2008 21:39:55 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [ipw3945-devel] [PATCH 1/5] mac80211: allows driver to request a Phase 2 key
Cc: "Reinette Chatre" <reinette.chatre@intel.com>,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1205781593.16475.20.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1205366762-12828-1-git-send-email-reinette.chatre@intel.com>
	 <1205747912.1614.19.camel@johannes.berg>
	 <1ba2fa240803170320i4805e055ofebbbd9928a59354@mail.gmail.com>
	 <1205751455.1614.25.camel@johannes.berg>
	 <1ba2fa240803170540n2e6fb398p84abfb34e4124042@mail.gmail.com>
	 <1205758276.1614.45.camel@johannes.berg>
	 <1ba2fa240803170636t6158c0a8vb180f71352208548@mail.gmail.com>
	 <1205761758.1614.79.camel@johannes.berg>
	 <1ba2fa240803171212s36f85306i6f47ed9fa725b90@mail.gmail.com>
	 <1205781593.16475.20.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>  > You need only one unicast key for pairwise key.  4 keys are used only
>  > for static WEP key.
>  > For pairwise/dynamic WEP and TKIP you use key index in the packet but
>  > it changes only when supplicant change the key it self. You don't have
>  > the key alive in driver.
>
>  No, that's not true, due to rekeying concerns you actually can have more
>  than one group key at the same time in the driver/hardware.

I wasn't aware of this race in rekeying. I will investigate this.
Anyhow rekeying can also happing also for unicast keys.

>
>  > BSS defines security setting which  defined by key management for
>  > pairwise and group key + cipher method for both .
>  > You can run multiple SSIDs over single single BSSID. This is done
>  > using VLANs
>
>  Actually, we don't support that in mac80211.
Last time I worked on AP project it worked. It was older mac hopefully
it's not totally broken

 And the way I understand
>  VLANs they are simply done by negotiating different group keys with
>  different groups of stations each forming a VLAN.

We are saying the same. That's okay.

>
>  > So you can maintain multiple security settings in for one
>  > AP.  However this is not possible when using static WEP since the key
>  > is global and the key is not attached to any address.
>  >
>  > There are more details into it I'm sorry if I'm not 100 clear here.
>  > The bottom line is that you don't need more 4 WEP keys both in AP and
>  > station mod. Same you need to maintain only one pairwise key for
>  > station both in AP and STA mode. In AP mode you need to maintain also
>  > one group key for each station because of the case of multiple SSIDs.
>
>  Except the group keys don't really matter for an AP since they're TX
>  only, which is why we add them with a zeroed MAC address and can only
>  select them for TX
.
Zero address again :)

>
>
>  > Nop. Still you  can have <WEP, WEP>  for <pairwise,group key> valid
>  > setting - This is not static key. The two keys may differ. Under your
>  > assumption the group key will override pairwise key
>
>  Hm, ok. So I suppose the only way to determine "static" right now would
>  be to check that no pairwise keys are configured at all.

I'm not sure if I follow here but I think the simples way to determine
if static key is set is to set static_key flag to 1. I don't see any
reason this can be directly detected from the configuration.

Tomas

>  johannes
>
