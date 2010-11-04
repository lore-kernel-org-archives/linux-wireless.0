Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33176 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab0KDXZl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 19:25:41 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1011042251520.16015@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1011042251520.16015@swampdragon.chaosbits.net>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Fri, 5 Nov 2010 10:25:20 +1100
Message-ID: <AANLkTi=5Astx_7ifqZNFxwF4xMYPkEu7Z7oydeD5QrH6@mail.gmail.com>
Subject: Re: [PATCH] mac80211: Remove redundant checks for NULL before calls
 to crypto_free_cipher()
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 5, 2010 at 08:59, Jesper Juhl <jj@chaosbits.net> wrote:
> Hello,
>
> crypto_free_cipher() is a wrapper around crypto_free_tfm() which is a
> wrapper around crypto_destroy_tfm() and the latter can handle being passed
> a NULL pointer, so checking for NULL in the
> ieee80211_aes_key_free()/ieee80211_aes_cmac_key_free() wrappers around
> crypto_free_cipher() is pointless and just increase object code size
> needlesly and makes us execute extra test/branch instructions that we
> don't need.
> Btw; don't we have to many wrappers around wrappers ad nauseam here?

They do serve a documentation purpose: Maybe some of them could be
turned into static inline functions or something so the compiler
optimises them away.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
