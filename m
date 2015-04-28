Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 3.mo5.mail-out.ovh.net ([46.105.40.108]:54925 "EHLO
	3.mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932699AbbD1KvD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2015 06:51:03 -0400
Received: from mail624.ha.ovh.net (b9.ovh.net [213.186.33.59])
	by mo5.mail-out.ovh.net (Postfix) with SMTP id B1092FF9C56
	for <linux-wireless@vger.kernel.org>; Tue, 28 Apr 2015 10:23:37 +0200 (CEST)
Message-ID: <553F4382.2070402@effinnov.com> (sfid-20150428_125107_838997_C744B47F)
Date: Tue, 28 Apr 2015 10:23:30 +0200
From: =?UTF-8?B?Q2zDqW1lbnQgUGVycm9jaGF1ZA==?=
	<clement.perrochaud@effinnov.com>
MIME-Version: 1.0
To: Valentin Rothberg <valentinrothberg@gmail.com>
CC: sameo@linux.intel.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, lauro.venancio@openbossa.org,
	aloisio.almeida@openbossa.org, Paul Bolle <pebolle@tiscali.nl>,
	Andreas Ruprecht <rupran@einserver.de>,
	hengelein Stefan <stefan.hengelein@fau.de>
Subject: Re: NFC: CONFIG_NFC_DEBUG not defined
References: <CAD3Xx4+vRhswKAbpHnrYQMRNKOppOQzgFOgoJw_1iAfK4baCtQ@mail.gmail.com> <CAD3Xx4+eZOrgm_ae9UeUWB+EfUdi5B1jqs1R-CxYzYZ5AvHyfQ@mail.gmail.com>
In-Reply-To: <CAD3Xx4+eZOrgm_ae9UeUWB+EfUdi5B1jqs1R-CxYzYZ5AvHyfQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 27, 2015 at 9:03 AM, Valentin Rothberg wrote:
> Hi Clément,
>
> your commit dece45855a8b ("NFC: nxp-nci: Add support for NXP NCI
> chips") adds the Makefile drivers/nfc/nxp-nci/Makefile with the
> following line:
>
> +ccflags-$(CONFIG_NFC_DEBUG) := -DDEBUG
>
> The Kconfig option NFC_DEBUG is not defined so the line turns out to
> be a nop.  There is another reference in drivers/nfc/Makefile.  Is
> there a patch queued somewhere to add the option?
>
> I found this issue with ./scripts/checkkconfigsymbols.py by diffing
> v4.0 and v4.1-rc1.

Hi Valentin,

I only included this line because it was present in the upper-level
Makefile drivers/nfc/Makefile . As far as I know, there is no plan to
add this option to the configuration.

What would the most sensible solution to this issue be ? Add the NFC
Debug feature to the configuration ? Remove it altogether ?

Regards,

-- 
Clément Perrochaud

Eff'Innov Technologies
Caen, Aix-En-Provence, Grenoble

Eff'Innov Technologies
Campus EffiScience
2, Esplanade Anton Philips
14460 Colombelles, FRANCE

http://www.effinnov.com
