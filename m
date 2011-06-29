Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:51174 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755867Ab1F2NJi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 09:09:38 -0400
Date: Wed, 29 Jun 2011 16:09:10 +0300
From: Jouni Malinen <j@w1.fi>
To: Michel Alexandre Salim <salimma@fedoraproject.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: Re: [PATCH] ath9k: add module option for disabling 11n
 functionality
Message-ID: <20110629130910.GA2688@jm.kir.nu> (sfid-20110629_150941_636689_CF52A54C)
References: <4E0A2F8A.8010102@fedoraproject.org>
 <20110628215757.GA14975@jm.kir.nu>
 <4E0AE8C1.9090809@fedoraproject.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E0AE8C1.9090809@fedoraproject.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 29, 2011 at 10:56:33AM +0200, Michel Alexandre Salim wrote:
> I agree with you and Adrian; it should ideally be in the 802.11
> stack. But as Ben noted, it does have a useful purpose -- for
> debugging.
> 
> If the maintainers are agreeable to a shared mac80211 mechanism,
> which is the preferred way to handle this -- get this in, then
> refactor *both* iwlagn and ath9k to use it, or to implement a shared
> mechanism, demonstrate it with ath9k, then fix iwlagn later?

I don't follow this.. Why would we get this into ath9k first if the more
appropriate way of doing this would be to modify mac80211 in the first
place. I see no point in doing driver specific hacks for this unless
there really is some driver specific issues that are being worked around
and that does not seem to be the case here.

As far as being able to disable 802.11n in general is concerned, it
would much better to do that as a parameter for the connection (e.g.,
new nl80211 attribute for NL80211_CMD_ASSOCIATE) rather than a module
parameter. This workaround seems to be needed with some APs and global
disabling of 802.11n does not sound like the ideal mechanism for that.

-- 
Jouni Malinen                                            PGP id EFC895FA
