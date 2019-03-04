Return-Path: <SRS0=K+dv=RH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27822C43381
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 04:24:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAA93208E4
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 04:24:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbfCDEYy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 3 Mar 2019 23:24:54 -0500
Received: from bluehome.net ([96.66.250.149]:59004 "EHLO bluehome.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725938AbfCDEYx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 3 Mar 2019 23:24:53 -0500
X-Greylist: delayed 411 seconds by postgrey-1.27 at vger.kernel.org; Sun, 03 Mar 2019 23:24:53 EST
Received: from pc.lan (pc.lan [10.0.0.51])
        by bluehome.net (Postfix) with ESMTPSA id 697294B4065A;
        Sun,  3 Mar 2019 20:18:01 -0800 (PST)
From:   Jason Self <j@jxself.org>
To:     linux-wireless@vger.kernel.org
Cc:     chunkeey@gmail.com, Jason Self <j@jxself.org>
Subject: [PATCH] carl9170: remove include references to config.cmake
Date:   Sun,  3 Mar 2019 20:17:43 -0800
Message-Id: <20190304041743.32648-1-j@jxself.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The build scripts fail because config.cmake is no longer generated,
having been removed by Christian Lamparter in commit
786134321b6ef391f04409de1200482e7693284d. But: The include was not
updated, and the file was still expected to be present. This removes
the references to it in the CMakeLists.txt files.
---
 CMakeLists.txt        | 2 --
 carlfw/CMakeLists.txt | 1 -
 minifw/CMakeLists.txt | 1 -
 tools/CMakeLists.txt  | 2 --
 4 files changed, 6 deletions(-)

diff --git a/CMakeLists.txt b/CMakeLists.txt
index fb18f15..ebbdee3 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -5,8 +5,6 @@ project(carl9170)
 #if you don't want the full compiler output, remove the following line
 #set(CMAKE_VERBOSE_MAKEFILE ON)
 
-include("config.cmake")
-
 add_subdirectory(carlfw)
 
 if (CONFIG_CARL9170FW_BUILD_MINIBOOT)
diff --git a/carlfw/CMakeLists.txt b/carlfw/CMakeLists.txt
index 8647a75..ae540fd 100644
--- a/carlfw/CMakeLists.txt
+++ b/carlfw/CMakeLists.txt
@@ -3,7 +3,6 @@ cmake_minimum_required(VERSION 2.8)
 project(carl9170.fw)
 
 include("../extra/sh-elf-linux.cmake")
-include("../config.cmake")
 
 set(CARL9170_FW_ELF carl9170.elf)
 set(CARLFW_CFLAGS_WARNING "-W -Wall -Wextra -Wunreachable-code -Winline -Wlogical-op -Wno-packed-bitfield-compat -Winit-self -Wshadow -Wwrite-strings -Waggregate-return -Wstrict-prototypes -Wformat=2 -Wcast-align -Wmissing-format-attribute -Wmissing-prototypes -Wtype-limits -Wmissing-declarations -Wmissing-noreturn -Wredundant-decls -Wnested-externs -Wdisabled-optimization -Wpointer-arith -Wvolatile-register-var -Waddress -Wbad-function-cast -Wunsafe-loop-optimizations")
diff --git a/minifw/CMakeLists.txt b/minifw/CMakeLists.txt
index adf5e08..9e5ad26 100644
--- a/minifw/CMakeLists.txt
+++ b/minifw/CMakeLists.txt
@@ -3,7 +3,6 @@ cmake_minimum_required(VERSION 2.8)
 project(miniboot.fw)
 
 include("../extra/sh-elf-linux.cmake")
-include("../config.cmake")
 
 set(miniboot_src miniboot.S)
 set_source_files_properties(miniboot.S PROPERTIES LANGUAGE C)
diff --git a/tools/CMakeLists.txt b/tools/CMakeLists.txt
index 13262d6..8f6ac4a 100644
--- a/tools/CMakeLists.txt
+++ b/tools/CMakeLists.txt
@@ -8,8 +8,6 @@ endif (CONFIG_CARL9170FW_MAKE_RELEASE)
 
 set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/extra)
 
-include("../config.cmake")
-
 include_directories (../include/linux ../include/shared ../include lib include)
 add_subdirectory(lib)
 add_subdirectory(src)
-- 
2.20.1

