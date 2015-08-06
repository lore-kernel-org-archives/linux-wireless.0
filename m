Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:49394 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbbHFGqI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2015 02:46:08 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, wil6210@qca.qualcomm.com
Subject: Re: [PATCH v3 00/19] wil6210 patches
References: <1438253527-3372-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Date: Thu, 06 Aug 2015 09:46:01 +0300
In-Reply-To: <1438253527-3372-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	(Vladimir Kondratiev's message of "Thu, 30 Jul 2015 13:51:48 +0300")
Message-ID: <87k2t8zzh2.fsf@kamboji.qca.qualcomm.com> (sfid-20150806_084613_061210_BD6917D7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vladimir Kondratiev <QCA_vkondrat@QCA.qualcomm.com> writes:

> Several new features introduced:
> - TSO improves throughput on Tx side on systems with weak CPU
> - ACS chooses best channel automatically when starting AP
> - support for the new boot loader
>
> Bug fixes:
> - "wait for del_station to complete"
> - "hold wil->mutex while managing vrings"
>
> The rest are small fixes and improvements
>
> V2: found bug in the commit for TSO - by mistake, reported was
> NETIF_F_IP_CSUM and NETIF_F_IPV6_CSUM. Re-sending whole series
> to avoid confusion
>
> v3: re-sending whole patch series.
> Dropped is ACS with vendor specific implementation
> Also dropped is patch "hold wil->mutex while managing vrings",
> logical issue found with this patch and it should be redesigned
> Added couple of minor patches for the boot loader
>
> Dedy Lansky (1):
>   wil6210: treat "unhandled event" as warning instead of error
>
> Vladimir Kondratiev (17):
>   wil6210: support boot loader struct v0 & v1
>   wil6210: count drops in Rx block ack reorder
>   wil6210: print "ulong" fields in hex format in the debugfs
>   wil6210: use <> vs. "" for global include
>   wil6210: wait for del_station to complete
>   wil6210: use wil_fw_error_recovery()
>   wil6210: skip HW version check for chip debugging
>   wil6210: TSO implementation
>   wil6210: improve mgmt frame handling
>   wil6210: sort IEs handling
>   wil6210: unify wmi_set_ie() error handling
>   wil6210: detailed statistics for Rx reorder drop
>   wil6210: remove 3-MSI support
>   wil6210: use inline functions for register access
>   wil6210: system power management
>   wil6210: report boot loader error
>   wil6210: support future boot loaders
>
> Vladimir Shulman (1):
>   wil6210: allow to handle Rx on 2 cores

Thanks, all patches applied to ath.git.

-- 
Kalle Valo
