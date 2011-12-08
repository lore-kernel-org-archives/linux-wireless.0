Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:43232 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab1LHRTv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 12:19:51 -0500
From: "Elias, Ilan" <ilane@ti.com>
To: "lauro.venancio@openbossa.org" <lauro.venancio@openbossa.org>,
	"samuel@sortiz.org" <samuel@sortiz.org>,
	"aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [RFC] NFC: Add num of targets to TARGETS_FOUND event
Date: Thu, 8 Dec 2011 17:13:14 +0000
Message-ID: <B30D1FD582D6484ABF57420512E5803504FD0316@DNCE03.ent.ti.com> (sfid-20111208_181955_265345_6E837654)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Lauro, Aloisio, Samuel, all,

It seems that when targets are found (via NFC_EVENT_TARGETS_FOUND), there is no way to know (in user space) how many targets were found in advance.

I suggest we add a new attribute NFC_ATTR_NUM_TARGETS_FOUND to the event NFC_EVENT_TARGETS_FOUND.
Otherwise, the user would have to wait until a timeut expires in order to decide that no more targets will arrive.
Please note that the knowledge of how many targets were found can be found in the variable dev->n_targets.

I'll appreciate your comments on this issue.
If you agree, I'll send out a patch for this.

Thanks & BR,
Ilan