Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:20790 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab2ALMzG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jan 2012 07:55:06 -0500
Cc: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Thirumalai Pachamuthu <tpachamu@qca.qualcomm.com>
From: Thirumalai Pachamuthu <tpachamu@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
Subject: [PATCH v2] ath6kl: Enable uAPSD support in AP mode
Date: Thu, 12 Jan 2012 18:21:38 +0530
Message-ID: <1326372699-6344-1-git-send-email-tpachamu@qca.qualcomm.com> (sfid-20120112_135509_632866_94A47735)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In addition to legacy power save, this patch adds support for 
uAPSD in AP mode.

When connected station goes into suspend state, the driver will
start queuing pkts in the separate queue (called uapsd queue)
until the station ask for it. 

V2 Changes:

* Since inline functions wmi_data_hdr_set_more_bit and wmi_data_hdr_set_eosp_bit
  are used in one place, removed those functions and added the function defination
  in the place required.
* Removed macros WMI_DATA_HDR_EOSP_MASK, WMI_DATA_HDR_MORE_MASK, WMI_DATA_HDR_MORE_SHIFT, 
  WMI_DATA_HDR_EOSP_SHIFT and added the MACRO WMI_DATA_HDR_MORE, WMI_DATA_HDR_EOSP.
* Added MACRO for the hardcoded values.
* Indendation issues are corrected in the function ath6kl_process_uapsdq
  ath6kl_process_psq.
* Fixed sparse errors.

I have taken care review comments given by Kalle in V2.

Thirumalai Pachamuthu (1):
  ath6kl: Add support for uAPSD

 drivers/net/wireless/ath/ath6kl/cfg80211.c |    6 +
 drivers/net/wireless/ath/ath6kl/core.h     |   10 +-
 drivers/net/wireless/ath/ath6kl/main.c     |    9 +-
 drivers/net/wireless/ath/ath6kl/txrx.c     |  253 ++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath6kl/wmi.c      |   62 ++++++-
 drivers/net/wireless/ath/ath6kl/wmi.h      |   41 ++++-
 6 files changed, 328 insertions(+), 53 deletions(-)

