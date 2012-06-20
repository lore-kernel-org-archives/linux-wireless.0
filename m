Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39602 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab2FTHiV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2012 03:38:21 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1ShFUZ-0000eF-Nm
	for linux-wireless@vger.kernel.org; Wed, 20 Jun 2012 09:38:19 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/12] iwlwifi updates 2012-06-20
Date: Wed, 20 Jun 2012 09:38:02 +0200
Message-Id: <1340177894-12992-1-git-send-email-johannes@sipsolutions.net> (sfid-20120620_093832_603426_3B10F65A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

Please pull according to the request below -- I hope the inline
signature works for you, let me know if not.

I've included various updates to debugging and locking changes
to improve interrupt latency by not disabling IRQs so much
(all from Emmanuel), a few random improvements and a fix for
another bug introduced by my EEPROM refactoring.

Thanks!

johannes


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

The following changes since commit 67711c17fc8bcab8f9e92c49049b8356f9a557c1:

  iwlwifi: WARN only once when we have trouble in reclaim (2012-06-13 09:02:09 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git for-john

for you to fetch changes up to 8d40f4eebf43bd73aa7c6e06665fd7a26012f9c9:

  iwlwifi: remove sku field from hw_params (2012-06-20 08:42:21 +0200)

- ----------------------------------------------------------------
Emmanuel Grumbach (8):
      iwlwifi: check that we have enough bits to track the TX queues
      iwlwifi: print the scratch of all the buffers stuck in a queue
      iwlwifi: comment context requirements of the op_mode
      iwlwifi: disable BH before the call to iwl_op_mode_nic_error
      iwlwifi: don't disable interrupt in iwl_abort_notification_waits
      iwlwifi: don't disable interrupt while starting tx
      iwlwifi: protect use_ict with irq_lock
      iwlwifi: disable early power Off reset for all NICs

Johannes Berg (4):
      iwlwifi: delay ROC if doing internal reset scan
      iwlwifi: fix 11n_disable EEPROM refactoring regression
      iwlwifi: use minimal time for radio reset scan
      iwlwifi: remove sku field from hw_params

 drivers/net/wireless/iwlwifi/dvm/dev.h          |    2 --
 drivers/net/wireless/iwlwifi/dvm/devices.c      |   13 -------
 drivers/net/wireless/iwlwifi/dvm/lib.c          |    2 +-
 drivers/net/wireless/iwlwifi/dvm/mac80211.c     |   18 +++++++---
 drivers/net/wireless/iwlwifi/dvm/main.c         |   29 +++++++++++-----
 drivers/net/wireless/iwlwifi/dvm/scan.c         |   41 +++++++++++------------
 drivers/net/wireless/iwlwifi/iwl-eeprom-parse.c |    3 ++
 drivers/net/wireless/iwlwifi/iwl-notif-wait.c   |    5 ++-
 drivers/net/wireless/iwlwifi/iwl-op-mode.h      |   16 +++++----
 drivers/net/wireless/iwlwifi/pcie/rx.c          |   30 ++++++++---------
 drivers/net/wireless/iwlwifi/pcie/trans.c       |   19 ++++++-----
 11 files changed, 93 insertions(+), 85 deletions(-)
-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJP4X11AAoJEDBSmw7B7bqrZwYQAJ/AMVce+45kCIfPFPE3rf7d
3IQcCfPls6Q3xyHsgFVQLHxFXJuyLtBVyN3OotpdtPGmN/dEA+NfQyUCKK1gQxRL
gGSUbfTMJSsvdwWZMqv11BC/snJrLJotvqfTc3JdYxXnhJjdoD87thjxTKiYGjnE
J+p9jy/BPkqPrN14kgNhyy6rG16nu6JZuMZMCzN0MUZCowFKYyyVWzgcQEltr1mX
LVgdSfOajclPNl5g9hD2UPGOsqYGTpEWaEfF5dB0RZdEi25P+NzCuA5o5Lxgk7M3
BDhA7+/fKNIbYb1H+QIE4KK4DI3PZ7pdu/6DCGd3QUc9Wv2DshJawBHSZhnBmQfv
/RawwrLnCITwFxBdLmUbmC6AgenuRaXPjokKdD/pz3XY6k7C4wGll2uONgyHUYXR
d9J2UrfRT1dUnrNhPiFMTA5YiV31WEvg03//fV67KhnU48LlpFW+Nb/5WUcYmKTZ
KKaD5OcMTPtY4oFpUGbBHIqqyY4qSXrkSk+lu04+LRZuROgTc/UZy3ZI2eOdK0ui
7bqf6MKeQnWfFjo+xRnH8LQwHJMyVAbclSI2u2p1uC7lKsFysYFLaRMZZg5zuBst
i4sPNMqAhKzwSf2h2TQUgftP+jXuODj9akjkFGFanXL59xa/jtxfcSAxpz0XQS2/
AsZ+W/13Ym2/dFGVhwzc
=A5eF
-----END PGP SIGNATURE-----


