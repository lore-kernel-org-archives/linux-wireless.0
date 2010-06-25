Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:33150 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932247Ab0FYSHm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jun 2010 14:07:42 -0400
Subject: Re: [PATCH 2/2] wl1251: fix ELP_CTRL register reads
From: Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: Bob Copeland <me@bobcopeland.com>, Kalle Valo <kvalo@adurom.com>,
	"John W.Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1277481694.2712.7.camel@gnutoo-laptop>
References: <1275693948-3189-1-git-send-email-notasas@gmail.com>
	 <1275693948-3189-2-git-send-email-notasas@gmail.com>
	 <AANLkTinqgUGCjCBzg8j7bXGY05EW3-jfW7vlnrvCuwRd@mail.gmail.com>
	 <1277124410.28895.23.camel@gnutoo-laptop>
	 <AANLkTimLKDqDn_97BbOYr1cdxbFdPvyTz_lxJ59LVJ1b@mail.gmail.com>
	 <1277145901.28895.29.camel@gnutoo-laptop>
	 <AANLkTildbagKqzTQbcZ8cT53s4L2OWpJ5fkBUTcejj0h@mail.gmail.com>
	 <1277249607.2233.270.camel@gnutoo-laptop>
	 <1277420940.28625.30.camel@gnutoo-laptop>
	 <AANLkTinGVsGRFZ5J06Y_s13TGjJcIRbm2ugfNfgSCIEw@mail.gmail.com>
	 <1277481694.2712.7.camel@gnutoo-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Jun 2010 20:06:51 +0200
Message-ID: <1277489211.2712.9.camel@gnutoo-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-06-25 at 18:01 +0200, Denis 'GNUtoo' Carikli wrote:
> [ 2132.599578] wl1251: cmd configure
> [ 2132.619567] wl1251: acx wake up conditions
> [ 2132.619628] wl1251: cmd configure
> [ 2132.639587] wl1251: cmd set ps mode
> [ 2132.640747] wl1251: sleep auth psm/elp
> [ 2132.640808] wl1251: acx sleep auth
> [ 2132.640808] wl1251: cmd configure
> [ 2132.650268] wl1251: elp work
> [ 2132.650299] wl1251: chip to elp
> [ 2133.239471] wl1251: IRQ
> [ 2133.239654] wl1251: IRQ work
> [ 2133.239654] wl1251: waking up chip from elp
> [ 2133.239715] wl1251: wakeup time: 0 ms
does it mean that here it works?
> [ 2133.239868] wl1251: intr: 0x3
> [ 2133.239929] wl1251: RX: FW +1
> [ 2133.239929] wl1251: RX counter: 7
> [ 2133.239959] wl1251: WL1251_ACX_INTR_RX0_DATA
> [ 2133.240081] wl1251: rx skb 0xc61c3480: 88 B 
> [ 2133.240203] wl1251: WL1251_ACX_INTR_TX_RESULT
> [ 2133.240478] wl1251: tx status id 0 skb 0xc635f480 failures 0 rate
> 0x1
> status 0x0 ()
> [ 2133.251251] wl1251: elp work
> [ 2133.264434] mmc0:0001: error -110 reading SDIO_CCCR_INTx
> [ 2133.479278] wlan0: no IPv6 routers present
> [ 2134.269470] mmc0: Command CRC error
> [ 2134.269561] mmc0:0001: error -84 reading SDIO_CCCR_INTx
> [ 2135.284484] mmc0:0001: error -110 reading SDIO_CCCR_INTx
> [ 2136.289428] mmc0: Command CRC error
> [ 2136.289489] mmc0:0001: error -84 reading SDIO_CCCR_INTx
> [ 2137.304504] mmc0:0001: error -110 reading SDIO_CCCR_INTx
> [ 2138.309478] mmc0: Command CRC error
> [ 2138.309539] mmc0:0001: error -84 reading SDIO_CCCR_INTx
> [ 2139.324523] mmc0:0001: error -110 reading SDIO_CCCR_INTx
> [ 2140.329437] mmc0: Command CRC error
> [ 2140.329498] mmc0:0001: error -84 reading SDIO_CCCR_INTx
> [ 2141.344512] mmc0:0001: error -110 reading SDIO_CCCR_INTx
> [ 2142.349456] mmc0: Command CRC error
> [ 2142.349548] mmc0:0001: error -84 reading SDIO_CCCR_INTx
> [ 2143.364501] mmc0:0001: error -110 reading SDIO_CCCR_INTx
> [ 2144.369476] mmc0: Command CRC error
> [ 2144.369537] mmc0:0001: error -84 reading SDIO_CCCR_INTx
> [ 2145.384490] mmc0:0001: error -110 reading SDIO_CCCR_INTx
> [ 2146.389404] mmc0: Command CRC error
> [ 2146.389495] mmc0:0001: error -84 reading SDIO_CCCR_INTx
> [ 2147.404541] mmc0:0001: error -110 reading SDIO_CCCR_INTx
> [ 2148.409454] mmc0: Command CRC error
> [ 2148.409545] mmc0:0001: error -84 reading SDIO_CCCR_INTx
> [ 2149.424530] mmc0:0001: error -110 reading SDIO_CCCR_INTx
> [ 2150.429534] mmc0: Command CRC error
> [ 2150.429595] mmc0:0001: error -84 reading SDIO_CCCR_INTx
> [ 2151.444488] mmc0:0001: error -110 reading SDIO_CCCR_INTx
> [ 2152.449432] mmc0: Command CRC error
> [ 2152.449523] mmc0:0001: error -84 reading SDIO_CCCR_INTx
and that here it doesn't anymore?
> [ 2152.969360] wl1251: mac80211 config ch 7 psm off power 20
> [ 2152.969421] wl1251: waking up chip from elp
> [ 2152.989410] wl1251: wakeup time: 20 ms
> [ 2152.989440] wl1251: psm disabled
> [ 2152.989471] wl1251: leaving psm
> [ 2152.989471] wl1251: sleep auth cam 

Denis.


