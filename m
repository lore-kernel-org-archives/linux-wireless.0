Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48771 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932981AbbEEF1E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 May 2015 01:27:04 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com,
	Vladimir Shulman <QCA_shulmanv@QCA.qualcomm.com>
Subject: Re: [PATCH v2 5/7] wil6210: Add pmc debug mechanism memory management
References: <1430400311-3861-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	<1430400311-3861-6-git-send-email-qca_vkondrat@qca.qualcomm.com>
Date: Tue, 05 May 2015 08:26:56 +0300
In-Reply-To: <1430400311-3861-6-git-send-email-qca_vkondrat@qca.qualcomm.com>
	(Vladimir Kondratiev's message of "Thu, 30 Apr 2015 16:25:09 +0300")
Message-ID: <87oalzvbkv.fsf@kamboji.qca.qualcomm.com> (sfid-20150505_072805_863155_F7DA4760)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com> writes:

> Pmc is a hardware debug mechanism which allows capturing phy data,
> packets, and internally generated events and messages synchronized
> and time stamped by the hardware. It requires memory buffers
> allocated by the driver in order to be used by hardware dma to
> upstream real time debug data to host memory.
> Driver will handle memory allocation and release, and fetching
> the data from the memory to application layer via debug file
> system. The configuration of pmc is handled entirely by the
> application layer.
>
> Signed-off-by: Vladimir Shulman <qca_shulmanv@qca.qualcomm.com>
> Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

kbuild found warnings, can you please send a followup patch to fix
these:

   In file included from include/linux/printk.h:275:0,
                    from include/linux/kernel.h:13,
                    from include/linux/list.h:8,
                    from include/linux/wait.h:6,
                    from include/linux/fs.h:6,
                    from drivers/net/wireless/ath/wil6210/pmc.c:19:
   drivers/net/wireless/ath/wil6210/pmc.c: In function 'wil_pmc_alloc':
>> drivers/net/wireless/ath/wil6210/pmc.c:97:8: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
           (void *)pmc->pring_pa,
           ^
   include/linux/dynamic_debug.h:95:12: note: in definition of macro 'dynamic_netdev_dbg'
             ##__VA_ARGS__);  \
               ^
>> drivers/net/wireless/ath/wil6210/wil6210.h:647:2: note: in expansion of macro 'netdev_dbg'
     netdev_dbg(wil_to_ndev(wil), fmt, ##arg); \
     ^
>> drivers/net/wireless/ath/wil6210/wil6210.h:654:40: note: in expansion of macro 'wil_dbg'
    #define wil_dbg_misc(wil, fmt, arg...) wil_dbg(wil, "DBG[MISC]" fmt, ##arg)
                                           ^
>> drivers/net/wireless/ath/wil6210/pmc.c:94:2: note: in expansion of macro 'wil_dbg_misc'
     wil_dbg_misc(wil,
     ^
   In file included from drivers/net/wireless/ath/wil6210/pmc.c:21:0:
>> drivers/net/wireless/ath/wil6210/pmc.c:97:8: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
           (void *)pmc->pring_pa,
           ^
   drivers/net/wireless/ath/wil6210/wil6210.h:648:28: note: in definition of macro 'wil_dbg'
     wil_dbg_trace(wil, fmt, ##arg); \
                               ^
>> drivers/net/wireless/ath/wil6210/pmc.c:94:2: note: in expansion of macro 'wil_dbg_misc'
     wil_dbg_misc(wil,
     ^

-- 
Kalle Valo
