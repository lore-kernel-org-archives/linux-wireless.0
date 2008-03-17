Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.239]:38580 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbYCQKUE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 06:20:04 -0400
Received: by wr-out-0506.google.com with SMTP id c48so3874885wra.1
        for <linux-wireless@vger.kernel.org>; Mon, 17 Mar 2008 03:20:03 -0700 (PDT)
Message-ID: <1ba2fa240803170320i4805e055ofebbbd9928a59354@mail.gmail.com> (sfid-20080317_102009_990752_9E4E1DAA)
Date: Mon, 17 Mar 2008 12:20:01 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [ipw3945-devel] [PATCH 1/5] mac80211: allows driver to request a Phase 2 key
Cc: "Reinette Chatre" <reinette.chatre@intel.com>,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1205747912.1614.19.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1205366762-12828-1-git-send-email-reinette.chatre@intel.com>
	 <1205366762-12828-2-git-send-email-reinette.chatre@intel.com>
	 <1205591906.15910.44.camel@johannes.berg>
	 <1ba2fa240803161721q5d01bve2292f99d3fe9eb8@mail.gmail.com>
	 <1205747912.1614.19.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 17, 2008 at 11:58 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>  > >  Also, looking at what you do here, I found this comment:
>  > >         /* FIXME: need to differenciate between static and dynamic key
>  > >          * in the level of mac80211 */
>  > >         static_key = !iwl4965_is_associated(priv);
>  > >
>  > >  I think that is pretty bogus because there isn't really a distinction
>  > >  between dynamic and static keys, what's the reason for differentiating
>  > >  in the driver? Also, the driver will do rather odd things when
>  > >   * associate
>  > >   * set a key
>  > >   * disassociate
>  > >   * delete the key
>  > >
>  >
>  > This is actually quite a bug in mac80211. There is substantial
>  > difference between dynamic and static key.
>  > While static key  is used for crypto of all stations in BSS. Dynamic
>  > key is also called pairwise key and is generated for 'pair'
>
>  Gee, can you then please stick to terminology used in the spec so other
>  people can understand it?

What spec. ieee80211i. WPA, WPA2? .

>
>  > Currently mac80211 set static key with broadcast address which iis
>  > wrong cause driver cannot distinguish whether this key is
>  > multicast/broadcast dynamic key or a static key. Shell it use it for
>  > all traffic or only for mcast/bcast? Who can tell?
>
>  Actually, you're making it look like a much larger problem than it is.
>  If you assume anything WEP is a "static key" and everything else is a
>  "dynamic key" (using your terminology), the only problem will be with
>  dynamic WEP, and even then it's not really a problem because as far as I
>  understand even dynamic WEP doesn't distinguish between group and
>  pairwise keys.

This is incorrect.  WPA enable using WEP as dynamic key and this
setting is very common.
WEP key is enabled for legacy stations this force also broadcast to be
WEP.  This setup is still quite common.


>
>  > Other difference while there can be 4 static key installed that the
>  > same time possible switching between indexes  There can be only one
>  > dynamic key per station if you also consider mcast/bcast station to be
>  > an entity. (TKIP actally uses different  key index for bcast but
>  > that's just little execption)
>  > The terminology which is used is also wrong and I guess this is just
>  > wrong interpretation of  old implementation - 'default key' is used
>  > for static key. Key mapping key is used for dynamic keys.
>
>  I don't think I understand the last paragraph?

Nothing imporatant just that term 'default key' is used usually on in
context of static/legacy WEP key
while term 'key mapping key' is used for what I call dynamic key.

>
>  In any case, actual TX key selection is done by mac80211 anyway, so
>  you're never interested in that. Only RX key selection is interesting to
>  the driver, and as far as I can tell it ought to work if you simply
>  always use the broadcast address key when it's WEP, and otherwise the
>  pairwise keys and/or the broadcast key for bc/mc frames.

Nothing to add to just that the assumption about WEP and broadcast is wrong.

>  Note that there's another case in AP mode where bc/mc keys are TX-only,
>  those are added with a zeroed MAC address.

I would prefer also in this case a clear flag rather then playing with
ambiguity of destination address.

>  johannes
>
