Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.177]:9957 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640AbYCQXfo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 19:35:44 -0400
Received: by wa-out-1112.google.com with SMTP id v27so6618644wah.23
        for <linux-wireless@vger.kernel.org>; Mon, 17 Mar 2008 16:35:44 -0700 (PDT)
Message-ID: <1ba2fa240803171635l703f2fdcu9c51150e7a9b0405@mail.gmail.com> (sfid-20080317_233555_745077_46AA981C)
Date: Tue, 18 Mar 2008 01:35:44 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: [ipw3945-devel] [PATCH 1/5] mac80211: allows driver to request a Phase 2 key
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Reinette Chatre" <reinette.chatre@intel.com>,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1205789008.9583.12.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1205366762-12828-1-git-send-email-reinette.chatre@intel.com>
	 <1205366762-12828-2-git-send-email-reinette.chatre@intel.com>
	 <1205591906.15910.44.camel@johannes.berg>
	 <1ba2fa240803161721q5d01bve2292f99d3fe9eb8@mail.gmail.com>
	 <1205747912.1614.19.camel@johannes.berg>
	 <1ba2fa240803170320i4805e055ofebbbd9928a59354@mail.gmail.com>
	 <1205789008.9583.12.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>  Also sort of wrong; there are plenty of situations where the AP can be
>  put into essentially Dynamic WEP mode (I actually test this quite often
>  since there are a lot of people who use it) where it is still backed by
>  RADIUS but uses only WEP as the cipher and does _NOT_ broadcast WPA/RSN
>  information elements at all.
>
>  The _only_ guarantee you have for Dynamic WEP is that the privacy bit is
>  set to 1.  Here's an iwlist dump for such a configuration, taken with an
>  ipw2200, so it would be reporting WPA/RSN IEs if there were any, but
>  there aren't:
>
>           Cell 30 - Address: 00:1A:xx:xx:xx:xx
>                     ESSID:"foobar"
>                     Protocol:IEEE 802.11bg
>                     Mode:Master
>                     Frequency:2.422 GHz (Channel 3)
>                     Encryption key:on
>                     Bit Rates:1 Mb/s; 2 Mb/s; 5.5 Mb/s; 6 Mb/s; 9 Mb/s
>                               11 Mb/s; 12 Mb/s; 18 Mb/s; 24 Mb/s; 36 Mb/s
>                               48 Mb/s; 54 Mb/s
>                     Quality=82/100  Signal level=-16 dBm
>                     Extra: Last beacon: 35ms ago
>
>  Looks like static WEP, but it's actually a Cisco AIR-AP1131AG backed by
>  RADIUS using EAP-TLS.
>
>  Unfortunately for dynamic WEP, as a user you simply have to _know_ that
>  the AP is using one of:
>
>  - Open System auth
>  - Shared Key auth
>  - WEP 104
>  - WEP 40
>  - LEAP
>  - Dynamic WEP
>
>  since it doesn't beacon, you're just fucked unless your sysadmin tells
>  you what the AP is doing.  Yay for WEP.
>

I think we are addressing different problems. First of all our focus
is on mac80211 interpretation of WEP setting through WEXT rather then
how use know what security setting to chose.  Currently even when user
now how to configure the security setting a driver under mac80211 was
not able to distinguish what is static and what is dynamic WEP it was
blurred by mac80211.

The problem of distributing and guessing wireless profiles is a
different problem.  Unfortunately the whole wireleess stack is burden
by coexistence with legacy systems.

Tomas


>  Dan
>
>
>  >
>  > >
>  > >  > Other difference while there can be 4 static key installed that the
>  > >  > same time possible switching between indexes  There can be only one
>  > >  > dynamic key per station if you also consider mcast/bcast station to be
>  > >  > an entity. (TKIP actally uses different  key index for bcast but
>  > >  > that's just little execption)
>  > >  > The terminology which is used is also wrong and I guess this is just
>  > >  > wrong interpretation of  old implementation - 'default key' is used
>  > >  > for static key. Key mapping key is used for dynamic keys.
>  > >
>  > >  I don't think I understand the last paragraph?
>  >
>  > Nothing imporatant just that term 'default key' is used usually on in
>  > context of static/legacy WEP key
>  > while term 'key mapping key' is used for what I call dynamic key.
>  >
>  > >
>  > >  In any case, actual TX key selection is done by mac80211 anyway, so
>  > >  you're never interested in that. Only RX key selection is interesting to
>  > >  the driver, and as far as I can tell it ought to work if you simply
>  > >  always use the broadcast address key when it's WEP, and otherwise the
>  > >  pairwise keys and/or the broadcast key for bc/mc frames.
>  >
>  > Nothing to add to just that the assumption about WEP and broadcast is wrong.
>  >
>  > >  Note that there's another case in AP mode where bc/mc keys are TX-only,
>  > >  those are added with a zeroed MAC address.
>  >
>  > I would prefer also in this case a clear flag rather then playing with
>  > ambiguity of destination address.
>  >
>  > >  johannes
>  > >
>  > --
>  > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>  > the body of a message to majordomo@vger.kernel.org
>  > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
