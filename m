Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:55782 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753243Ab1HNLvy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 07:51:54 -0400
From: "Elias, Ilan" <ilane@ti.com>
To: Samuel Ortiz <samuel@sortiz.org>
CC: "aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>,
	"lauro.venancio@openbossa.org" <lauro.venancio@openbossa.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Sun, 14 Aug 2011 13:51:43 +0200
Subject: RE: [RFC] NFC: NCI protocol proposal
Message-ID: <AC090B9732AB2B4DB7FF476E907FE6600131D89563@dnce02.ent.ti.com> (sfid-20110814_135202_871534_C1507698)
References: <AC090B9732AB2B4DB7FF476E907FE6600131D0E347@dnce02.ent.ti.com>
 <1313086096.8413.11.camel@sortiz-mobl>
In-Reply-To: <1313086096.8413.11.camel@sortiz-mobl>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Samuel,

> > We would like to implement the NFC Controller Interface (NCI) protocol
> > for the NFC subsystem.
> > The NCI is a standard communication protocol between an NFC Controller
> > (NFCC) and a Device Host (DH), defined by the NFC Forum.
> Just as a side note to our previous thread: As far as I know, NCI is still
> a draft (very close to the final version though) and as a consequence only
> available to NFC Forum members.
You're correct. We estimate it will be official by e/o this year.

> > The NCI protocol implementation will be chip independent and responsible
> > for:
> > 	- Reset, initialization and configuration of the NFC controller
> > 	- Sending commands/data to the NFC controller
> > 	- Receiving responses/notifications/data from the NFC controller
> > 	- Flow control for Control and Data Messages
> > 	- Segmentation and reassembly for Control and Data Messages
> > 	- An addressing scheme for NFC Execution Environments (NFCEE), e.g.
> >	secure element
> > 	- An addressing scheme for Remote NFC Endpoints (NFCEE or RF
> > targets) 	(via logical connections)
> Could you give us some more details about those last 2 points ?
As specified in the NCI spec, NFC Execution Environment (NFCEE) is an environment where NFC applications are executed (e.g. secure element).
NCI provides features to allow DH to NFCEE communication. NCI therefore includes methods to discover and enumerate connected NFCEEs and the Interfaces they support, and to establish connections between DH and NFCEE Interfaces.
A logical connection is a connection between the Device Host (DH) and the NFC Controller (NFCC) that is used for communication towards a target, either NFCEE or Remote NFC Endpoint. More than one Logical Connection MAY exist to the same target.

> Out of curiosity, is this NCI HW of yours based on the TRF7970A
> chipset ? 
No, it's a new TI combo device, not in the market yet.

Thanks & BR
Ilan

