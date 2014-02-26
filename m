Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p3plsmtpa11-01.prod.phx3.secureserver.net ([68.178.252.102]:39178
	"EHLO p3plsmtpa11-01.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753880AbaBZWBd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Feb 2014 17:01:33 -0500
Date: Wed, 26 Feb 2014 14:53:32 -0700
From: "Mark A. Greer" <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Felipe Balbi <balbi@ti.com>, Erick Macias <emacias@ti.com>,
	Thierry Escande <thierry.escande@linux.intel.com>,
	linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
	devicetree@vger.kernel.org
Subject: Re: [PATCH 2/3] NFC: trf7970a: Add ISO/IEC 15693 Support
Message-ID: <20140226215332.GB21867@animalcreek.com> (sfid-20140226_230136_965735_6723589C)
References: <1391206631-9862-1-git-send-email-mgreer@animalcreek.com>
 <1391206631-9862-3-git-send-email-mgreer@animalcreek.com>
 <20140221010044.GT18868@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140221010044.GT18868@zurbaran>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 21, 2014 at 02:00:44AM +0100, Samuel Ortiz wrote:
> Hi Mark,
> 
> Just one nitpick here:
> 
> > +static int trf7970a_is_iso15693_write_or_lock(u8 cmd)
> > +{
> > +	int ret;
> > +
> > +	switch (cmd) {
> > +	case ISO15693_CMD_WRITE_SINGLE_BLOCK:
> > +	case ISO15693_CMD_LOCK_BLOCK:
> > +	case ISO15693_CMD_WRITE_MULTIPLE_BLOCK:
> > +	case ISO15693_CMD_WRITE_AFI:
> > +	case ISO15693_CMD_LOCK_AFI:
> > +	case ISO15693_CMD_WRITE_DSFID:
> > +	case ISO15693_CMD_LOCK_DSFID:
> > +		ret = 1;
> return 1;
> 
> and return 0 on the default case.
> Simpler code and you don't need the ret variable.

OK
