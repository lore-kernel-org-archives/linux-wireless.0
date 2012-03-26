Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:35421 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755935Ab2CZJlJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 05:41:09 -0400
From: "Elias, Ilan" <ilane@ti.com>
To: Samuel Ortiz <samuel@sortiz.org>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>
CC: Eric Lapuyade <eric.lapuyade@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>
Subject: RE: [PATCH] NFC: Add Core support to generate tag lost event
Date: Mon, 26 Mar 2012 09:40:46 +0000
Message-ID: <B30D1FD582D6484ABF57420512E5803516A9373F@DNCE03.ent.ti.com> (sfid-20120326_114131_922091_08EB9450)
References: <4F6C5C59.2060708@linux.intel.com>
	 <CAK3JMAZhJP=RC09gA7jHf7Z5ZhuscHbsLW2dPq9Wk52uGQt7YA@mail.gmail.com>
 <1332524036.5884.11.camel@sortiz-mobl>
In-Reply-To: <1332524036.5884.11.camel@sortiz-mobl>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Samuel,
 
> > > Some HW/drivers get notifications when a tag moves out of 
> the radio field.
> > > This notification is now forwarded to user space through netlink.
> > 
> > I think to put a timer in the NFC core is not the best solution for
> > this problem.
> > This solution is not suitable for devices that receive an event when
> > the tag moves out of the field.
> I don't know of such device. HCI based devices don't get such event,
> neither does the pn53x USB ones.
> Ilan, does NCI provide such event ?
With Frame I/F (e.g. JEWEL, MIFARE), the NCI doesn't provide any such event.
With ISO-DEP I/F (e.g. ISO14443) and NFC-DEP I/F (i.e. P2P), the NCI provide such an event only when the host sends data: the event CORE_INTERFACE_ERROR_NTF (with status RF_TRANSMISSION_ERROR or RF_PROTOCOL_ERROR or RF_TIMEOUT_ERROR) is sent to the host to indicate that the controller encountered an error while sending the data to the tag.

Thanks & BR,
Ilan
