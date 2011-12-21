Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:41949 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606Ab1LUOSn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 09:18:43 -0500
From: "Elias, Ilan" <ilane@ti.com>
To: "lauro.venancio@openbossa.org" <lauro.venancio@openbossa.org>,
	"samuel@sortiz.org" <samuel@sortiz.org>,
	"aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [RFC] NFC: Add RF technology specific parameters to target info
Date: Wed, 21 Dec 2011 14:18:33 +0000
Message-ID: <B30D1FD582D6484ABF57420512E5803504FE1669@DNCE03.ent.ti.com> (sfid-20111221_151846_813099_85E6E863)
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Samuel, Lauro, Aloisio,

Currently, the target information (sent as response to NFC_CMD_GET_TARGET) contains the following: target index, protocols, sens_res, and sel_res.
As far as I understand, the sens_res (2 Octets) and sel_res (1 Octet) fields are suitable only for tech A.

It seems that several RF technology specific parameters should be added to the target info:
1) For tech A: NFCID1 (0, 4, 7, or 10 Octets), and NFCID1 Length (1 Octet).
2) For tech B: SENSB_RES Response (11 or 12 Octets), and SENSB_RES Response Length (1 Octet).
3) For tech F: SENSF_RES Response (16 or 18 Octets) and SENSF_RES Response Length (1 Octet).

For example, Android LibNfc and OpenNfc stacks (and the application above) expect those fields.
In some technologies, it's required to use those fields in upper layers, e.g. in Mifare classic the tag ID is used during authentication (the tag ID can be found in each of the information fields mentioned above for each tech by different name).

I'll appreciate your comments on this issue.

Thanks & BR,
Ilan
