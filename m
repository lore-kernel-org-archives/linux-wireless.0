Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:51839 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553AbYCQX0e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Mar 2008 19:26:34 -0400
Received: by wa-out-1112.google.com with SMTP id v27so6615404wah.23
        for <linux-wireless@vger.kernel.org>; Mon, 17 Mar 2008 16:26:33 -0700 (PDT)
Message-ID: <1ba2fa240803171626y33571613ud1c809159da711af@mail.gmail.com> (sfid-20080317_232644_967650_8E8F6F4A)
Date: Tue, 18 Mar 2008 01:26:33 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Dan Williams" <dcbw@redhat.com>
Subject: Re: [ipw3945-devel] [PATCH 1/5] mac80211: allows driver to request a Phase 2 key
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Reinette Chatre" <reinette.chatre@intel.com>,
	"Emmanuel Grumbach" <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <1205788005.9583.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1205366762-12828-1-git-send-email-reinette.chatre@intel.com>
	 <1ba2fa240803161721q5d01bve2292f99d3fe9eb8@mail.gmail.com>
	 <1205747912.1614.19.camel@johannes.berg>
	 <1ba2fa240803170320i4805e055ofebbbd9928a59354@mail.gmail.com>
	 <1205751455.1614.25.camel@johannes.berg>
	 <1ba2fa240803170540n2e6fb398p84abfb34e4124042@mail.gmail.com>
	 <1205758276.1614.45.camel@johannes.berg>
	 <1ba2fa240803170636t6158c0a8vb180f71352208548@mail.gmail.com>
	 <1205761758.1614.79.camel@johannes.berg>
	 <1205788005.9583.4.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
>  So the problem with this is, how does Dynamic WEP work here?  Dynamic
>  WEP uses 802.1x/EAP to rekey stations periodically just like
>  WPA[2]-Enterprise, but of courses uses WEP only.  It's not "static" WEP
>  as you guys have been talking about it (you could call static WEP
>  "WEP-PSK" if you like).
>
>  The problem here is that with WEXT, there's not a good way to
>  distinguish between the two.  Both static & dynamic WEP might look the
>  same to the driver when the call comes through SIWENCODE/SIWENCODEEXT.
>  So you've got to be careful here classifying all WEP key requests as
>  static.

Yes this two are not enough you need also specify the the key management method
via SIWEAUTH .

Tomas
