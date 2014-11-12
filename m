Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:53500 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbaKLAJO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 19:09:14 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <21602.42365.82080.843506@gargle.gargle.HOWL> (sfid-20141112_010917_609667_136A0591)
Date: Wed, 12 Nov 2014 05:40:37 +0530
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: ath9k-devel@qca.qualcomm.com, nbd@openwrt.org, patro@cs.wisc.edu,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/21] make spectral code common for both ath9k drivers
In-Reply-To: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
References: <1415260418-14321-1-git-send-email-linux@rempel-privat.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oleksij Rempel wrote:
> - makes spectral scan code common for both ath9k and ath9k_htc.
> - add spectral scan support to ath9k_htc.

This has been merged, but I am getting a build error.

../drivers/net/wireless/ath/ath9k/common-spectral.c:40:5: error: redefinition of ‘ath_cmn_process_fft’
 int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_priv, struct ieee80211_hdr *hdr,
     ^
In file included from ../drivers/net/wireless/ath/ath9k/common.h:27:0,
                 from ../drivers/net/wireless/ath/ath9k/ath9k.h:27,
                 from ../drivers/net/wireless/ath/ath9k/common-spectral.c:18:
../drivers/net/wireless/ath/ath9k/common-spectral.h:146:19: note: previous definition of ‘ath_cmn_process_fft’ was here
 static inline int ath_cmn_process_fft(struct ath_spec_scan_priv *spec_priv,
                   ^
../scripts/Makefile.build:257: recipe for target 'drivers/net/wireless/ath/ath9k/common-spectral.o' failed
make[10]: *** [drivers/net/wireless/ath/ath9k/common-spectral.o] Error 1
make[10]: *** Waiting for unfinished jobs....
  CC [M]  drivers/target/iscsi/iscsi_target_erl0.o
  CC      drivers/thermal/thermal_core.o
In file included from ../drivers/net/wireless/ath/ath9k/htc_hst.c:19:0:
../drivers/net/wireless/ath/ath9k/htc.h: In function ‘ath9k_htc_deinit_debug’:
../drivers/net/wireless/ath/ath9k/htc.h:632:74: warning: ‘return’ with a value, in function returning void
 static inline void ath9k_htc_deinit_debug(struct ath9k_htc_priv *priv) { return 0; };
                                                                          ^
../scripts/Makefile.build:402: recipe for target 'drivers/net/wireless/ath/ath9k' failed
make[9]: *** [drivers/net/wireless/ath/ath9k] Error 2
../scripts/Makefile.build:402: recipe for target 'drivers/net/wireless/ath' failed
make[8]: *** [drivers/net/wireless/ath] Error 2
make[8]: *** Waiting for unfinished jobs....

Sujith
