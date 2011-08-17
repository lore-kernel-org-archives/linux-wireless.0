Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:36010 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893Ab1HQGeH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Aug 2011 02:34:07 -0400
From: "Elias, Ilan" <ilane@ti.com>
To: "aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>,
	"lauro.venancio@openbossa.org" <lauro.venancio@openbossa.org>,
	"samuel@sortiz.org" <samuel@sortiz.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Date: Wed, 17 Aug 2011 08:33:53 +0200
Subject: RE: [PATCH 1/4] NFC: Add NFC dev_up and dev_down control operations
Message-ID: <AC090B9732AB2B4DB7FF476E907FE6600131E1C412@dnce02.ent.ti.com> (sfid-20110817_083411_681242_70723ECA)
References: <AC090B9732AB2B4DB7FF476E907FE6600131E1C339@dnce02.ent.ti.com>
In-Reply-To: <AC090B9732AB2B4DB7FF476E907FE6600131E1C339@dnce02.ent.ti.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Aloisio, Lauro, Samuel,

> 
> The following 2 NFC control operations (via generic netlink) were added:
> 	- Dev_up, which turn on the NFC controller (this operation may take
> a 	few seconds, as it can download new FW to the NFC controller)
> 	- Dev_down, which turn off the NFC controller
> 
Please note that in the file core.c, the new flag 'dev_up' is not checked in the nfc core API (e.g. in the function nfc_start_poll).
We should discuss whether the dev_up/dev_down operations will be used in all devices (i.e. also PN533) - this is my preference.
If so, I'll add a check for the 'dev_up' flag in the nfc core API.
Otherwise, I'll check the state at a lower layer, i.e. the NCI layer.

Please advise.

Thanks & BR,
Ilan

