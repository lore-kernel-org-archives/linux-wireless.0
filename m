Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1C46C282C0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 15:22:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6861D218D0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 15:22:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=nifty.com header.i=@nifty.com header.b="0U85/4lT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbfAYPWy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 10:22:54 -0500
Received: from condef-04.nifty.com ([202.248.20.69]:28555 "EHLO
        condef-04.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726252AbfAYPWy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 10:22:54 -0500
Received: from conuserg-07.nifty.com ([10.126.8.70])by condef-04.nifty.com with ESMTP id x0PFJFp6031027
        for <linux-wireless@vger.kernel.org>; Sat, 26 Jan 2019 00:19:18 +0900
Received: from grover.tkatk1.zaq.ne.jp (zaqdadce369.zaq.ne.jp [218.220.227.105]) (authenticated)
        by conuserg-07.nifty.com with ESMTP id x0PFIASP009019;
        Sat, 26 Jan 2019 00:18:10 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-07.nifty.com x0PFIASP009019
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1548429492;
        bh=UjZn5mrVHgxUKzEuknpPlQFNQPWFnwzRirXQUCx7OAo=;
        h=From:To:Cc:Subject:Date:From;
        b=0U85/4lT/ZnAa9xa28dNJ90yRuM3vnUqe8/zfExsHB3uvdHmCvb82d/s/BuZfWZGm
         winqc+YlL4F9xzQvYAFbOJWEywjNYAiqpZ5YbChAtX2n18BFu+t31iBZW6II1KoRH1
         gYPbYX+mFVoyTXT9UyG7tJBZgFPlZKDmrVYQrKDQMh3Hxd9bMJmBQ0ljTOYB500VHz
         0paycTjufdwhKVWyIPzxv0NkYMGLdxyk6izJa8EiYE1Xnz6lzwro9cVcPsMWIsyrWU
         S86dv9UQ7sWCrR03VGwolNsyunvTgLoOR2ywzn8GKwsHRu7AJgEfGWqUtmixWABDU3
         tgVbgtU0zpSug==
X-Nifty-SrcIP: [218.220.227.105]
From:   Masahiro Yamada <yamada.masahiro@socionext.com>
To:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        brcm80211-dev-list.pdl@broadcom.com,
        Franky Lin <franky.lin@broadcom.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        netdev@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Hin-Tak Leung <htl10@users.sourceforge.net>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Herton Ronaldo Krzesinski <herton@canonical.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Wright Feng <wright.feng@cypress.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        brcm80211-dev-list@cypress.com, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH] net: wireless: prefix header search paths with $(srctree)/
Date:   Sat, 26 Jan 2019 00:18:00 +0900
Message-Id: <1548429480-22137-1-git-send-email-yamada.masahiro@socionext.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Currently, the Kbuild core manipulates header search paths in a crazy
way [1].

To fix this mess, I want all Makefiles to add explicit $(srctree)/ to
the search paths in the srctree. Some Makefiles are already written in
that way, but not all. The goal of this work is to make the notation
consistent, and finally get rid of the gross hacks.

Having whitespaces after -I does not matter since commit 48f6e3cf5bc6
("kbuild: do not drop -I without parameter").

I also removed one header search path in:

  drivers/net/wireless/broadcom/brcm80211/brcmutil/Makefile

I was able to compile without it.

[1]: https://patchwork.kernel.org/patch/9632347/

Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
---

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile | 4 ++--
 drivers/net/wireless/broadcom/brcm80211/brcmsmac/Makefile | 6 +++---
 drivers/net/wireless/broadcom/brcm80211/brcmutil/Makefile | 4 +---
 drivers/net/wireless/intel/iwlwifi/dvm/Makefile           | 2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/Makefile           | 2 +-
 drivers/net/wireless/realtek/rtl818x/rtl8180/Makefile     | 2 +-
 drivers/net/wireless/realtek/rtl818x/rtl8187/Makefile     | 2 +-
 7 files changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile
index 22fd95a..f7cf3e5 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/Makefile
@@ -16,8 +16,8 @@
 # CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 
 ccflags-y += \
-	-Idrivers/net/wireless/broadcom/brcm80211/brcmfmac	\
-	-Idrivers/net/wireless/broadcom/brcm80211/include
+	-I $(srctree)/$(src) \
+	-I $(srctree)/$(src)/../include
 
 obj-$(CONFIG_BRCMFMAC) += brcmfmac.o
 brcmfmac-objs += \
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/Makefile b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/Makefile
index ed83f33..482d773 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmsmac/Makefile
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmsmac/Makefile
@@ -16,9 +16,9 @@
 # CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 
 ccflags-y := \
-	-Idrivers/net/wireless/broadcom/brcm80211/brcmsmac \
-	-Idrivers/net/wireless/broadcom/brcm80211/brcmsmac/phy \
-	-Idrivers/net/wireless/broadcom/brcm80211/include
+	-I $(srctree)/$(src) \
+	-I $(srctree)/$(src)/phy \
+	-I $(srctree)/$(src)/../include
 
 brcmsmac-y := \
 	mac80211_if.o \
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmutil/Makefile b/drivers/net/wireless/broadcom/brcm80211/brcmutil/Makefile
index 256c91f..bb02c62 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmutil/Makefile
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmutil/Makefile
@@ -15,9 +15,7 @@
 # OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
 # CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 
-ccflags-y :=				\
-	-Idrivers/net/wireless/broadcom/brcm80211/brcmutil \
-	-Idrivers/net/wireless/broadcom/brcm80211/include
+ccflags-y := -I $(srctree)/$(src)/../include
 
 obj-$(CONFIG_BRCMUTIL)	+= brcmutil.o
 brcmutil-objs	= utils.o d11.o
diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/Makefile b/drivers/net/wireless/intel/iwlwifi/dvm/Makefile
index 702d42b..0486b17 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/Makefile
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/Makefile
@@ -11,4 +11,4 @@ iwldvm-objs		+= rxon.o devices.o
 iwldvm-$(CONFIG_IWLWIFI_LEDS) += led.o
 iwldvm-$(CONFIG_IWLWIFI_DEBUGFS) += debugfs.o
 
-ccflags-y += -I$(src)/../
+ccflags-y += -I $(srctree)/$(src)/../
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/Makefile b/drivers/net/wireless/intel/iwlwifi/mvm/Makefile
index 9ffd219..7d1b318 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/Makefile
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/Makefile
@@ -10,4 +10,4 @@ iwlmvm-$(CONFIG_IWLWIFI_LEDS) += led.o
 iwlmvm-y += tof.o
 iwlmvm-$(CONFIG_PM) += d3.o
 
-ccflags-y += -I$(src)/../
+ccflags-y += -I $(srctree)/$(src)/../
diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8180/Makefile b/drivers/net/wireless/realtek/rtl818x/rtl8180/Makefile
index 2966681..5d6b06d 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8180/Makefile
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8180/Makefile
@@ -2,4 +2,4 @@ rtl818x_pci-objs	:= dev.o rtl8225.o sa2400.o max2820.o grf5101.o rtl8225se.o
 
 obj-$(CONFIG_RTL8180)	+= rtl818x_pci.o
 
-ccflags-y += -Idrivers/net/wireless/realtek/rtl818x
+ccflags-y += -I $(srctree)/$(src)/..
diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8187/Makefile b/drivers/net/wireless/realtek/rtl818x/rtl8187/Makefile
index ff07491..95bac73 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8187/Makefile
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8187/Makefile
@@ -2,4 +2,4 @@ rtl8187-objs		:= dev.o rtl8225.o leds.o rfkill.o
 
 obj-$(CONFIG_RTL8187)	+= rtl8187.o
 
-ccflags-y += -Idrivers/net/wireless/realtek/rtl818x
+ccflags-y += -I $(srctree)/$(src)/..
-- 
2.7.4

