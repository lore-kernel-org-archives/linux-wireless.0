Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:39690 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753777Ab1LDOaQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Dec 2011 09:30:16 -0500
From: "Elias, Ilan" <ilane@ti.com>
To: "lauro.venancio@openbossa.org" <lauro.venancio@openbossa.org>,
	"samuel@sortiz.org" <samuel@sortiz.org>,
	"aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: NFC: mutex_lock is called in atomic_notifier_chain callback
Date: Sun, 4 Dec 2011 14:30:06 +0000
Message-ID: <B30D1FD582D6484ABF57420512E5803501ADC9D4@DNCE03.ent.ti.com> (sfid-20111204_153021_687591_026F9A91)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Lauro, Samuel, Aloisio,

I think there might be a problem in the netlink notifier in the NFC subsystem.

The function mutex_lock (which might sleep) is called in the function nfc_genl_rcv_nl_event.
As far as I understand, the function nfc_genl_rcv_nl_event can be executed in atomic context (since it's registered via atomic_notifier_chain_register in af_netlink.c).

I'll appreciate your comments on this issue.

Thanks & BR,
Ilan
