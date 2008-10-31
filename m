Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.168]:11600 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbYJaXf1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 19:35:27 -0400
Received: by wf-out-1314.google.com with SMTP id 27so1474899wfd.4
        for <linux-wireless@vger.kernel.org>; Fri, 31 Oct 2008 16:35:26 -0700 (PDT)
Message-ID: <1ba2fa240810311635t69165473hef0ef64bf4426d3a@mail.gmail.com> (sfid-20081101_003531_806935_DB4E9BBC)
Date: Sat, 1 Nov 2008 01:35:26 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Marcel Holtmann" <marcel@holtmann.org>
Subject: Re: Still 4965 issues with wireless-testing
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <C202FD8E-EB1E-417D-8086-7ADFBC72A1D3@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <5A6314C4-958B-43E7-B94D-FE5BABED89EA@linux.intel.com>
	 <DAD31980-B029-46D4-A687-9B0426899853@holtmann.org>
	 <1ba2fa240810310652t351b0b77k819a7e03659503eb@mail.gmail.com>
	 <BF4BAA7D-FEBC-40F7-AE07-D6BBD31A2A0B@holtmann.org>
	 <1ba2fa240810311409i5203bcccu2b944dcc505deb30@mail.gmail.com>
	 <C202FD8E-EB1E-417D-8086-7ADFBC72A1D3@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 31, 2008 at 11:36 PM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Tomas,
>
>>>>>> so besides the point that the Ubuntu 8.10 kernel has a broken driver
>>>>>> for
>>>>>> the Intel 4965 cards which will crash my X61 after less than one
>>>>>> minute
>>>>>> uptime when it connects to my access point, I have my dmesg full with
>>>>>> warnings from the latest wireless-testing kernel.
>>>>>>
>>>>>> I know that we have discussed this before and Johannes' patch at least
>>>>>> turns it into warnings instead of killing my system completely, but I
>>>>>> am
>>>>>> still surprised why this hasn't been fixed.
>>>>>
>>>>> so this becomes more and more annoying. I get this WARN_ON now multiple
>>>>> times pre minute. Only the first few minutes after loading the firmware
>>>>> everything is okay and then it keeps filling my dmesg. And on top of
>>>>> that, I
>>>>> now see these:
>>>>>
>>>>> __ratelimit: 1189 callbacks suppressed
>>>>> iwlagn: Can not allocate SKB buffers
>>>>> iwlagn: Can not allocate SKB buffers
>>>>> iwlagn: Can not allocate SKB buffers
>>>>> iwlagn: Can not allocate SKB buffers
>>>>> iwlagn: Can not allocate SKB buffers
>>>>> iwlagn: Can not allocate SKB buffers
>>>>> iwlagn: Can not allocate SKB buffers
>>>>> iwlagn: Can not allocate SKB buffers
>>>>> iwlagn: Can not allocate SKB buffers
>>>>> iwlagn: Can not allocate SKB buffers
>>>>> __ratelimit: 57695 callbacks suppressed
>>>>> iwlagn: Can not allocate SKB buffers
>>>>> iwlagn: Can not allocate SKB buffers
>>>>> iwlagn: Can not allocate SKB buffers
>>>>> iwlagn: Can not allocate SKB buffers
>>>>> iwlagn: Can not allocate SKB buffers
>>>>> iwlagn: Can not allocate SKB buffers
>>>>> iwlagn: Can not allocate SKB buffers
>>>>> iwlagn: Can not allocate SKB buffers
>>>>> iwlagn: Can not allocate SKB buffers
>>>>> iwlagn: Can not allocate SKB buffers
>>>>> __ratelimit: 3345 callbacks suppressed
>>>>> iwlagn: Can not allocate SKB buffers
>>>>> iwlagn: Can not allocate SKB buffers
>>>>>
>>>>> What is going on here? This is a normal setup and nothing fancy. Access
>>>>> point is N-Capable from D-Link btw.
>>>>
>>>>
>>>> I have D-Link too I don't see this. What kernel version is this? Is
>>>> this your ubuntu version or wireless-testing?
>>>> Any more data you can provide (.config. slabinfo)
>>>
>>> this is from wireless-testing. The Ubuntu 2.6.27 kernel is totally
>>> broken.
>>> It will crash the kernel since we are missing the patch to turn this into
>>> a
>>> warning :)
>>>
>>> Attached is my config. The slabinfo will follow once the SKB errors come
>>> up
>>> again. It normally takes a few hours before they show. Just resumed that
>>> machine.
>>
>> I've downloaded whole moblin last night over 2.6.27.4, it's a bit slow
>> because the missing calibrations but it didn't crashed.
>>
>> I will test your config, your machine is T61  am I right?
>
> I have a X61 and running the 64-bit version of kernel and userspace.

I found in sky2 driver comment

* The buffer returned from netdev_alloc_skb is
* aligned except if slab debugging is enabled

Since you have slub debug enabled, can you run this debug patch on
your system (might be withe space broken, I've  just pasted in)

diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c
b/drivers/net/wireless/iwlwifi/iwl-rx.c
index b86f958..1bfcc52 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -166,12 +166,17 @@ int iwl_rx_queue_update_write_ptr(struct
iwl_priv *priv, struct iwl_rx_queue *q)
        return ret;
 }
 EXPORT_SYMBOL(iwl_rx_queue_update_write_ptr);
+
+#define IWL_RX_DMA_MASK    (DMA_BIT_MASK(36) & ~0xFF)
 /**
  * iwl_dma_addr2rbd_ptr - convert a DMA address to a uCode read buffer ptr
  */
 static inline __le32 iwl_dma_addr2rbd_ptr(struct iwl_priv *priv,
                                          dma_addr_t dma_addr)
 {
+       if (WARN_ON(dma_addr & ~IWL_RX_DMA_MASK))
+               printk(KERN_ERR "wrong dma addr = %llu\n",
+                       (unsigned long long)dma_addr);
        return cpu_to_le32((u32)(dma_addr >> 8));
 }

Thanks
Tomas
