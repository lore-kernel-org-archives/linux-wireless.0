Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.danego.net ([195.246.116.61]:50720 "EHLO smtp.danego.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031773AbbKEMx1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Nov 2015 07:53:27 -0500
From: =?iso-8859-1?Q?Robert_Deli=EBn?= <robert@delien.nl>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "kvalo@qca.qualcomm.com" <kvalo@qca.qualcomm.com>
Subject: RE: ath6kl: SDIO hif-scatter broken?
Date: Thu, 5 Nov 2015 12:53:21 +0000
Message-ID: <6EA3E0BCC03CC34B89B01BD57ECBC718B17AA955@POBOX.postoffice.danego.net> (sfid-20151105_135402_950679_C0E16A58)
References: <6EA3E0BCC03CC34B89B01BD57ECBC718B17A9FA8@POBOX.postoffice.danego.net>
In-Reply-To: <6EA3E0BCC03CC34B89B01BD57ECBC718B17A9FA8@POBOX.postoffice.danego.net>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I can connect to my target's AP and FTP server. Reading small files (~3kB)
> over FTP works. However, reading a large file (1GB) stalls after 80kB...220kB.
> At the moment of stall, the following errors are reported by the Kernel:
> ath6kl: Scatter write request failed:-110

It needs to be said that this problem only occurs when the ath6kl is in access point mode. When it is in infra mode and connected to an existing network, the problem doesn't occur.

But then again: In infra mode, it doesn't seem to call ath6kl_sdio_scat_rw with real SDIO scattering. So the question if ath6kl SDIO hif-scatter is broken still stands.