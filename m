Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33652 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756140AbbBIXDg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2015 18:03:36 -0500
Message-ID: <54D93A88.8090609@codeaurora.org> (sfid-20150210_000339_831745_30504983)
Date: Mon, 09 Feb 2015 14:54:00 -0800
From: Peter Oh <poh@codeaurora.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
	ath10k@lists.infradead.org
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 2/2] ath10k: Increase copy engine entries for rx wmi
References: <1423460814-2767-1-git-send-email-rmanohar@qti.qualcomm.com> <1423460814-2767-2-git-send-email-rmanohar@qti.qualcomm.com>
In-Reply-To: <1423460814-2767-2-git-send-email-rmanohar@qti.qualcomm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 02/08/2015 09:46 PM, Rajkumar Manoharan wrote:
> Having lower number of copy engine entries for target to host
> WMI ring is causing drops in receiving management frames. This
> issue is observed during max clients (128 clients) stress testing.
> While bursting deauthentication frames from simulated clients,
> approx. 70% of frames are getting dropped due to lower ring entries.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> ---
>   drivers/net/wireless/ath/ath10k/pci.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath10k/pci.c
> b/drivers/net/wireless/ath/ath10k/pci.c
> index e6972b0..f3174a6 100644
> --- a/drivers/net/wireless/ath/ath10k/pci.c
> +++ b/drivers/net/wireless/ath/ath10k/pci.c
> @@ -113,7 +113,7 @@ static const struct ce_attr host_ce_config_wlan[] = {
>   		.flags = CE_ATTR_FLAGS,
>   		.src_nentries = 0,
>   		.src_sz_max = 2048,
> -		.dest_nentries = 32,
> +		.dest_nentries = 128,
>   	},
>   
>   	/* CE3: host->target WMI */
> @@ -183,7 +183,7 @@ static const struct ce_pipe_config
> target_ce_config_wlan[] = {
>   	{
>   		.pipenum = __cpu_to_le32(2),
>   		.pipedir = __cpu_to_le32(PIPEDIR_IN),
> -		.nentries = __cpu_to_le32(32),
> +		.nentries = __cpu_to_le32(64),
Could you explain why the value of nentries are different?
>   		.nbytes_max = __cpu_to_le32(2048),
>   		.flags = __cpu_to_le32(CE_ATTR_FLAGS),
>   		.reserved = __cpu_to_le32(0),
Thanks,
Peter
