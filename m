Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eusmtp01.atmel.com ([212.144.249.243]:10241 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbbK0GrJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Nov 2015 01:47:09 -0500
From: Glen Lee <glen.lee@atmel.com>
To: <gregkh@linuxfoundation.org>
CC: <devel@driverdev.osuosl.org>, <linux-wireless@vger.kernel.org>,
	<tony.cho@atmel.com>, <glen.lee@atmel.com>, <leo.kim@atmel.com>,
	<austin.shin@atmel.com>, <adel.noureldin@atmel.com>,
	<adham.abozaeid@atmel.com>, <Nicolas.FERRE@atmel.com>
Subject: [PATCH 0/3] clean up interface information structure
Date: Fri, 27 Nov 2015 15:50:30 +0900
Message-ID: <1448607033-25354-1-git-send-email-glen.lee@atmel.com> (sfid-20151127_074713_527325_17491A67)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series combines perInterface_wlan_t and struct wilc_vif. vif of
struct wilc can be the pointer of net device private data with
perInterface_wlan_t. As a conseqeunce, there will be one interface information
structure wilc_vif.

Glen Lee (3):
  staging: wilc1000: move perInterface_wlan_t to wilc_vif
  staging: wilc1000: change vif to pointer to refence real private data
  staging: wilc1000: remove duplicate netdev

 drivers/staging/wilc1000/host_interface.c         |   6 +-
 drivers/staging/wilc1000/linux_wlan.c             | 307 +++++++++++-----------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 220 ++++++++--------
 drivers/staging/wilc1000/wilc_wfi_netdevice.h     |  22 +-
 drivers/staging/wilc1000/wilc_wlan.c              |  60 ++---
 5 files changed, 305 insertions(+), 310 deletions(-)

-- 
1.9.1

