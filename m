Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:38249 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754787AbYEMMbc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 08:31:32 -0400
Date: Tue, 13 May 2008 15:30:48 +0300
From: Jouni Malinen <j@w1.fi>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>
Subject: Re: 11n + wpa_supplicant
Message-ID: <20080513123048.GB6309@jm.kir.nu> (sfid-20080513_143136_045286_12EBB35C)
References: <8704f27d0805130118p6f597743sebed5a2cdb6d59cb@mail.gmail.com> <1210667328.3646.24.camel@johannes.berg> <8704f27d0805130141s403167b8q49eecb645d0461c1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8704f27d0805130141s403167b8q49eecb645d0461c1@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 13, 2008 at 11:41:15AM +0300, Emmanuel Grumbach wrote:

> in mac80211 we perfectly know what the AP supports (in
> ieee80211_send_assoc, I can read the IEs from the AP) , that's no the
> issue here, the issue is what security alg the user will chose in the
> 4way. This decision affects the associate even though it occurs after
> the association

Unless you are talking about IBSS (which would not use association),
"the user" (as in the non-AP STA/Supplicant) does not select pairwise
cipher in 4-way handshake; this happens in (re)association request. Only
the AP/Authenticator is able to propose another cipher suite in 4-way
handshake if per-client security policy rejects use of whatever cipher
was selected during association (and I've not heard of anyone having
implemented this).
 
-- 
Jouni Malinen                                            PGP id EFC895FA
