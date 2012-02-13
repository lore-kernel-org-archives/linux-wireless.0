Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:48024 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754978Ab2BMEzY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Feb 2012 23:55:24 -0500
From: Jakub Kicinski <kubakici@wp.pl>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Jakub Kicinski <kubakici@wp.pl>
Subject: [PATCH v2 0/4] rt2x00: Update MCU operations during device initialization
Date: Mon, 13 Feb 2012 05:48:35 +0100
Message-Id: <1329108519-5342-1-git-send-email-kubakici@wp.pl> (sfid-20120213_055554_697482_186D4961)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update MCU operations during initialization of rt2800pci devices 
and remove related functions which we don't need any more. As a result 
following error should no longer show up on every boot/resume:

rt2800pci_mcu_status: Error - MCU request failed, no response from hardware

v2:
 * remove rt2800usb_set_state as well as rt2800pci_set_state
 * rearrange switch statements to do fall through instead of recursive 
   calls according to Stanislaw's comment

Jakub Kicinski (4):
  rt2800pci: remove rt2800pci_set_state function
  rt2800usb: remove rt2800usb_set_state function
  rt2800: Add documentation on MCU requests
  rt2800pci: Fix 'Error - MCU request failed' during initialization

 drivers/net/wireless/rt2x00/rt2800.h    |   14 +++++++-
 drivers/net/wireless/rt2x00/rt2800pci.c |   58 ++++++++++++++----------------
 drivers/net/wireless/rt2x00/rt2800usb.c |   28 +++++----------
 3 files changed, 49 insertions(+), 51 deletions(-)

-- 
1.7.7.6

