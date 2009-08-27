Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1050 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbZH0D3F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 23:29:05 -0400
Date: Wed, 26 Aug 2009 23:27:40 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Pavel Roskin <proski@gnu.org>
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH 4/4] ath5k: add hardware CCMP encyption support
Message-ID: <20090827032740.GA28375@hash.localnet>
References: <1251169233-24169-1-git-send-email-me@bobcopeland.com> <1251169233-24169-5-git-send-email-me@bobcopeland.com> <1251338971.17295.17.camel@mj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1251338971.17295.17.camel@mj>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 26, 2009 at 10:09:31PM -0400, Pavel Roskin wrote:
> On Mon, 2009-08-24 at 23:00 -0400, Bob Copeland wrote:
> > +	ah->ah_aes_support =
> > +		(ee->ee_version >= AR5K_EEPROM_VERSION_5_0 &&
> > +		 !AR5K_EEPROM_AES_DIS(ee->ee_misc5) &&
> > +		 (ah->ah_mac_version > (AR5K_SREV_AR5212 >> 4) ||
> > +		  (ah->ah_mac_version == (AR5K_SREV_AR5212 >> 4) &&
> > +		   ah->ah_mac_revision >= (AR5K_SREV_AR5211 >> 4))));
> 
> The above use of ah->ah_mac_revision is clearly incorrect.  You are
> comparing a revision with a symbol for a version.

Well, this is exactly what legacy-hal does... so blame atheros :)

But yeah, we can just change it to look directly at the mac srev
since the revision check is confusing and the whole thing is needlessly
complex.

-- 
Bob Copeland %% www.bobcopeland.com

