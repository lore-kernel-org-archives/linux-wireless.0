Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59172 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932984Ab2GFWUn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 18:20:43 -0400
Cc: <linux-wireless@vger.kernel.org>, <kvalo@qca.qualcomm.com>,
	<arend@broadcom.com>, <henry@logout.com>,
	<senthilb@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <johannes@sipsolutions.net>, <linville@tuxdriver.com>
Subject: [PATCH v3 1/3] cfg80211: add CONFIG_CFG80211_CERTIFICATION_ONUS
Date: Fri, 6 Jul 2012 15:20:24 -0700
Message-ID: <1341613226-11774-2-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20120707_002112_196994_4C78435A)
In-Reply-To: <1341613226-11774-1-git-send-email-rodrigue@qca.qualcomm.com>
References: <1341613226-11774-1-git-send-email-rodrigue@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>

This adds CONFIG_CFG80211_CERTIFICATION_ONUS which is to
be used for features / code which require a bit of work on
the system integrator's part to ensure that the system will
still pass 802.11 regulatory certification. This option is
also usable for researchers and experimenters looking to add
code in the kernel without impacting compliant code.

We'd use CONFIG_EXPERT alone but it seems that most standard
Linux distributions are enabling CONFIG_EXPERT already. This
allows us to define 802.11 specific kernel features under a
flag that is intended by design to be disabled by standard
Linux distributions, and only enabled by system integrators
or distributions that have done work to ensure regulatory
certification on the system with the enabled features.

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 net/wireless/Kconfig |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 4d2b1ec..fe4adb1 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -74,6 +74,27 @@ config CFG80211_REG_DEBUG
 
 	  If unsure, say N.
 
+config CFG80211_CERTIFICATION_ONUS
+	bool "cfg80211 certification onus"
+	depends on CFG80211 && EXPERT
+	default n
+	---help---
+	  You should disable this option unless you are both capable
+	  and willing to ensure your system will remain regulatory
+	  compliant with the features available under this option.
+	  Some options may still be under heavy development and
+	  for whatever reason regulatory compliance has not or
+	  cannot yet be verified. Regulatory verification may at
+	  times only be possible until you have the final system
+	  in place.
+
+	  This option should only be enabled by system integrators
+	  or distributions that have done work necessary to ensure
+	  regulatory certification on the system with the enabled
+	  features. Alternatively you can enable this option if
+	  you are a wireless researcher and are working in a controlled
+	  and approved environment by your local regulatory agency.
+
 config CFG80211_DEFAULT_PS
 	bool "enable powersave by default"
 	depends on CFG80211
-- 
1.7.10.rc1.22.gf5241

