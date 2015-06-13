Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.osadl.org ([62.245.132.105]:60799 "EHLO www.osadl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750853AbbFMKwd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Jun 2015 06:52:33 -0400
From: Nicholas Mc Guire <hofrat@osadl.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
	Kalle Valo <kvalo@codeaurora.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Randy Dunlap <rdunlap@infradead.org>,
	Masanari Iida <standby24x7@gmail.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [BUG ?] rtlwifi: rtl8723be: condition with no effect
Date: Sat, 13 Jun 2015 12:43:31 +0200
Message-Id: <1434192211-5855-1-git-send-email-hofrat@osadl.org> (sfid-20150613_125239_167886_0904D1A6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Nicholas Mc Guire <hofrat@osadl.org>                                      

scanning for trivial bug-patters with coccinelle spatches returned:
./drivers/net/wireless/rtlwifi/rtl8723be/dm.c:886
	WARNING: condition with no effect (if branch == else)

Added in 'commit a619d1abe20c ("rtlwifi: rtl8723be: Add new driver")'

drivers/net/wireless/rtlwifi/rtl8723be/dm.c - line numbers from 4.1-rc7
886         if (thermalvalue > rtlefuse->eeprom_thermalmeter)                  
887                 rtl8723be_dm_tx_power_track_set_power(hw, BBSWING, 0,
888						 	index_for_channel);
889         else
890                 rtl8723be_dm_tx_power_track_set_power(hw, BBSWING, 0,
891							index_for_channel);

Can't figure out what the intent of this condition is but it currently has
no effect as if == else and this most likely is not the intent.

thx!
hofrat
