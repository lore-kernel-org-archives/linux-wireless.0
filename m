Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:35846 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987AbYCTHg7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2008 03:36:59 -0400
Date: Thu, 20 Mar 2008 09:36:11 +0200
From: Jouni Malinen <j@w1.fi>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [ipw3945-devel] [PATCH 1/5] mac80211: allows driver to request
	a Phase 2 key
Message-ID: <20080320073611.GD5308@jm.kir.nu> (sfid-20080320_073702_903286_76BAE9F8)
References: <1205784255.16475.33.camel@johannes.berg> <1ba2fa240803171327r4c817228kc4f248abf0a0cea@mail.gmail.com> <20080318080435.GA5308@jm.kir.nu> <1205831880.16475.43.camel@johannes.berg> <20080318102344.GG5308@jm.kir.nu> <8704f27d0803190942h19b5a9ebjd3b27537c30ef719@mail.gmail.com> <20080319173922.GB5308@jm.kir.nu> <1ba2fa240803191141y7feae800g607432f2e9628e37@mail.gmail.com> <20080319201004.GC5308@jm.kir.nu> <8704f27d0803200009q81922fcja6b769b8cc7194ae@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <8704f27d0803200009q81922fcja6b769b8cc7194ae@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 20, 2008 at 09:09:16AM +0200, Emmanuel Grumbach wrote:

> Regarding SIOCSIWENCODE, I understand that there is no need to support it
> (at least wrt wpa_supplicant) since mac80211 supports SIOCSIWENCODEEXT
> and wpa_supplicant won't send SIOCSIWENCODE if SIOCSIWENCODEEXT
> call succeeds right ?

Yes. It would probably be enough to just assume the SIOCSIWENCODE is
being used only for default keys. wpa_supplicant will always try to use
SIOCSIWENCODEEXT first and in case of mac80211, SIOCSIWENCODE won't be
used for setting keys.

-- 
Jouni Malinen                                            PGP id EFC895FA
