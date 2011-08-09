Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42365 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373Ab1HISCm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 14:02:42 -0400
Subject: Re: [RFC] NFC: NCI protocol proposal
From: Johannes Berg <johannes@sipsolutions.net>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: "Elias, Ilan" <ilane@ti.com>,
	"aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>,
	"samuel@sortiz.org" <samuel@sortiz.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <CAK3JMAa=1kuP7CRRMBLxZtMromYbDMz18W6ZT=1KoSCD=tfFkQ@mail.gmail.com> (sfid-20110809_194411_068851_56DC16DA)
References: <AC090B9732AB2B4DB7FF476E907FE6600131D0E347@dnce02.ent.ti.com>
	 <CAK3JMAa=1kuP7CRRMBLxZtMromYbDMz18W6ZT=1KoSCD=tfFkQ@mail.gmail.com>
	 (sfid-20110809_194411_068851_56DC16DA)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 20:02:30 +0200
Message-ID: <1312912950.3966.5.camel@jlt3.sipsolutions.net> (sfid-20110809_200245_778759_DE98EE14)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-09 at 14:43 -0300, Lauro Ramos Venancio wrote:

> > We need to add the following 2 control operations (via generic netlink):
> >        - Dev_up, which turn on the NFC controller (this operation may take a   few seconds, as it can download new FW to the NFC controller)
> >        - Dev_down, which turn off the NFC controller
> > The dev_up/down approach was also used with HCI protocol in the BlueZ project.
> 
> I am not completely convinced that we need the dev up/down. Why is it
> not possible to load the FW in the probe?

The usual problem, if the driver is built-in then the probe will run
before userspace is available to load firmware.

johannes

