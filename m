Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:57514 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255Ab2AQJnK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 04:43:10 -0500
From: "Elias, Ilan" <ilane@ti.com>
To: Samuel Ortiz <samuel@sortiz.org>
CC: "aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>,
	"lauro.venancio@openbossa.org" <lauro.venancio@openbossa.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] NFC: Increase NCI deactivate timeout
Date: Tue, 17 Jan 2012 09:42:56 +0000
Message-ID: <B30D1FD582D6484ABF57420512E580350F5E0D88@DNCE03.ent.ti.com> (sfid-20120117_104314_848673_F44647F4)
References: <1326022982-30205-1-git-send-email-ilane@ti.com>
 <1326745622.22824.12.camel@sortiz-mobl>
In-Reply-To: <1326745622.22824.12.camel@sortiz-mobl>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 Hi Samuel,

> > Increase NCI deactivate timeout from 5 sec to 30 sec.
> > NCI deactivate procedure might take a long time,
> > depending on the local and remote parameters.
> 30 seconds sounds like a huge delay for receiving a reply to 
> such command.
> Would you care explaining how we can get that long of a timeout ?
The controller in the Reader side uses a value called nRETRY (see NFC Forum Digital spec).
This value is an internal implementation, valid range is 2 to 5.
This value determines the number of re-transmissions.

The controller in the Tag side uses a value called FWI - Frame Waiting time Integer (see NFC Forum Digital spec).
This value is an internal implementation, valid range is 1 to 14.
This value determines (via some formula) the FWT - Frame Waiting Time, which is a timout.
Max FWT value can be almost 5sec.

So, the total max timeout can be 5sec for the first packet + 5sec for each of the 5 re-transmissions = 5 + 5x5 = 30 sec.

> Cheers,
> Samuel.

Thanks & BR,
Ilan
