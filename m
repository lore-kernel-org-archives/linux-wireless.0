Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C750237180
	for <linux-wireless@vger.kernel.org>; Sun,  2 Aug 2026 18:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785696291; cv=none; b=omh02258p4Wiso6urn/ii+DIpTfT/WmgCjPd9S8AczE+pcJ+ZZn2wxs3/oy7y6KiH0UfLp5Ap79Pal/wZqfv/HkpjWwAZysDYUPRH8jbMChfiJseckSGhsnPfzjHgHjHeMLCtLd0jd8SEOoacVIw81UuA6KgdGQDrPQGjTQ37X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785696291; c=relaxed/simple;
	bh=BPIPPE7r1nPkNYCXvdy1C7CVlB5n073oAb0kfCSVkgs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=TEE/FrG8NEgTBH6Mqyw7JWhnht2l7AEI30RB9GIkuD1d6bmZMHhMjoCfpzg+VgXdOECRdxacCz5kl11qWpbjvdg2yvO3n9Ura+JcnC61FDU7o+0/ixfQ6CfbVphoTJz2Cd1b3eXNoS8OgcGw0Jt3yzfmKmcEoGlYmPFGjWWYkZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=postmarketos.org; spf=pass smtp.mailfrom=postmarketos.org; dkim=pass (2048-bit key) header.d=postmarketos.org header.i=@postmarketos.org header.b=LNd99H9n; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=postmarketos.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=postmarketos.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=postmarketos.org header.i=@postmarketos.org header.b="LNd99H9n"
Message-ID: <246dfa61-39b7-4658-a75a-8caed5a3628d@postmarketos.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=postmarketos.org;
	s=key1; t=1785696277;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HoAttZ6/pp+D3m/pGH5BI+qrxEqrSZSOjnAM2aZnyHM=;
	b=LNd99H9nS2nhZNnUbkO0y+yIvk1ycWcu1XjtIetoG8r3HQxMPHknmJNh/df18nKibAkV1l
	uT80ln54j96eHRtNIJ8NJSravanMKM5etkTwKUtlR+NUKkI2hKzLc6zjWeBAyvVt6Pq7YH
	JBZkAXTN+ZYS5flojiEN9Jcdp2geDT+6QA7K3/zYC2k7O8tew0bQL1+Gv4cdfKPaWScqlg
	JqYP+42Dl7VDwxnqLs50MrjGQ8uhrmb/ESR0I7KMyE/pNB6xcspMy3nW6Zc5/n/CutuxFp
	vDTbmvnGrj7POn+gvRUEr/ULctuczLULRfN7YBbayx/5rP1+sNBDBz+4oCqFvg==
Date: Sun, 2 Aug 2026 20:44:06 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] wifi: rsi: Fix types to appease CFI
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
 Stefan Hansson <newbie13xd@gmail.com>, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org, phone-devel@vger.kernel.org,
 ~postmarketos/upstreaming@lists.sr.ht
References: <20260802-rsi-cfi-fix-v1-1-5821d2cb54ee@postmarketos.org>
 <bdb87a52-80ba-4f74-94f1-cc01881e0c8a@oss.qualcomm.com>
Content-Language: sv-SE
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Stefan Hansson <newbyte@postmarketos.org>
In-Reply-To: <bdb87a52-80ba-4f74-94f1-cc01881e0c8a@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi Jeff,

On 02/08/2026 16:30, Jeff Johnson wrote:
> On 8/2/2026 5:22 AM, Stefan Hansson wrote:
>> Avoids errors like:
>>
>>      CFI failure at kthread+0x124/0x1cc (target: rsi_coex_scheduler_thread+0x0/0x1b4 [redpine_91x]; expected type: 0x89fb613d)
>>
>> As seen in the aforementioned error this was tested using the downstream
>> redpine_91x driver found in the Librem 5's downstream source tree.
>> However, it appears that this driver is a modified version of the rsi
>> driver found in mainline Linux and as such I decided to port the changes
>> here too.
>>
>> Signed-off-by: Stefan Hansson <newbyte@postmarketos.org>
> 
> Having fixed a ton of these issues in the Qualcomm Android downstream driver I
> was going to give my R-B, but I ran this through my ath.git patch acceptance
> process and it flagged some issues, starting with:
> > WARNING:FROM_SIGN_OFF_MISMATCH: From:/Signed-off-by: email address 
mismatch:
> 'From: Stefan Hansson <newbie13xd@gmail.com>' != 'Signed-off-by: Stefan
> Hansson <newbyte@postmarketos.org>'

I was struggling to get b4 send to work with the mail service we use for 
our postmarketOS email addresses but I have set up b4 relay now, so the 
v2 should not have this issue. Hope switching around the sender in a new 
revision is okay.

> There are also kernel-doc issues noted below
> 
>> @@ -246,12 +246,13 @@ EXPORT_SYMBOL_GPL(rsi_read_pkt);
>>   /**
>>    * rsi_tx_scheduler_thread() - This function is a kernel thread to send the
>>    *			       packets to the device.
>> - * @common: Pointer to the driver private structure.
>> + * @data: Pointer to the driver private structure.
>>    *
>>    * Return: None.
> 
> Return: 0
> 
>>    */
>> -static void rsi_tx_scheduler_thread(struct rsi_common *common)
>> +static int rsi_tx_scheduler_thread(void *data)
>>   {
>> +	struct rsi_common *common = data;
>>   	struct rsi_hw *adapter = common->priv;
>>   	u32 timeout = EVENT_WAIT_FOREVER;
>>   
> ...
>> diff --git a/drivers/net/wireless/rsi/rsi_91x_usb_ops.c b/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
>> index 25c2b232394a..513d2fdfb510 100644
>> --- a/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
>> +++ b/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
>> @@ -25,8 +25,9 @@
> 
> above here update the documentation: s/common/data/
> 
> Warning: drivers/net/wireless/rsi/rsi_91x_usb_ops.c:28 function parameter
> 'data' not described in 'rsi_usb_rx_thread'
> Warning: drivers/net/wireless/rsi/rsi_91x_usb_ops.c:28 Excess function
> parameter 'common' description in 'rsi_usb_rx_thread'
> 
>>    *
>>    * Return: None.
> 
> Return: 0
> 
>>    */
>> -void rsi_usb_rx_thread(struct rsi_common *common)
>> +int rsi_usb_rx_thread(void *data)
>>   {
>> +	struct rsi_common *common = data;
>>   	struct rsi_hw *adapter = common->priv;
>>   	struct rsi_91x_usbdev *dev = adapter->rsi_dev;
>>   	int status;

Regards,
Stefan Hansson
