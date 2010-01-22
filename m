Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62418 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985Ab0AVHpx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jan 2010 02:45:53 -0500
Date: Fri, 22 Jan 2010 08:43:01 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: reinette chatre <reinette.chatre@intel.com>
Cc: "stable@kernel.org" <stable@kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 2.6.{32,31}] iwlwifi: power up all devices for EEPROM
	read
Message-ID: <20100122074300.GA2369@dhcp-lab-161.englab.brq.redhat.com>
References: <1264076545-12223-1-git-send-email-sgruszka@redhat.com> <1264096944.21458.139.camel@rchatre-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1264096944.21458.139.camel@rchatre-DESK>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Thu, Jan 21, 2010 at 10:02:24AM -0800, reinette chatre wrote:
> The 2.6.32 and 2.6.31 code you are changing here adds a device "power
> up" call into iwl_eeprom_init. This is not necessary since as you can
> see, in iwl3945_pci_probe this exact same call is made right before
> iwl_eeprom_init is called.

Sorry, missed that. I should wrote in the changelog that this is backport
of more commits and remove power up stuff from pci proble as well.

> > 
> > On 2.6.31 and 2.6.32 iwl3945 crash during kdump, I discovered
> > above upstream commit fix that.
> 
> This does not make sense. Was this testing done in the stable kernel
> from linux-2.6-stable or perhaps a kernel that had those other power
> saving patches backported?

I tested backported patch on 2.6.32.4. It fix kdump, this issue is
100% reproducible on my laptop with iwl3945.

The functional change introduced in this patch is we disable device
after EEPROM read. I think that make difference with kdump. Not sure
if this right fix or just workaround.

Debugging kdump kernel is somehow limited, I have no netconsole or serial
console option. I can only see last part of call trace where are iwlwifi
functions. I'm going dig into kernel to make calltrace shorter and see
where exact the oops is.

Cheers
Stanislaw 
