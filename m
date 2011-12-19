Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:33959 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752287Ab1LSVZM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 16:25:12 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: Rodriguez Luis <rodrigue@qca.qualcomm.com>
Cc: mcgrof@infradead.org, linux-wireless@vger.kernel.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 00/15] initvals: fix various errors and warnings
Date: Mon, 19 Dec 2011 22:24:45 +0100
Message-Id: <1324329900-3923-1-git-send-email-juhosg@openwrt.org> (sfid-20111219_222515_856768_B088E103)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch set fixes a build error, a typo and a copy&paste error.
It also fixes several compiler warnings. Additionally, it adds two 
helper scripts.

Gabor Juhos (15):
  initvals: add missing include for ar9330
  initvals: fix typos in usage text
  initvals: fix copy&paste error
  initvals: add ar9485_initvals.h to ATH9K_DEPS
  initvals: add checksums for AR9330 1.[12]
  initvals: add checksums for ar9580
  initvals: allow to use additional CFLAGS
  initvals: remove unused variable
  initvals: fix printf format warnings
  initvals: fix type of the second argument of 'main'
  initvals: include <string.h> to make gcc happy
  initvals: make 'print_initvals_family' static void
  initvals: use private chksum variables in INI_PRINT* macros
  initvals: add a script for simplifying checksum verification
  initvals: add script for regenerating ath9k header files

 Makefile              |    8 +-
 ar9330_1p2_initvals.h | 1080 +++++++++++++++++++++++++++++++++++++++++++++++++
 checksums.txt         |   55 +++
 gen_ath9k_headers.sh  |   36 ++
 initvals.c            |   31 +-
 verify_checksums.sh   |   40 ++
 6 files changed, 1226 insertions(+), 24 deletions(-)
 create mode 100644 ar9330_1p2_initvals.h
 create mode 100755 gen_ath9k_headers.sh
 create mode 100755 verify_checksums.sh

-- 
1.7.2.1

