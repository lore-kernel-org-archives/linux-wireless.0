Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49798 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253AbYCQV2T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 17:28:19 -0400
Subject: Re: [ipw3945-devel] [PATCH 1/5] mac80211: allows driver to request
	a Phase 2 key
From: Dan Williams <dcbw@redhat.com>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1ba2fa240803170320i4805e055ofebbbd9928a59354@mail.gmail.com>
References: <1205366762-12828-1-git-send-email-reinette.chatre@intel.com>
	 <1205366762-12828-2-git-send-email-reinette.chatre@intel.com>
	 <1205591906.15910.44.camel@johannes.berg>
	 <1ba2fa240803161721q5d01bve2292f99d3fe9eb8@mail.gmail.com>
	 <1205747912.1614.19.camel@johannes.berg>
	 <1ba2fa240803170320i4805e055ofebbbd9928a59354@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 17 Mar 2008 17:23:28 -0400
Message-Id: <1205789008.9583.12.camel@localhost.localdomain> (sfid-20080317_220849_790634_283B955E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-03-17 at 12:20 +0200, Tomas Winkler wrote:
> On Mon, Mar 17, 2008 at 11:58 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> >
> >  > >  Also, looking at what you do here, I found this comment:
> >  > >         /* FIXME: need to differenciate between static and dynamic key
> >  > >          * in the level of mac80211 */
> >  > >         static_key = !iwl4965_is_associated(priv);
> >  > >
> >  > >  I think that is pretty bogus because there isn't really a distinction
> >  > >  between dynamic and static keys, what's the reason for differentiating
> >  > >  in the driver? Also, the driver will do rather odd things when
> >  > >   * associate
> >  > >   * set a key
> >  > >   * disassociate
> >  > >   * delete the key
> >  > >
> >  >
> >  > This is actually quite a bug in mac80211. There is substantial
> >  > difference between dynamic and static key.
> >  > While static key  is used for crypto of all stations in BSS. Dynamic
> >  > key is also called pairwise key and is generated for 'pair'
> >
> >  Gee, can you then please stick to terminology used in the spec so other
> >  people can understand it?
> 
> What spec. ieee80211i. WPA, WPA2? .
> 
> >
> >  > Currently mac80211 set static key with broadcast address which iis
> >  > wrong cause driver cannot distinguish whether this key is
> >  > multicast/broadcast dynamic key or a static key. Shell it use it for
> >  > all traffic or only for mcast/bcast? Who can tell?
> >
> >  Actually, you're making it look like a much larger problem than it is.
> >  If you assume anything WEP is a "static key" and everything else is a
> >  "dynamic key" (using your terminology), the only problem will be with
> >  dynamic WEP, and even then it's not really a problem because as far as I
> >  understand even dynamic WEP doesn't distinguish between group and
> >  pairwise keys.
> 
> This is incorrect.  WPA enable using WEP as dynamic key and this
> setting is very common.
> WEP key is enabled for legacy stations this force also broadcast to be
> WEP.  This setup is still quite common.

Also sort of wrong; there are plenty of situations where the AP can be
put into essentially Dynamic WEP mode (I actually test this quite often
since there are a lot of people who use it) where it is still backed by
RADIUS but uses only WEP as the cipher and does _NOT_ broadcast WPA/RSN
information elements at all.

The _only_ guarantee you have for Dynamic WEP is that the privacy bit is
set to 1.  Here's an iwlist dump for such a configuration, taken with an
ipw2200, so it would be reporting WPA/RSN IEs if there were any, but
there aren't:

          Cell 30 - Address: 00:1A:xx:xx:xx:xx
                    ESSID:"foobar"
                    Protocol:IEEE 802.11bg
                    Mode:Master
                    Frequency:2.422 GHz (Channel 3)
                    Encryption key:on
                    Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 6 Mb/s; 9 Mb/s
                              11 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s; 36 Mb/s
                              48 Mb/s; 54 Mb/s
                    Quality=82/100  Signal level=-16 dBm  
                    Extra: Last beacon: 35ms ago

Looks like static WEP, but it's actually a Cisco AIR-AP1131AG backed by
RADIUS using EAP-TLS.

Unfortunately for dynamic WEP, as a user you simply have to _know_ that
the AP is using one of:

- Open System auth
- Shared Key auth
- WEP 104
- WEP 40
- LEAP
- Dynamic WEP

since it doesn't beacon, you're just fucked unless your sysadmin tells
you what the AP is doing.  Yay for WEP.

Dan

> 
> >
> >  > Other difference while there can be 4 static key installed that the
> >  > same time possible switching between indexes  There can be only one
> >  > dynamic key per station if you also consider mcast/bcast station to be
> >  > an entity. (TKIP actally uses different  key index for bcast but
> >  > that's just little execption)
> >  > The terminology which is used is also wrong and I guess this is just
> >  > wrong interpretation of  old implementation - 'default key' is used
> >  > for static key. Key mapping key is used for dynamic keys.
> >
> >  I don't think I understand the last paragraph?
> 
> Nothing imporatant just that term 'default key' is used usually on in
> context of static/legacy WEP key
> while term 'key mapping key' is used for what I call dynamic key.
> 
> >
> >  In any case, actual TX key selection is done by mac80211 anyway, so
> >  you're never interested in that. Only RX key selection is interesting to
> >  the driver, and as far as I can tell it ought to work if you simply
> >  always use the broadcast address key when it's WEP, and otherwise the
> >  pairwise keys and/or the broadcast key for bc/mc frames.
> 
> Nothing to add to just that the assumption about WEP and broadcast is wrong.
> 
> >  Note that there's another case in AP mode where bc/mc keys are TX-only,
> >  those are added with a zeroed MAC address.
> 
> I would prefer also in this case a clear flag rather then playing with
> ambiguity of destination address.
> 
> >  johannes
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

