Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:24570 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472AbZEZOBV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 10:01:21 -0400
Date: Tue, 26 May 2009 16:03:32 +0200
From: Samuel Ortiz <samuel.ortiz@intel.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Marcel Holtmann <holtmann@linux.intel.com>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/3] iwmc3200wifi: shrink calibration lmac name
Message-ID: <20090526140327.GB14626@sortiz.org>
References: <1243307448-17441-1-git-send-email-yi.zhu@intel.com> <1243307448-17441-2-git-send-email-yi.zhu@intel.com> <1243312991.21383.3.camel@localhost.localdomain> <1243317777.3623.19.camel@debian> <1243319583.30938.2.camel@localhost.localdomain> <1243320454.3623.35.camel@debian> <1243327894.30938.9.camel@localhost.localdomain> <20090526110403.GA14626@sortiz.org> <ac3eb2510905260406v43f3fd71i6eceeec2ea6ecbf4@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <ac3eb2510905260406v43f3fd71i6eceeec2ea6ecbf4@mail.gmail.com>
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 26, 2009 at 04:06:40AM -0700, Kay Sievers wrote:
> On Tue, May 26, 2009 at 13:04, Samuel Ortiz <samuel.ortiz@intel.com> wrote:
> > -       strlcpy(fw_priv->fw_id, fw_name, FIRMWARE_NAME_MAX);
> > +       fw_priv->fw_id = kzalloc(strlen(fw_name) + 1, GFP_KERNEL);
> 
> kstrdup()?
Indeed, thanks.

I'm offloading this thread to lkml, as I dont want to continue polluting the
linux-wireless one with unrelated matters.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

