Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56019 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab1GBREU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jul 2011 13:04:20 -0400
Received: by eyx24 with SMTP id 24so1402241eyx.19
        for <linux-wireless@vger.kernel.org>; Sat, 02 Jul 2011 10:04:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E0F4C0E.5060306@lwfinger.net>
References: <1309196346-15749-1-git-send-email-jdmason@kudzu.us>
	<4E0CDF8B.3020505@emulex.com>
	<294849c5-16f3-491b-98c2-2a96275e8378@exht1.ad.emulex.com>
	<BANLkTi=-43qKpbb6HdYuNTna__5cxVMfoA@mail.gmail.com>
	<4E0F4C0E.5060306@lwfinger.net>
Date: Sat, 2 Jul 2011 12:04:18 -0500
Message-ID: <CAPoiz9w244YuD+E=n8tvfA9DoLCsyeeSZHKZSSxniGGVY-+8UA@mail.gmail.com> (sfid-20110702_190428_755654_768A023B)
Subject: Re: Warning: iwlegacy/iwlwifi/rtlwifi : removal of PCI_CAP_ID_EXP
From: Jon Mason <jdmason@kudzu.us>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: James Smart <james.smart@emulex.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Richard Lary <rlary@us.ibm.com>, wey-yi.w.guy@intel.com,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	chaoming_li@realsil.com.cn
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jul 2, 2011 at 11:49 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> On 07/01/2011 10:08 AM, Jon Mason wrote:
>>
>> pci_is_pcie checks for a PCI-E capability offset that was determined
>> by calling pci_find_capability during the PCI bus walking.  Based on
>> your description above this should be functionally equivalent.  If
>> this is not safe, then the PCI bus walking code is most likely busted
>> on EEH enabled PPC systems (and that is a BIG problem).
>
> Are there PPC systems that support PCI-E cards? I looked for one earlier and
> did not find any. In particular, I wanted a machine to test the Realtek
> drivers for correct big-endian operation. I settled on a Powerbook G4 so
> that I could test the USB drivers.

High-end IBM PPC systems have PCI-E, but are most likely too expensive
for an individual user.  If you are okay with 32bit PPC, you can use
qemu to emulate PPC (see qemu-system-ppc).  I believe you can do USB
pass-though on the emulated system.

Thanks,
Jon

> Larry
>
>
