Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isis.lip6.fr ([132.227.60.2]:54850 "EHLO isis.lip6.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030536AbaGRPcR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2014 11:32:17 -0400
From: Benoit Taine <benoit.taine@lip6.fr>
To: linux-pci@vger.kernel.org
Cc: benoit.taine@lip6.fr, ath5k-devel@venema.h4ckr.net,
	ath9k-devel@venema.h4ckr.net, linux-hippi@sunsite.dk,
	dri-devel@lists.freedesktop.org, linux-acenic@sunsite.dk,
	wil6210@qca.qualcomm.com, platform-driver-x86@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-mips@linux-mips.org, users@rt2x00.serialmonkey.com,
	linux-rdma@vger.kernel.org,
	virtualization@lists.linux-foundation.org,
	industrypack-devel@lists.sourceforge.net,
	linux-can@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-fbdev@vger.kernel.org, ath10k@lists.infradead.org,
	linux-crypto@vger.kernel.org, MPT-FusionLinux.pdl@avagotech.com,
	devel@linuxdriverproject.org, xen-devel@lists.xenproject.org,
	linux-pcmcia@lists.infradead.org, e1000-devel@lists.sourceforge.net
Subject: [PATCH 0/25] Replace DEFINE_PCI_DEVICE_TABLE macro use
Date: Fri, 18 Jul 2014 17:26:47 +0200
Message-Id: <1405697232-11785-1-git-send-email-benoit.taine@lip6.fr> (sfid-20140718_173245_487408_3DF25EDB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should prefer `const struct pci_device_id` over
`DEFINE_PCI_DEVICE_TABLE` to meet kernel coding style guidelines.
This issue was reported by checkpatch.

A simplified version of the semantic patch that makes this change is as
follows (http://coccinelle.lip6.fr/):

// <smpl>

@@
identifier i;
declarer name DEFINE_PCI_DEVICE_TABLE;
initializer z;
@@

- DEFINE_PCI_DEVICE_TABLE(i)
+ const struct pci_device_id i[]
= z;

// </smpl>

I have 103 patches ready, and will only send a few for you to judge if
it is useful enough, and to prevent from spamming too much.

Thanks.
