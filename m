Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:36156 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbbD1IgY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Apr 2015 04:36:24 -0400
MIME-Version: 1.0
In-Reply-To: <553F4382.2070402@effinnov.com>
References: <CAD3Xx4+vRhswKAbpHnrYQMRNKOppOQzgFOgoJw_1iAfK4baCtQ@mail.gmail.com>
 <CAD3Xx4+eZOrgm_ae9UeUWB+EfUdi5B1jqs1R-CxYzYZ5AvHyfQ@mail.gmail.com> <553F4382.2070402@effinnov.com>
From: Valentin Rothberg <valentinrothberg@gmail.com>
Date: Tue, 28 Apr 2015 10:35:52 +0200
Message-ID: <CAD3Xx4LYkvACWZwy5TZUK6eOTLFv78pBCtZFv3y6Tfsm7vuy=w@mail.gmail.com> (sfid-20150428_103632_783237_9978AB2A)
Subject: Re: NFC: CONFIG_NFC_DEBUG not defined
To: =?UTF-8?Q?Cl=C3=A9ment_Perrochaud?=
	<clement.perrochaud@effinnov.com>
Cc: sameo@linux.intel.com, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, lauro.venancio@openbossa.org,
	aloisio.almeida@openbossa.org, Paul Bolle <pebolle@tiscali.nl>,
	Andreas Ruprecht <rupran@einserver.de>,
	hengelein Stefan <stefan.hengelein@fau.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Clément,

thanks for your answer.

On Tue, Apr 28, 2015 at 10:23 AM, Clément Perrochaud
<clement.perrochaud@effinnov.com> wrote:
> On Mon, Apr 27, 2015 at 9:03 AM, Valentin Rothberg wrote:
>> Hi Clément,
>>
>> your commit dece45855a8b ("NFC: nxp-nci: Add support for NXP NCI
>> chips") adds the Makefile drivers/nfc/nxp-nci/Makefile with the
>> following line:
>>
>> +ccflags-$(CONFIG_NFC_DEBUG) := -DDEBUG
>>
>> The Kconfig option NFC_DEBUG is not defined so the line turns out to
>> be a nop.  There is another reference in drivers/nfc/Makefile.  Is
>> there a patch queued somewhere to add the option?
>>
>> I found this issue with ./scripts/checkkconfigsymbols.py by diffing
>> v4.0 and v4.1-rc1.
>
> Hi Valentin,
>
> I only included this line because it was present in the upper-level
> Makefile drivers/nfc/Makefile . As far as I know, there is no plan to
> add this option to the configuration.
>
> What would the most sensible solution to this issue be ? Add the NFC
> Debug feature to the configuration ? Remove it altogether ?

DEBUG is not used in any of the files in drivers/nfc/ so I think we
can safely remove the two lines from the Makefiles.  Do you want me to
prepare a patch?

Kind regards,
 Valentin

> Regards,
>
> --
> Clément Perrochaud
>
> Eff'Innov Technologies
> Caen, Aix-En-Provence, Grenoble
>
> Eff'Innov Technologies
> Campus EffiScience
> 2, Esplanade Anton Philips
> 14460 Colombelles, FRANCE
>
> http://www.effinnov.com
