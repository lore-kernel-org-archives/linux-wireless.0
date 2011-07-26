Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:42754 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab1GZRgS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jul 2011 13:36:18 -0400
Received: by yia27 with SMTP id 27so416386yia.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Jul 2011 10:36:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110725091641.GA2608@redhat.com>
References: <1311341512-2882-1-git-send-email-sgruszka@redhat.com>
	<1311341512-2882-6-git-send-email-sgruszka@redhat.com>
	<20110723045100.GB828@vmraj-lnx.users.atheros.com>
	<20110725091641.GA2608@redhat.com>
Date: Wed, 27 Jul 2011 01:36:18 +0800
Message-ID: <CAJ-VmokJx3gpLUPwdyDuw7y0B-Y=_HHY8pcQTRcJatyn=87JYg@mail.gmail.com> (sfid-20110726_193622_105184_E7C32D2A)
Subject: Re: [RFC/RFT 5/6] ath9k: do btcoex ASPM disabling at initialization time
From: Adrian Chadd <adrian@freebsd.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@venema.h4ckr.net, camilo@mesias.co.uk,
	Jonathan Nieder <jrnieder@gmail.com>,
	Tony Houghton <h@realh.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks very much for picking up the diagnoses we did and joining the
pieces together with other APSM issues with other chipsets. :-)

I'm glad it's finally being resolved!



Adrian


On 25 July 2011 17:16, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Sat, Jul 23, 2011 at 10:21:01AM +0530, Rajkumar Manoharan wrote:
>> On Fri, Jul 22, 2011 at 03:31:51PM +0200, Stanislaw Gruszka wrote:
>> > +           pci_read_config_byte(parent, PCI_EXP_LNKCTL, &aspm);
>> > +           aspm &= ~(PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1);
>> > +           pci_write_config_byte(parent, PCI_EXP_LNKCTL, aspm);
>> > +
>> Why dont you use pci_disable_link_state instead?
>
> Because pci_disable_link_state is noop for CONFIG_PCIEASPM disabled.
> I have further patches (based on stuff in e1000e, not finished yet)
> that integrate this into pci core and work on both cases, CONFIG_PCIEASPM
> disabled and enabled.
>
