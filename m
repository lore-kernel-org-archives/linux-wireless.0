Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21734 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbaAVAza (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jan 2014 19:55:30 -0500
Date: Wed, 22 Jan 2014 01:55:07 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "Mark A. Greer" <mgreer@animalcreek.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Thierry Escande <thierry.escande@linux.intel.com>,
	linux-wireless@vger.kernel.org, linux-nfc@lists.01.org
Subject: Re: [PATCH v2 2/3] NFC: iso15693 - Add Digital Layer support for
 ISO/IEC 15693
Message-ID: <20140122005507.GJ19138@zurbaran> (sfid-20140122_015534_075994_4E4057F4)
References: <1389747131-2577-1-git-send-email-mgreer@animalcreek.com>
 <1389747131-2577-3-git-send-email-mgreer@animalcreek.com>
 <20140121232359.GA32300@animalcreek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140121232359.GA32300@animalcreek.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mark,

On Tue, Jan 21, 2014 at 04:23:59PM -0700, Mark A. Greer wrote:
> Add support for ISO/IEC 15693 to the digital layer.  The code
> currently uses single-slot anticollision only since the digital
> layer infrastructure only supports one tag per adapter (making
> it pointless to do 16-slot anticollision).
> 
> The code uses two new framing types:
> 'NFC_DIGITAL_FRAMING_ISO15693_INVENTORY' and
> 'NFC_DIGITAL_FRAMING_ISO15693_TVT'.  The former is used to
> tell the driver to prepare for an Inventory command and the
> ensuing anticollision sequence.  The latter is used to tell
> the driver that the anticollision sequence is over and to
> prepare for non-inventory commands.
> 
> Signed-off-by: Mark A. Greer <mgreer@animalcreek.com>
> ---
> 
> Changes since v1:
>  - rewrote kzalloc line to use sizeof(*target) instead of target's type
>  - initialized the mask_len part of the 15693 inventory request
Thanks, all 3 patches applied to nfc-next now.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
