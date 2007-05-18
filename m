Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:48636 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753742AbXERVpU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2007 17:45:20 -0400
Message-ID: <464E0DB5.5010802@linux.intel.com>
Date: Fri, 18 May 2007 13:33:57 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers [part 2/2]
References: <464B7B7C.5080800@linux.intel.com> <20070516203505.556df4f9.randy.dunlap@oracle.com>
In-Reply-To: <20070516203505.556df4f9.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Randy Dunlap wrote:
> On Wed, 16 May 2007 14:45:32 -0700 James Ketrenos wrote:
> 
>> This patch adds the iwlwifi project directory and sources needed to 
>> build the mac80211 based wireless drivers for the Intel PRO/Wireless 
>> 3945ABG/BG Network Connection and Intel Wireless WiFi Link AGN adapters.
>>
>> Signed-off-by: James Ketrenos <jketreno@linux.intel.com>
>>
>> NOTE:  The patch is 597k and can be found at:
>>
>> 	http://intellinuxwireless.org/iwlwifi/0001-Add-iwlwifi-wireless-drivers.patch
>>
>> Patch is against wireless-dev commit-id be8662897~
> 
> 
> 1.  Can't this:
> +	if (sizeof(priv->eeprom) != 1024) {
...
> use this instead of 1024 ?
> +#define IWL4965_EEPROM_IMAGE_SIZE  (0x200 * sizeof(u16))

Changed to BUILD_BUG_ON(sizeof(priv->eeprom) != IWL_EEPROM_IMAGE_SIZE) and defined IWL_EEPROM_IMAGE_SIZE in iwl-eeprom.h

> 2.  Use of bitfields:  bitfields are not (guaranteed to be) portable
> across a wire interface to some other CPU architecture.
> Are all bitfield uses always local to the running driver?
> They should be.

The bitfields are between the hw/ucode (__le) and the driver.  Are you saying the bitfields won't be compatible if the driver is compiled and running on big endian?  Shouldn't le16_to_cpu() fix that?  I just noticed the types in iwl-4965-hw.h weren't endian specific; I've updated that (u16, u32, u64 -> __le16, __le32, __le64)

> 3.  What are all of those "volatile" C keywords doing in struct
> iwl_shared?
> See http://lwn.net/Articles/232961/ : "The trouble with volatile"

If a reference shared through memory mapped IO with a device that can change the value at any time, doesn't it need to be volatile?  'struct iwl_shared' is allocated with pci_alloc_consistent and the physical address is provided to the hardware for it to update whenever it sees fit.

> 4.  Don't list the parameters like this:

Lindent == bad.  I've fixed the instances of this munging I've come across.

> 5.  This function:
> 
> +static inline u8 iwl4965_get_dma_hi_address(dma_addr_t addr)

Fixed to do what Stephen did in sky2.

> 6.  No need to init rc:

Fixed those and several others.  I'm sure there are more we'll have to weed out over time (unless you know a sparse option that will say 'initializing variable unnecessarily')

> 8.  Too many BUG_ON()s.  Try to recover or return -ERRORs instead.

I pulled out two that shouldn't have been there.

The rest are currently there map to bugs which are easily introduced through code changes but which may not cause an immediately visible bug at run-time.  Typically they are placed where an eventual printk() at that location during debugging of a user bug resulted in the critical "ah-ha!" that led to fixing it.  I've added comments to the BUG_ON's that didn't have comments already.

I suppose we could try and introduce a new driver recovery mechanism that, upon detection, throws a stack trace and then shuts down the driver (vs. throwing a kernel OOPs) requiring user space to unload and reload the driver.  That would still be a sucky situation, but at least it wouldn't cause a system failure requiring a reboot...  does such a mechanism already exist?

> 
> 9.  printk() calls should use KERN_* levels.
Fixed.

> 10. Don't use C99-style // comments.
Fixed.

> and as Andrew's -mm announcements and my sig say, use
> Documentation/SubmitChecklist to see what else needs to be done.

Will do.

Above changes in GIT (http://intellinuxwireless.org/repos/iwlwifi.git/)

Thanks,
James
