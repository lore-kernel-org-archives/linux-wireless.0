Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:61478 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751348AbbJTEuS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 00:50:18 -0400
Date: Tue, 20 Oct 2015 06:50:13 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Jean Delvare <jdelvare@suse.de>
Cc: linux-wireless@vger.kernel.org,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] NFC: pn544: Auto-select core module
Message-ID: <20151020045013.GC9764@zurbaran.home> (sfid-20151020_065027_542511_FC56F03A)
References: <20150925104936.3b526b68@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150925104936.3b526b68@endymion.delvare>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jean,

On Fri, Sep 25, 2015 at 10:49:36AM +0200, Jean Delvare wrote:
> As I understand it, the core nfc_pn544 module is useless without
> either the I2C or the MEI access module. So hide NFC_PN544 and
> select it automatically if either NFC_PN544_I2C or NFC_PN544_MEI is
> selected.
> 
> This avoids presenting NFC_PN544 when neither NFC_PN544_I2C nor
> NFC_PN544_MEI can be selected.
It also avoids building the core driver when no physical layer has been
selected.

All 3 patches applied to nfc-next, thanks.

Cheers,
Samuel.
