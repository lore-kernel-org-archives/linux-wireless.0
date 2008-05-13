Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:43582 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322AbYEMNLY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2008 09:11:24 -0400
Date: Tue, 13 May 2008 16:10:40 +0300
From: Jouni Malinen <j@w1.fi>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>,
	Dan Williams <dcbw@redhat.com>
Subject: Re: 11n + wpa_supplicant
Message-ID: <20080513131040.GG6309@jm.kir.nu> (sfid-20080513_151128_449685_E76C0457)
References: <8704f27d0805130118p6f597743sebed5a2cdb6d59cb@mail.gmail.com> <20080513122718.GA6309@jm.kir.nu> <1210682080.3646.73.camel@johannes.berg> <20080513125024.GD6309@jm.kir.nu> <8704f27d0805130603q798b1a2bw76319df1251e9e01@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8704f27d0805130603q798b1a2bw76319df1251e9e01@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 13, 2008 at 04:03:19PM +0300, Emmanuel Grumbach wrote:

> So, If I understand you well, we should pass the HT IE using IWEVGENIE
> during scan, and wpa_supplicant will detect the conflict between
> encryption method and HT, and will request association in legacy mode
> (or won't allow the encryption method according to what has
> precedence: security or 11n).
> 
> Am I correct ?

Yes, I would expect the driver/mac80211 to do exactly that. You can
actually pass full set of IEs received from Beacon/ProbeResp in one
IWEVGENIE event and wpa_supplicant will parse the IEs from that data and
there is no need for separate reporting of WPA/RSN IEs.

The current version of wpa_supplicant would ignore the HT IE, but it
sounds reasonable to add code there to take care of this new requirement
in .11n on limiting the available pairwise ciphers.

-- 
Jouni Malinen                                            PGP id EFC895FA
