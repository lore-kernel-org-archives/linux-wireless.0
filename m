Received: from mail.mokrynskyi.com (mail.mokrynskyi.com [65.109.39.229])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56201F3BA4
	for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2026 03:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.39.229
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783914029; cv=none; b=a0+lS/Y+kSBgIHFFX2hDSnynbDo5xkLM8UJjshWWuI9HJRQbBCrxi1fTK9VZJf9dZiESppBRyS3yUq6pgfufBFDO5jsVb70Nl0iM5TiCUDz66gSwnJ9xqfXOf/5hWeu7THGzUkpQ7WREzLaLtuqr+LAbMWlvAen/IMCCRY3HqcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783914029; c=relaxed/simple;
	bh=Ncw22CpgIicW10sn4M6BBpLsecOSRhXqXnK7BKihxpM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iHOGCs42VnGKPa2uMAS6iQFuhqNHsrURalJraKUVaw18wpjRkLcp/UeHm7f8oLd3RqyNfLv/sRCoNPFCtwjX6I858oBdMHEL25T8deEAmH5gb544sgiEigCr+vHgq+H6mIZPs9kbHA2GNB+twQsPO8ZPjpciG9e2XqZ6GYP/eaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mokrynskyi.com; spf=pass smtp.mailfrom=mokrynskyi.com; dkim=pass (2048-bit key) header.d=mokrynskyi.com header.i=@mokrynskyi.com header.b=t6TVRoIM; arc=none smtp.client-ip=65.109.39.229
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mokrynskyi.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mokrynskyi.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mokrynskyi.com header.i=@mokrynskyi.com header.b="t6TVRoIM"
Message-ID: <2dd63a14-6daf-42f8-9eb9-60596b30583a@mokrynskyi.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mokrynskyi.com;
	s=dkim; t=1783913680;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WJMfk3Njo6igrjkkDYvlK+PoNmEoME2tim5+B/Vy6jI=;
	b=t6TVRoIMQ44etF0RxUgcM3A+sVPgjPPlLwQR8YqitGWvhHdrPK5svnknwE7aUisaoVaehw
	kZfr9XHPZpDbFHB7x/ol+2x9ECGv3Xe9HI5U0pIUWM6IGv2Ckm35wmG5HJ/Rj/PJ4BBAAs
	+o6ez0M+TZSlAOHEQz++pk9PdVW29VRtWD7a42n24yEDnGtcThCVBQnnea28oPZUpJqacw
	KPGZJpAuS2AFi0a/ZNgxo7OIptKhsHZkFkF9x88MUn73nDqJSUEZC75AfgAURyrMrnp4em
	IkQ0qjKOOOQzjSIvXbBkFOlMnrbgTLYpzCU5qQ42vOFRsMP5QMP7zRMqIgb8rQ==
Authentication-Results: mail.mokrynskyi.com;
	auth=pass smtp.mailfrom=nazar@mokrynskyi.com
Date: Mon, 13 Jul 2026 06:34:36 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] wifi: ath12k: skip PCIe global reset on initial
 power-up
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>, ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, jeff.johnson@oss.qualcomm.com
References: <20260505172415.566328-1-nazar@mokrynskyi.com>
 <20260505172415.566328-2-nazar@mokrynskyi.com>
 <fe668799-6024-4370-acfc-ee64fb3a4d5c@oss.qualcomm.com>
Content-Language: en-US, uk, uk-UA
From: Nazar Mokrynskyi <nazar@mokrynskyi.com>
In-Reply-To: <fe668799-6024-4370-acfc-ee64fb3a4d5c@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Bar: ---

The patches I sent only allow VM to start once.
Any attempt to shutdown or reboot the VM results in host crashing instantly due to PCIe errors.

The only way to somewhat gracefully reboot the host that I found is to unbind corresponding host bridge first (so it doesn't propagate PCIe error), then kill the VM (instead of attempting to shut down gracefully) and then reboot the host.

This is not great, but still much better than not being able to use the hardware at all. These cards were paperweight for me for far too long.
I've been running a system with these patches for probably close to 3 months now and have not found other issues except performance is not that great.

I sent a suggestion to allow ignoring PCIe errors in vfio so it doesn't crash the host here: https://lore.kernel.org/kvm/70de9b8f-b7c7-481b-8cb1-931e3b82eb0e@mokrynskyi.com/
But maintainers weren't too happy about it.

While searching for that thread I found this recent development, which looks related to the issues I'm having: https://lkml.org/lkml/2026/6/30/398

Sincerely, Nazar Mokrynskyi
github.com/nazar-pc

13.07.26 06:03, Baochen Qiang:
>
> On 5/6/2026 1:24 AM, Nazar Mokrynskyi wrote:
>> ath12k_pci_sw_reset() unconditionally calls ath12k_pci_soc_global_reset()
>> regardless of whether the device is being powered up for the first time or
>> recovering from a previous run. The global reset drops the PCIe link and
>> relies on the host root complex to perform physical link retraining before
>> the MHI BHI register can be accessed.
>>
>> When the device is passed through to a VM via VFIO, no physical link
>> retraining occurs after the reset since QEMU's virtual PCIe bridge does
>> not implement hardware LTSSM negotiation. As a result, all subsequent
>> MMIO reads return 0xffffffff and MHI initialization fails with -EREMOTEIO.
>>
>> On initial power-up, vfio-pci has already performed a Function Level
>> Reset before handing the device to the guest driver, placing it in a
>> known clean state equivalent to what the global reset achieves. The global
> AFAIK this is not the fact. Some internal registers are not cleanly reset without a global
> reset.
>
>> reset is therefore redundant on power-up and only necessary on the
>> shutdown/recovery path where it tears down an already-running firmware.
> is ath12k recovery working in Qemu in your setup? I doubt it since recovery would also hit
> the link retraining issue ? Also how about the rmmod / insmod sequence in Qemu, since
> rmmod also triggers global reset ?
>
> To me this is more like a Qemu/vfio issue than a driver issue. The QEMU's behavior that
> virtual PCIe bridge does not implement hardware LTSSM negotiation basically breaks all
> hardware requiring runtime PCIe link retraining. Not sure why it is designed like this. If
> it can not be fixed/changed in Qemu, can we do it in the host vfio?
>
>> Skip ath12k_pci_soc_global_reset() when power_on is true to allow MHI
>> initialization to succeed under VFIO passthrough without affecting bare
>> metal behavior.
>>
>> Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
>>
>> Signed-off-by: Nazar Mokrynskyi <nazar@mokrynskyi.com>
>> ---
>>  drivers/net/wireless/ath/ath12k/pci.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
>> index 375277ca2..a3d7aeb72 100644
>> --- a/drivers/net/wireless/ath/ath12k/pci.c
>> +++ b/drivers/net/wireless/ath/ath12k/pci.c
>> @@ -303,7 +303,8 @@ static void ath12k_pci_sw_reset(struct ath12k_base *ab, bool power_on)
>>  
>>  	ath12k_mhi_clear_vector(ab);
>>  	ath12k_pci_clear_dbg_registers(ab);
>> -	ath12k_pci_soc_global_reset(ab);
>> +	if (!power_on)
>> +		ath12k_pci_soc_global_reset(ab);
>>  	ath12k_mhi_set_mhictrl_reset(ab);
>>  }
>>  
