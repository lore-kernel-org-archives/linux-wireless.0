Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:49190 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1757768AbcJQH6t (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Oct 2016 03:58:49 -0400
Message-ID: <1476691113.3880.37.camel@coelho.fi> (sfid-20161017_095908_260636_B2C6C98C)
From: Luca Coelho <luca@coelho.fi>
To: David Binderman <dcb314@hotmail.com>,
        "johannes.berg@intel.com" <johannes.berg@intel.com>,
        "emmanuel.grumbach@intel.com" <emmanuel.grumbach@intel.com>,
        "linuxwifi@intel.com" <linuxwifi@intel.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 17 Oct 2016 10:58:33 +0300
In-Reply-To: <VI1PR08MB1022786893DC435E1A71F3069CD00@VI1PR08MB1022.eurprd08.prod.outlook.com>
References: <VI1PR08MB1022786893DC435E1A71F3069CD00@VI1PR08MB1022.eurprd08.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re:
 linux-4.9-rc1/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c:1561: poor
 error checking ?
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi David,
On Mon, 2016-10-17 at 07:40 +0000, David Binderman wrote:
> Hello there,
> 
> linux-4.9-rc1/drivers/net/wireless/intel/iwlwifi/mvm/debugfs.c:1561]: (style) Checking if unsigned variable 'len' is less than zero.
> 
> Source code is
> 
>     len = min((size_t)le32_to_cpu(rsp->len) << 2,
>           iwl_rx_packet_payload_len(hcmd.resp_pkt) - sizeof(*rsp));
>     len = min(len - delta, count);
>     if (len < 0) {
>         ret = -EFAULT;
>         goto out;
>     }
> 
> Suggest improve error checking.

Thanks for reporting! A fix for this is already queued in our internal
tree and will be sent upstream soon.

--
Cheers,
Luca.
