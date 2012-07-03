Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17531 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab2GCXPV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 19:15:21 -0400
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <johannes@sipsolutions.net>, <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <kvalo@qca.qualcomm.com>,
	<arend@broadcom.com>, <henry@logout.com>,
	<senthilb@qca.qualcomm.com>,
	"Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [PATCH 0/4] wireless: certification onus and cell regulatory hint
Date: Tue, 3 Jul 2012 16:15:11 -0700
Message-ID: <1341357315-8053-1-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20120704_011525_412390_9C7E677D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@frijolero.org>

This is a second series on the wireless expert idea patches
with one additional patch added. As discussed the wireless expert
name really was not doing justice to the intent behind what we
wanted to convey and allow. The CONFIG_CFG80211_CERTIFICATION_ONUS
is what folks seemed to agree on, I've gone ahead and added some
lanaguage which I think represents the intent behind the option
clearly.

I've also added an extra patch which adds a new type of regulatory
hint which actually makes use of the new kernel configuration option
CONFIG_CFG80211_CERTIFICATION_ONUS. In this case the option is designed
to allow userspace to classify userspace regulatory hints either as
coming from a user or a cellular base station. If devices have been
tested with such a feature the driver could be annotated as such, this
typically may require a set of testing / perhaps some communication to
the firmware.

Open solutions obviously allow users to hack up their own code and
send random data to the kernel, however the intent behind the new
kernel option CONFIG_CFG80211_CERTIFICATION_ONUS is to allow a new
type of hint which we *do* want to treat differently in kernel space
and drivers. Linux distribtuions / system integrators can use this
new regulatory hint by classifying the regulatory hint using a new
attribute. Exactly how userspace propagates the cellular base station
hint to the kernel is outside the exact scope of this series, however,
I suspect userspace cell base station models could end up using dbus
signals to trigger an event to signal the respective regulatory hint.
Using something like geoclue would make sense.

An interesting side effect of supporting this type of new regulatory
hint is addressing which type of hints takes precedence: do we trust
the cell base station hint over an Access Point's country IE? In this
series that is what we do, we prefer the cell base station hint over
other hints mainly to also simplify the implementation and design.
This also has implications with as to what gets applied to the core
and to other drivers. For example the core will always trust the
cell base station hint if CONFIG_CFG80211_CERTIFICATION_ONUS was
enabled *but* a driver may wish to want to ignore these type of
hints. In such case then the core, with a cell base station hint
present, would not be passing along country IE hints. This soft of
corner case must be considered.

We must also consider what we do upon suspend / disconnect. We follow
the tradition of the existing implementation of how we handle
disconnect / suspend -- we reset the regulatory core to its default,
just as if we had booted a device for the first time. We do this given
that possible scenerio that you got last a cell base station hint
in Japan but resume the device in the US, in such cases you could
not initiate radiation on channel 13, for example.

The way this is implemented however is to disable this feature unless
both CONFIG_CFG80211_CERTIFICATION_ONUS *and* the driver explicitly
enable this feature. As such regressions should only be found by
those users using the new feature and willing to participate on
the development of the feature / idea or the cell base station
regulatory hint.

Luis R. Rodriguez (4):
  cfg80211: add CONFIG_CFG80211_CERTIFICATION_ONUS
  ath5k: replace modparam_all_channels with CONFIG_ATH5K_TEST_CHANNELS
  ath9k: make CONFIG_ATH9K_DFS_CERTIFIED depend on
    CFG80211_CERTIFICATION_ONUS
  cfg80211: add cellular base station regulatory hint support

 drivers/net/wireless/ath/ath5k/Kconfig |    8 +++
 drivers/net/wireless/ath/ath5k/base.c  |   17 +++---
 drivers/net/wireless/ath/ath9k/Kconfig |    2 +-
 include/linux/nl80211.h                |   28 ++++++++++
 include/net/regulatory.h               |    4 ++
 net/wireless/Kconfig                   |   21 ++++++++
 net/wireless/nl80211.c                 |   15 +++++-
 net/wireless/reg.c                     |   88 +++++++++++++++++++++++++++++---
 net/wireless/reg.h                     |    4 +-
 9 files changed, 171 insertions(+), 16 deletions(-)

-- 
1.7.10.rc1.22.gf5241

