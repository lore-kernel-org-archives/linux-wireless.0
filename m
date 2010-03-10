Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:64897 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756227Ab0CJEeR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Mar 2010 23:34:17 -0500
Subject: Re: [PATCH 2/2] compat-wireless: disable wl12xx if crc7 is not
 available
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20100310035414.28564.10870.stgit@mj.roinet.com>
References: <20100310035408.28564.65912.stgit@mj.roinet.com>
	 <20100310035414.28564.10870.stgit@mj.roinet.com>
Content-Type: text/plain
Date: Tue, 09 Mar 2010 23:34:16 -0500
Message-Id: <1268195656.10669.37.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-03-09 at 22:54 -0500, Pavel Roskin wrote:
> Signed-off-by: Pavel Roskin <proski@gnu.org>
> ---
>  config.mk |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)

Please disregards this patch, it goes too far.  wl1251_sdio still can be
compiled without crc7().

That's the second version (RFC):


compat-wireless: disable wl1251 SPI and wl1271 if crc7 is not available

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 config.mk |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/config.mk b/config.mk
index e5be3fd..f4f019f 100644
--- a/config.mk
+++ b/config.mk
@@ -386,7 +386,9 @@ endif # end of USB driver list
 ifneq ($(CONFIG_SPI_MASTER),)
 
 CONFIG_WL1251=m
+ifneq ($(CONFIG_CRC7),)
 CONFIG_WL1251_SPI=m
+endif
 CONFIG_P54_SPI=m
 
 ifdef CONFIG_COMPAT_KERNEL_27
@@ -449,7 +451,9 @@ CONFIG_ATH_COMMON=m
 
 CONFIG_WL12XX=y
 CONFIG_WL1251=m
+ifneq ($(CONFIG_CRC7),)
 CONFIG_WL1271=m
+endif
 
 ifdef CONFIG_COMPAT_KERNEL_27
 CONFIG_LIBERTAS=n

-- 
Regards,
Pavel Roskin
