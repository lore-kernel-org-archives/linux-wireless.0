Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf1-f65.google.com ([209.85.167.65]:38759 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727652AbeIFW6v (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Sep 2018 18:58:51 -0400
Received: by mail-lf1-f65.google.com with SMTP id i7-v6so9906572lfh.5
        for <linux-wireless@vger.kernel.org>; Thu, 06 Sep 2018 11:22:10 -0700 (PDT)
Subject: Re: [RFC v5 01/12] ath10k: add struct ath10k_bus_params
To: Kalle Valo <kvalo@codeaurora.org>
Cc: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
References: <20180603182029.8914-2-erik.stromdahl@gmail.com>
 <20180906161624.B4751606FA@smtp.codeaurora.org>
From: Erik Stromdahl <erik.stromdahl@gmail.com>
Message-ID: <9de4aaff-a26c-cac3-bc73-069834820a14@gmail.com> (sfid-20180906_202214_343989_AAC49B68)
Date: Thu, 6 Sep 2018 20:22:08 +0200
MIME-Version: 1.0
In-Reply-To: <20180906161624.B4751606FA@smtp.codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On 9/6/18 6:16 PM, Kalle Valo wrote:
> Erik Stromdahl <erik.stromdahl@gmail.com> wrote:
> 
>> This struct is used as argument to ath10k_core_register in order to
>> make it easier to add more bus parameters in the future.
>>
>> Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
>> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> 
> 12 patches applied to ath-next branch of ath.git, thanks.
> 
> c0d8d565787c ath10k: add struct ath10k_bus_params
> 7c2dd6154fc2 ath10k: add device type enum to ath10k_bus_params
> 367c899f622c ath10k: add bus type check in ath10k_init_hw_params
> 9faaa14387fb ath10k: use hw_params.num_peers for num_tids in TLV init
> 4875e0b52085 ath10k: add per target config of max_num_peers
> e66d5361127a ath10k: DMA related fixes for high latency devices
> 852d1bf86a5b ath10k: add HTT TX HL ops
> d4e7f553eec3 ath10k: add HTT RX HL ops
> 4daacc950d4d ath10k: htt: RX ring config HL support
> a2097d6444c3 ath10k: htt: High latency TX support
> f88d49345040 ath10k: htt: High latency RX support
> 37f62c0d5822 ath10k: wmi: disable softirq's while calling ieee80211_rx
> 

I am afraid that one of the patches in this series causes a regression for PCI devices :(

The patch is:

4875e0b52085 ath10k: add per target config of max_num_peers

With this patch I got an error during driver load.
Reverting the patch solved the problem.

I discovered this yesterday when I was setting up a test AP with an ath10k pcie device.
I thought it would be a good idea to use my own tree just to make sure it works with PCI, and apparently it didn't work.
I did some bisecting and the patch mentioned above turned out to be the culprit.
I have not looked into why it fails yet (I think it is related to a bad num_peers value in the ath10k_hw_params_list array),
I just noticed that reverting the patch solved the problem

I was actually planning on submitting a v6 series with this patch removed, but you were faster.

I'll get back with more details about the error.

The device I have been using is QCA9880 based: Compex WLE900VX

--
Erik
