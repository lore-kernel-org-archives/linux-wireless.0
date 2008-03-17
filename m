Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:1944 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbYCQAVP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Mar 2008 20:21:15 -0400
Received: by wa-out-1112.google.com with SMTP id v27so6061072wah.23
        for <linux-wireless@vger.kernel.org>; Sun, 16 Mar 2008 17:21:15 -0700 (PDT)
Message-ID: <1ba2fa240803161721q5d01bve2292f99d3fe9eb8@mail.gmail.com> (sfid-20080317_002121_342238_ED618816)
Date: Mon, 17 Mar 2008 02:21:14 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [ipw3945-devel] [PATCH 1/5] mac80211: allows driver to request a Phase 2 key
Cc: "Reinette Chatre" <reinette.chatre@intel.com>,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1205591906.15910.44.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1205366762-12828-1-git-send-email-reinette.chatre@intel.com>
	 <1205366762-12828-2-git-send-email-reinette.chatre@intel.com>
	 <1205591906.15910.44.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 15, 2008 at 4:38 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>  On Wed, 2008-03-12 at 17:05 -0700, Reinette Chatre wrote:
>  > From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>  >
>  > This patch makes the mac80211 able to send a ready phase2 key to the low
>  > level driver for TKIP encryption. Iwlwifi needs to get a phase2 key to
>  > encrypt TX packets in HW.
>
>
> > --- a/include/net/mac80211.h
>  > +++ b/include/net/mac80211.h
>  > @@ -287,6 +287,7 @@ struct ieee80211_tx_control {
>  >       u8 iv_len;              /* length of the IV field in octets */
>  >       u8 queue;               /* hardware queue to use for this frame;
>  >                                * 0 = highest, hw->queues-1 = lowest */
>  > +     u8 tkip_key[16];        /* generated phase2/phase1 key for hw TKIP */
>
>  I have to admit that I'm rather uncomfortable with adding this code to
>  the stack. Not only because that is a rather large field that most other
>  drivers will not use, but also because it doesn't cover the use case the
>  Broadcom driver needs (only phase 1 key generated). Also, I don't think
>  we should take the "push" model to the extreme, that will just
>  complicate things in the future.
>
>  As for the transmit path here, we can trivially export
>  ieee80211_tkip_gen_rc4key() and, because key_conf is embedded in struct
>  ieee80211_key, give it a key_conf parameter that the driver knows about
>  from set_key(). That way, the driver can call that function for each
>  packet instead of having the stack do that, it only has to keep track of
>  the keys which it will most likely anyway.

You might be right here we are investigating whether there are no
holes in this.

>  Also, looking at what you do here, I found this comment:
>         /* FIXME: need to differenciate between static and dynamic key
>          * in the level of mac80211 */
>         static_key = !iwl4965_is_associated(priv);
>
>  I think that is pretty bogus because there isn't really a distinction
>  between dynamic and static keys, what's the reason for differentiating
>  in the driver? Also, the driver will do rather odd things when
>   * associate
>   * set a key
>   * disassociate
>   * delete the key
>

This is actually quite a bug in mac80211. There is substantial
difference between dynamic and static key.
While static key  is used for crypto of all stations in BSS. Dynamic
key is also called pairwise key and is generated for 'pair'
Currently mac80211 set static key with broadcast address which iis
wrong cause driver cannot distinguish whether this key is
multicast/broadcast dynamic key or a static key. Shell it use it for
all traffic or only for mcast/bcast? Who can tell?
Other difference while there can be 4 static key installed that the
same time possible switching between indexes  There can be only one
dynamic key per station if you also consider mcast/bcast station to be
an entity. (TKIP actally uses different  key index for bcast but
that's just little execption)
The terminology which is used is also wrong and I guess this is just
wrong interpretation of  old implementation - 'default key' is used
for static key. Key mapping key is used for dynamic keys.

Thanks
Tomas
>  johannes
>
> -------------------------------------------------------------------------
>  This SF.net email is sponsored by: Microsoft
>  Defy all challenges. Microsoft(R) Visual Studio 2008.
>  http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
> _______________________________________________
>  Ipw3945-devel mailing list
>  Ipw3945-devel@lists.sourceforge.net
>  https://lists.sourceforge.net/lists/listinfo/ipw3945-devel
>
>
