Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:43007 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755450Ab0IAPHS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Sep 2010 11:07:18 -0400
Message-ID: <4C7E6C1D.8050305@hauke-m.de>
Date: Wed, 01 Sep 2010 17:07:09 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"mcgrof@infradead.org" <mcgrof@infradead.org>
Subject: Re: [PATCH] compat: backport linux/pci-aspm.h
References: <1282934514-18160-1-git-send-email-hauke@hauke-m.de> <20100828210131.GA2422@tux>
In-Reply-To: <20100828210131.GA2422@tux>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 28.08.2010 23:01, schrieb Luis R. Rodriguez:
> On Fri, Aug 27, 2010 at 11:41:54AM -0700, Hauke Mehrtens wrote:
>> pci-aspm.h was introduced in kernel 2.6.25 and is used by the ath5k driver.
>>
>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>> ---
>>  include/linux/pci-aspm.h |   55 ++++++++++++++++++++++++++++++++++++++++++++++
>>  1 files changed, 55 insertions(+), 0 deletions(-)
>>  create mode 100644 include/linux/pci-aspm.h
>>
>> diff --git a/include/linux/pci-aspm.h b/include/linux/pci-aspm.h
>> new file mode 100644
>> index 0000000..c791d00
>> --- /dev/null
>> +++ b/include/linux/pci-aspm.h
> 
> So compat-wireless would have to copy this file over? We'd then have to synch
> this file for older kernels, and the real kernel header's own pci-aspm.h for
> kernels >= 2.6.25 would be using this version of the file. Can we just stuff
> the ASPM required stuff onto include/linux/compat-2.6.25.h ?
> 
>   Luis
Hi,

we can stuff the empty aspm functions into compat-2.6.25.h, but we need
include/linux/pci-aspm.h or we need an extra ifdef in compat-wireless
(not nice). Some drivers like drivers/net/wireless/ath/ath5k/base.c and
drivers/net/wireless/iwlwifi/iwl-agn.c are including pci-aspm.h, but it
is not there for kernels < 2.6.25.

I will prepare a new patch for compat. With an mostly empty pci-aspm.h
with an include_next and some functions in compat-2.6.35.h.

Hauke
