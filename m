Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48891 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755487AbaCNTaU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Mar 2014 15:30:20 -0400
Date: Fri, 14 Mar 2014 15:22:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: Sujith Manoharan <sujith@msujith.org>,
	linux-wireless@vger.kernel.org,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [PATCH 00/23] ath9k|ath9k_htc: move dups to common-beacon
Message-ID: <20140314192212.GD20339@tuxdriver.com> (sfid-20140314_203025_097337_EDB09642)
References: <1393704966-13985-1-git-send-email-linux@rempel-privat.de>
 <21266.37896.937680.416439@gargle.gargle.HOWL>
 <5312DD46.3030800@rempel-privat.de>
 <21266.58035.719712.344551@gargle.gargle.HOWL>
 <20140306184235.GA7788@tuxdriver.com>
 <5319978F.6060803@rempel-privat.de>
 <21273.40172.734118.220513@gargle.gargle.HOWL>
 <531DD589.1090109@rempel-privat.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <531DD589.1090109@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 10, 2014 at 04:08:57PM +0100, Oleksij Rempel wrote:
> Am 07.03.2014 11:18, schrieb Sujith Manoharan:
> > Oleksij Rempel wrote:
> >> Last response was about initvals, my patch set affect only beacon code.
> >> Since i don't plan to rewrite ath9k_htc from scratch, i would assume it
> >> will be better to continue this periodic clean work.
> > 
> > I didn't review the patches, but someone else needs to make sure that
> > nothing is broken in ath9k.
> 
> I use this code one week ind STA mode. But if you need more directed
> alternate testing, who is good candidate for this work?

I applied the series and attempted a build.  But...

  CC      drivers/net/wireless/ath/ath9k/tx99.o
In file included from include/linux/bitops.h:33:0,
                 from include/linux/kernel.h:10,
                 from include/linux/skbuff.h:17,
                 from include/linux/if_ether.h:23,
                 from include/linux/etherdevice.h:25,
                 from drivers/net/wireless/ath/ath9k/ath9k.h:20,
                 from drivers/net/wireless/ath/ath9k/tx99.c:17:
drivers/net/wireless/ath/ath9k/tx99.c: In function ‘ath9k_tx99_init’:
drivers/net/wireless/ath/ath9k/tx99.c:111:15: error: ‘SC_OP_INVALID’ undeclared (first use in this function)
  if (test_bit(SC_OP_INVALID, &sc->sc_flags)) {
               ^
/home/linville/git/wireless-next/arch/x86/include/asm/bitops.h:338:25: note: in definition of macro ‘test_bit’
  (__builtin_constant_p((nr))  \
                         ^
drivers/net/wireless/ath/ath9k/tx99.c:111:15: note: each undeclared identifier is reported only once for each function it appears in
  if (test_bit(SC_OP_INVALID, &sc->sc_flags)) {
               ^
/home/linville/git/wireless-next/arch/x86/include/asm/bitops.h:338:25: note: in definition of macro ‘test_bit’
  (__builtin_constant_p((nr))  \
                         ^
drivers/net/wireless/ath/ath9k/tx99.c:111:33: error: ‘struct ath_softc’ has no member named ‘sc_flags’
  if (test_bit(SC_OP_INVALID, &sc->sc_flags)) {
                                 ^
/home/linville/git/wireless-next/arch/x86/include/asm/bitops.h:339:30: note: in definition of macro ‘test_bit’
   ? constant_test_bit((nr), (addr)) \
                              ^
drivers/net/wireless/ath/ath9k/tx99.c:111:33: error: ‘struct ath_softc’ has no member named ‘sc_flags’
  if (test_bit(SC_OP_INVALID, &sc->sc_flags)) {
                                 ^
/home/linville/git/wireless-next/arch/x86/include/asm/bitops.h:340:30: note: in definition of macro ‘test_bit’
   : variable_test_bit((nr), (addr)))
                              ^
make[3]: *** [drivers/net/wireless/ath/ath9k/tx99.o] Error 1
make[2]: *** [drivers/net/wireless/ath/ath9k] Error 2
make[1]: *** [drivers/net/wireless/ath] Error 2
make: *** [drivers/net/wireless/] Error 2

I'll be backing this out for now...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
