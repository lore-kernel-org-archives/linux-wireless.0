Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:10284 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbYCTHJS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2008 03:09:18 -0400
Received: by fg-out-1718.google.com with SMTP id l27so710132fgb.17
        for <linux-wireless@vger.kernel.org>; Thu, 20 Mar 2008 00:09:16 -0700 (PDT)
Message-ID: <8704f27d0803200009q81922fcja6b769b8cc7194ae@mail.gmail.com> (sfid-20080320_070920_537300_A5630C2A)
Date: Thu, 20 Mar 2008 09:09:16 +0200
From: "Emmanuel Grumbach" <egrumbach@gmail.com>
To: "Jouni Malinen" <j@w1.fi>
Subject: Re: [ipw3945-devel] [PATCH 1/5] mac80211: allows driver to request a Phase 2 key
Cc: "Tomas Winkler" <tomasw@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <20080319201004.GC5308@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1205781593.16475.20.camel@johannes.berg>
	 <1205784255.16475.33.camel@johannes.berg>
	 <1ba2fa240803171327r4c817228kc4f248abf0a0cea@mail.gmail.com>
	 <20080318080435.GA5308@jm.kir.nu>
	 <1205831880.16475.43.camel@johannes.berg>
	 <20080318102344.GG5308@jm.kir.nu>
	 <8704f27d0803190942h19b5a9ebjd3b27537c30ef719@mail.gmail.com>
	 <20080319173922.GB5308@jm.kir.nu>
	 <1ba2fa240803191141y7feae800g607432f2e9628e37@mail.gmail.com>
	 <20080319201004.GC5308@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>  I haven't looked at what the current implementation does, but as far as
>  WEXT and SIOCSIWENCODEEXT is concerned, IW_ENCODE_EXT_GROUP_KEY flag
>  should be used to select which key is being configured. There is no
>  difference between "static/global" and "dynamic group" keys. The only
>  difference is between default and key-mapping (individual) keys.
>
>  Sure, the terminology here can be quite confusing, but as far as I can
>  tell, that IW_ENCODE_EXT_GROUP_KEY flag is all that is needed to
>  distinguish which key is being configured and configuring a single key
>  should not automatically change another one (even if the key index is
>  same which could, at least in theory, happen with key index 0 that can
>  be used both with default and key-mapping keys).
>

Ok, I tested this flag, this will be enough (AFAIK for the moment) to
distinguish
which key is being configured.
Regarding SIOCSIWENCODE, I understand that there is no need to support it
(at least wrt wpa_supplicant) since mac80211 supports SIOCSIWENCODEEXT
and wpa_supplicant won't send SIOCSIWENCODE if SIOCSIWENCODEEXT
call succeeds right ?

iwconfig sends SIOCSIWENCODE but AFAIK, iwconfig configs only default keys (or
broadcast (default key) as RFC 3580 calls it), so no possibility to be
mistaken here...

Thanks for you help !

>
>
>  --
>  Jouni Malinen                                            PGP id EFC895FA
>



-- 
Emmanuel Grumbach
egrumbach@gmail.com
