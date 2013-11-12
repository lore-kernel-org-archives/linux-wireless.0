Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:54972 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab3KLThM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 14:37:12 -0500
Message-ID: <52828364.6080103@gmail.com> (sfid-20131112_203716_024660_71F9A2EF)
Date: Tue, 12 Nov 2013 21:37:08 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
CC: wzyboy <wzyboy@wzyboy.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [Ilw] Intel Wireless 7260 hardware timed out randomly
References: <0BA3FCBA62E2DC44AF3030971E174FB301DEA052@HASMSX103.ger.corp.intel.com> <0BA3FCBA62E2DC44AF3030971E174FB301DEA097@HASMSX103.ger.corp.intel.com> <CALkVjQY7uRFQ3Qs9T_bgqnYRNcWgsk5gfd=R8RfGFxOdDpFYTQ@mail.gmail.com> <527A8166.6000701@gmail.com> <CAErSpo5H9Mf-xmdzThudNO2WHAOt-1T7CQZvgGUmK4jm7_zf+g@mail.gmail.com> <CALkVjQaHYpR4Tifbt7nh4VeQSrOz5J-xxSrUBKX2kXCZcvkivA@mail.gmail.com> <CAErSpo5dX=cPdThxi-ok=B4beo_jPv2n2n0C1u4UyZMbQDMxqg@mail.gmail.com> <CALkVjQYkAWrwRabQfBSvC1pm47ZyRT5jQ0mYBwbiGh-Bt29gbg@mail.gmail.com> <20131111224439.GA30638@google.com> <CALkVjQb-AJRSGARCQaDFkd+mHBk2qFkAVyVBTW7RHSaxzbZsbw@mail.gmail.com> <CALkVjQaXEBpbwu9Qy3+17Eg-nSg-k7iin8G3f1RsTLkCOB-2XQ@mail.gmail.com> <0BA3FCBA62E2DC44AF3030971E174FB301DF044C@HASMSX103.ger.corp.intel.com> <CAErSpo5iU15AoSVL9WmLp4gNCiNmt6pFZuTsd-Vui4SCrSc_Hw@mail.gmail.com> <0BA3FCBA62E2DC44AF3030971E174FB301DF0865@HASMSX103.ger.corp.intel.com> <CAErSpo77vnfRvEdgj470WWKo_8p8cv2xQUdaGQvvkY3tPBXzyQ@mail.gmail.com>
In-Reply-To: <CAErSpo77vnfRvEdgj470WWKo_8p8cv2xQUdaGQvvkY3tPBXzyQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 11/12/2013 09:14 PM, Bjorn Helgaas wrote:
> On Tue, Nov 12, 2013 at 11:25 AM, Grumbach, Emmanuel
> <emmanuel.grumbach@intel.com> wrote:
> 
>> Right - I remember the discussion we had on that.
>> On this device (7260 that has an issue with ASPM), we don't call pci_disable_link_state, because we know it is supposed to work...
> 
> If ASPM is supposed to work as far as the hardware is concerned, I
> guess you're saying this must be an iwlwifi driver issue.  Right?

ASPM is supposed to work as far as the hardware is concerned.
We might very well have an issue in iwlwifi - and I am checking this
internally with our System guys.
It can be a PCI core problem too, and it could also be a platform / BIOS
/ Lenovo issue.
Of course, I have no clue which of these is the culprit here.
Our System folks seemed to say that this new device uses L1 substates
which can be enabled in Haswell platform which the user owns.
Now - L1 substates is a new feature and might introduce issues
(apparently) - and this is why they (System folks) wanted the try
without L1 substates. But disabling L1 substates doesn't seem trivial
with the production BIOS of Lenovo. So I am pretty stuck here.
Another possibility is to run a PCI analyser on the machine, but that
requires to have the machine in the lab...

> If you think it's a PCI core problem, we have to figure out what the
> core needs to do differently.  If somebody can point to a difference
> in the ASPM configuration between Windows and Linux, that would be a
> good start.
> 
> Bjorn
> 
