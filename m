Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653C91C695
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 04:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784523427; cv=none; b=aNiREfOi2Zbxa1B97qsCZp7y9hYaTX82d2YQgk1GNXyqKmvGVxDWy+Hh3qOVv8O99mOnJ1RFPSJj2Fl5kecN3gFCuyh3uZFrLpkjX5hXHJq8qAJtd0m6RUvSBOQkrrmRbg6p22AnNaOMQQl9mMLN9eDbz0iN3qhQjLS59+mKgho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784523427; c=relaxed/simple;
	bh=EEwaoU9WdIQHPcfGEHfBBRcQq24f95kMcQhOubIikdc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GlT3Joi0khrvEPM/DVdPXeHVuRcWEN/QCFxsfZU/fiGw9HysnUTV80tHrKdmWFfi8fVAV2VN8lJ1G5spmC7UopVuokTefdGItZ+Qev4XRpKub9y/+jOAV+S7fKdPgJ7iQ38rAFIr2QRgvjQmHntWThC0B1Ttn/CmHSK/CJ4Kz8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=KHP1qJDc; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=dIJPoLi/; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="KHP1qJDc";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="dIJPoLi/"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66JNvNHU649802
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 04:57:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	FRrQMhaSHE5ysfv9c5H/fnVoIhtf3OGE9DY5JMBsZVE=; b=KHP1qJDcVULP1+Ne
	FRca72S4Fex6GfwpHjm64C3OaReU0GybrKKrO/dcg6GeDBaw36OXxwdnN+AwXGP8
	W9pCixs9kc66Kpb6wSUPdDRxbp9sUxmS2L8QdfCU+j0s/7W1BuBvi6HeB1uNqWzH
	yR4ygE7LQTv82AnMUzmHNSeH6H/Z6VyvysxRWHnEI9mv0wXqg7yVUGEGPx/kszKn
	GAIdbTuAMWVQuS8+M/Opx364bsA508H+jj1b65VkeR1Q3zbNFcDtCoc3GQKjV0XN
	/E4Fd7/px+JDWd3Sh4omkRHMtmPjVNnPeNOIwN57l4Dy845IWSmE6fpIP8ZhOsBN
	l0f0tw==
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fg2bvvd2k-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 20 Jul 2026 04:57:05 +0000 (GMT)
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2cc640dfde3so75115035ad.1
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 21:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784523425; x=1785128225; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FRrQMhaSHE5ysfv9c5H/fnVoIhtf3OGE9DY5JMBsZVE=;
        b=dIJPoLi/4KTXJLDaJZ2SoiELvax9hYMvtRd3UU1sfpCYbBHzX07hZTQESHf92DXFcj
         h6mFAtkhmxP2JarTJUfDEVuIxwTFg/mhYO4GdEKEC7UGM3hi7IMMm0pf3pRYXBIJ8sZ6
         q31VRKDhCScx7Ms5MibREVoh4Ou/6AZsK9uVzOqvir+qqBC2etGZhaFO+2QXKQ4LOE5t
         Fi8zdVPt/lsu7pg7wgS/2m7PC5np90ggD0AnU2xCGmUYYGH6VkNBrn1fU4t4KIhqIrZi
         teK41KNGKphi/GPT8ov4cX5/L2u2qjmDJc+OiyPuxQZoBmOpXJ1extnvlJDpM7yrcfy8
         vDpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784523425; x=1785128225;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FRrQMhaSHE5ysfv9c5H/fnVoIhtf3OGE9DY5JMBsZVE=;
        b=IRQ5npY7bYrTVjhREQsEl5xJ3XXVUwwbUunBG/rb7XcuBBXiwPQT85EjK4p0QGJywm
         CFQLZe+WawXEjQcP34QK2rmQrddGhIeqE4kxEalz0/zyOSt6lfRJdxVDncpNMLUaSzux
         VMVOr2lmg2ik7iQGeUHF4GrrrWfvC3xQa4s7g8A6BA1T1fNpbqGPD18TaVsX8rN6V/jz
         aIlf5paBSR0z3DbzifWVlt8Z8SOyIjqClszXGBCn1Y79yXAbrYBqqhEIXCiYMZvvks+w
         b980h/wa4eyhF3AZBodtdf4U7/nmtF7DQhgXRF8lZQyLyNQiYFKjBn9X9FgFREsKyX00
         os/A==
X-Gm-Message-State: AOJu0YwHVIspYMMrZRKSwDSW3+m+HC2gAKjAQ+TuKp4VzFGlsd2q8CQj
	EHOuM2R6I5ihOFkM8VvNOrqL8rsm09driDRm51L4YCCtWwZY564S3T+0POUwLD+FkIln2fPWCeO
	zlDTwjjU+mm46uKica0HmEjygeX4ZIUe2dPoNZ5Sc1yWC+hBeZ2OpcUpOQfMe3OVkyxc+YXFaMZ
	JKIg==
X-Gm-Gg: AfdE7cl2daoF0aZbEbcsgSIO+aiMI1eM72ToIk04mX03DlFL5iDHST4pPn3iKXiNFlc
	K5eeIU8JE8TLfblmVttIEAQtoTftvEXrfze8HJ4noUs9R4VsXRGuNtlvJhrIz8LLT1i3/rtwym9
	zkJUy6gQE9pJa0GS1fpUEZfstpfDcx1MxBAtM7Jx50Av0+I1Dpmv2jRbLZ9VKny4AbnRdOTkip7
	dIExbCIDimiG87C3/RhXUZ73Nr01Py237/C5FRXUMEoeLRS++uuokJrxXv27l/um5ZE2HlnonhE
	vGMEUR0VB9CtU4ckqG9ADjmYmEwNkRB3/ZdRRX4Apn9fsjLf/JVaM+xquqec0RIEMSZTK2C9QdZ
	2jM/xvi4euMyH/SGeEx8hGcUAjjrqCCZn
X-Received: by 2002:a17:90b:54c4:b0:38e:3a8:2374 with SMTP id 98e67ed59e1d1-38e4b5408c0mr11940743a91.30.1784523424525;
        Sun, 19 Jul 2026 21:57:04 -0700 (PDT)
X-Received: by 2002:a17:90b:54c4:b0:38e:3a8:2374 with SMTP id 98e67ed59e1d1-38e4b5408c0mr11940724a91.30.1784523423879;
        Sun, 19 Jul 2026 21:57:03 -0700 (PDT)
Received: from [10.206.105.147] ([202.46.23.25])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13ce2cbb7c5sm26267667c88.10.2026.07.19.21.57.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jul 2026 21:57:02 -0700 (PDT)
Message-ID: <8857cc85-ab3d-44de-8ddc-cb9a4c22709b@oss.qualcomm.com>
Date: Mon, 20 Jul 2026 10:26:48 +0530
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next v2] wifi: cfg80211: fix regulatory.db async
 firmware request blocking __usermodehelper_disable()
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
References: <20260629063159.3288957-1-kavita.kavita@oss.qualcomm.com>
Content-Language: en-US
From: Kavita Kavita <kavita.kavita@oss.qualcomm.com>
In-Reply-To: <20260629063159.3288957-1-kavita.kavita@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: K1MVOxtPj5VKlrfrX0Kbw5-1dLDYuncx
X-Authority-Analysis: v=2.4 cv=EcH4hvmC c=1 sm=1 tr=0 ts=6a5daaa1 cx=c_pps
 a=IZJwPbhc+fLeJZngyXXI0A==:117 a=ZePRamnt/+rB5gQjfz0u9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=YNKwprodQ3wtd-4D9IMA:9 a=QEXdDO2ut3YA:10
 a=uG9DUKGECoFWVXl0Dc02:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDA1MiBTYWx0ZWRfX1cCcNkoWmck4
 AK0G0XuCFnhtK45gO9d97wJiHz0E0mwejQoQ0u6AIDsq4UZxdLTgEUy7UCumAIOhodF6+IExWmN
 KRGDpnkkK7Zn2cUdLfkrRpHXvA6CURhHT9KDZVeMXB/0EB9zYCO61x8QDr2vjHEA/Q4zoNFnFnl
 GMINrm2TOvWPUA+pcwpfWsl7+cU25cmqgywooFRKsBixDh5pHw7uuiu24zFasezLp/FZ6izrpXY
 SisE0rF+maFCToBmJWpmnWLCToeb1UUFLGZxwm1TcgvBr0kyl1sgkXJkbWXey4EsSrzE28nyU/j
 JviAgoGC7inUBCycgsmNRZYQ2EUtc/CDesd+N1razDeToTmEygxTCbrKxjgh/zSvKeZ3yHzQl0/
 TUemNltL10Qopxrqd05rMHNyO2tUr7YyVN8axRENZ/ChTxejCixy6DEJv6qJZ8cP2tipQPUbTZJ
 CzqJBhds8s5qTRN/RVg==
X-Proofpoint-ORIG-GUID: K1MVOxtPj5VKlrfrX0Kbw5-1dLDYuncx
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIwMDA1MiBTYWx0ZWRfX0Lf4qU57+Z1U
 u/oSMXk3IGopoxTyOpzyhSx3CLKDAUJ0/2uwcwC2kXpePuYvHThyo+1GHyXcL6w9t0Y43puKNTl
 9r4V4V9tqklT5JsYA2+n68NEqItD110=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-19_08,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 suspectscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 phishscore=0 adultscore=0 malwarescore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607200052

Gentle Reminder!!



On 6/29/2026 12:01 PM, Kavita Kavita wrote:
> cfg80211 schedules an asynchronous request_firmware() work item for
> regulatory.db via request_firmware_work_func(). When the direct
> firmware load fails, _request_firmware() falls back to the sysfs
> fallback path via firmware_fallback_sysfs(), which blocks indefinitely
> in wait_for_completion_killable_timeout() waiting for userspace to
> supply the firmware through the sysfs interface.
> 
> While this work item is pending, any caller of
> __usermodehelper_disable() will deadlock attempting to acquire the
> usermodehelper rwsem for writing, since the sysfs firmware fallback
> path holds the rwsem for reading and is blocked waiting for userspace
> response that can never arrive while usermode helpers are being
> disabled.
> 
> Observed call traces where system suspend blocked due to regulatory.db
> async firmware request:
> 
>   kworker/6:3 (pid 194) holding usermodehelper rwsem read lock, blocked
>    waiting for userspace firmware response:
>      wait_for_completion_killable_timeout+0x48
>      firmware_fallback_sysfs+0x270
>      _request_firmware+0x790
>      request_firmware_work_func+0x44
>      process_one_work[jt]+0x59c
>      worker_thread+0x260
>      kthread+0x150
>      ret_from_fork+0x10
> 
>   Caller blocked in __usermodehelper_disable() during system suspend:
>      rwsem_down_write_slowpath+0x768
>      down_write+0x98
>      __usermodehelper_disable+0x3c
>      freeze_processes+0x18
>      pm_suspend+0x320
>      state_store+0x104
>      kernfs_fop_write_iter[jt]+0x168
>      vfs_write+0x270
>      ksys_write+0x78
> 
> Any service or kernel subsystem invoking __usermodehelper_disable() is
> susceptible to this hang as long as the regulatory.db sysfs fallback
> request remains outstanding.
> 
> Fix this by replacing the unconditional uevent-based load with a
> two-step approach. First, attempt a synchronous load via
> request_firmware_direct() at init time. This is fast and
> non-blocking, if the file is present in standard paths it is loaded
> immediately with no delay. If not found, the load is deferred to
> wiphy_regulatory_register() and triggered via
> firmware_request_nowait_nowarn() only when the first non-self-managed
> wiphy registers.
> 
> For self-managed drivers (REGULATORY_WIPHY_SELF_MANAGED), the hang is
> avoided because wiphy_regulatory_register() handles them separately
> and the deferred load path is never reached, so the file load is not
> attempted at all. For this case, regulatory information is obtained
> from driver/firmware during wiphy registration. For non-self-managed
> drivers, the file is required and is expected to be present. The
> deferred load via firmware_request_nowait_nowarn() is triggered only
> when the first such wiphy registers. This ensures the database is
> loaded only when it is actually needed, avoiding the sysfs fallback
> path on systems where the file is absent at init time.
> 
> Also refactor regdb_fw_cb() into two functions: regdb_load() which
> validates and stores the firmware image, and regdb_fw_cb_restore()
> which is the async callback that calls restore_regulatory_settings()
> to replay all pending regulatory requests (country hints from core,
> user, driver and country IE) that arrived while the database was not
> yet available.
> 
> NOTE:
> This issue was observed on Android platforms where regulatory.db is
> absent.
> Steps to reproduce on Android platforms:
>   1. Power off the device completely.
>   2. Connect the charger; the device enters off-mode charging.
>   3. While in off-mode charging, short press the power key.
> 
> Fixes: 007f6c5e6eb4 ("cfg80211: support loading regulatory database as firmware file")
> Signed-off-by: Kavita Kavita <kavita.kavita@oss.qualcomm.com>
> ---
> Changes in v2:
>  - Added Fixes Tag in commit.
> ---
>  net/wireless/reg.c | 132 ++++++++++++++++++++++++++-------------------
>  1 file changed, 78 insertions(+), 54 deletions(-)
> 
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 1e8214d6b6d8..d7b864d32ba1 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -988,78 +988,98 @@ static int query_regdb(const char *alpha2)
>  	return -ENODATA;
>  }
>  
> -static void regdb_fw_cb(const struct firmware *fw, void *context)
> +MODULE_FIRMWARE("regulatory.db");
> +
> +/* Validate and store firmware image as regdb. Used by all load paths. */
> +static int regdb_load(const struct firmware *fw)
>  {
> -	int set_error = 0;
> -	bool restore = true;
>  	void *db;
>  
> -	if (!fw) {
> -		pr_info("failed to load regulatory.db\n");
> -		set_error = -ENODATA;
> -	} else if (!valid_regdb(fw->data, fw->size)) {
> +	ASSERT_RTNL();
> +
> +	if (!valid_regdb(fw->data, fw->size)) {
>  		pr_info("loaded regulatory.db is malformed or signature is missing/invalid\n");
> -		set_error = -EINVAL;
> +		return -EINVAL;
>  	}
>  
> +	db = kmemdup(fw->data, fw->size, GFP_KERNEL);
> +	if (!db)
> +		return -ENOMEM;
> +
> +	regdb = db;
> +	return 0;
> +}
> +
> +static void regdb_fw_cb_restore(const struct firmware *fw, void *context)
> +{
> +	int err;
> +
>  	rtnl_lock();
> -	if (regdb && !IS_ERR(regdb)) {
> -		/* negative case - a bug
> -		 * positive case - can happen due to race in case of multiple cb's in
> -		 * queue, due to usage of asynchronous callback
> -		 *
> -		 * Either case, just restore and free new db.
> -		 */
> -	} else if (set_error) {
> -		regdb = ERR_PTR(set_error);
> -	} else if (fw) {
> -		db = kmemdup(fw->data, fw->size, GFP_KERNEL);
> -		if (db) {
> -			regdb = db;
> -			restore = context && query_regdb(context);
> -		} else {
> -			restore = true;
> -		}
> -	}
>  
> -	if (restore)
> +	/* Skip if a concurrent wiphy registration already loaded the db. */
> +	if (regdb && !IS_ERR(regdb))
> +		goto out_unlock;
> +
> +	/*
> +	 * Replay all pending regulatory hints that arrived while the
> +	 * database was not yet available, regardless of load outcome.
> +	 */
> +	if (!fw) {
> +		pr_info("failed to load regulatory.db\n");
> +		regdb = ERR_PTR(-ENODATA);
>  		restore_regulatory_settings(true, false);
> +		goto out_unlock;
> +	}
>  
> -	rtnl_unlock();
> +	err = regdb_load(fw);
> +	if (err)
> +		regdb = ERR_PTR(err);
>  
> -	kfree(context);
> +	restore_regulatory_settings(true, false);
>  
> +out_unlock:
> +	rtnl_unlock();
>  	release_firmware(fw);
>  }
>  
> -MODULE_FIRMWARE("regulatory.db");
> -
>  static int query_regdb_file(const char *alpha2)
>  {
> +	const struct firmware *fw;
>  	int err;
>  
>  	ASSERT_RTNL();
>  
> -	if (regdb)
> +	if (regdb && !IS_ERR(regdb))
>  		return query_regdb(alpha2);
>  
> -	alpha2 = kmemdup(alpha2, 2, GFP_KERNEL);
> -	if (!alpha2)
> -		return -ENOMEM;
> +	/*
> +	 * Load failed or async udev load in progress. If -EINPROGRESS,
> +	 * hints are preserved and replayed once the udev load completes.
> +	 */
> +	if (IS_ERR(regdb) && PTR_ERR(regdb) != -EINPROGRESS)
> +		return PTR_ERR(regdb);
>  
> -	err = request_firmware_nowait(THIS_MODULE, true, "regulatory.db",
> -				      &reg_fdev->dev, GFP_KERNEL,
> -				      (void *)alpha2, regdb_fw_cb);
> +	/*
> +	 * Preserve the hint if the file is not found on direct paths;
> +	 * an async udev load will be triggered on wiphy registration
> +	 * and will replay all pending hints on completion.
> +	 */
> +	err = request_firmware_direct(&fw, "regulatory.db", &reg_fdev->dev);
>  	if (err)
> -		kfree(alpha2);
> +		return 0;
> +	err = regdb_load(fw);
> +	release_firmware(fw);
> +	if (err) {
> +		regdb = ERR_PTR(err);
> +		return err;
> +	}
>  
> -	return err;
> +	return query_regdb(alpha2);
>  }
>  
>  int reg_reload_regdb(void)
>  {
>  	const struct firmware *fw;
> -	void *db;
>  	int err;
>  	const struct ieee80211_regdomain *current_regdomain;
>  	struct regulatory_request *request;
> @@ -1068,21 +1088,14 @@ int reg_reload_regdb(void)
>  	if (err)
>  		return err;
>  
> -	if (!valid_regdb(fw->data, fw->size)) {
> -		err = -ENODATA;
> -		goto out;
> -	}
> -
> -	db = kmemdup(fw->data, fw->size, GFP_KERNEL);
> -	if (!db) {
> -		err = -ENOMEM;
> -		goto out;
> -	}
> -
>  	rtnl_lock();
>  	if (!IS_ERR_OR_NULL(regdb))
>  		kfree(regdb);
> -	regdb = db;
> +	err = regdb_load(fw);
> +	if (err) {
> +		regdb = ERR_PTR(err);
> +		goto out_unlock;
> +	}
>  
>  	/* reset regulatory domain */
>  	current_regdomain = get_cfg80211_regdom();
> @@ -1103,7 +1116,6 @@ int reg_reload_regdb(void)
>  
>  out_unlock:
>  	rtnl_unlock();
> - out:
>  	release_firmware(fw);
>  	return err;
>  }
> @@ -4085,6 +4097,8 @@ void wiphy_regulatory_register(struct wiphy *wiphy)
>  {
>  	struct regulatory_request *lr = get_last_request();
>  
> +	ASSERT_RTNL();
> +
>  	/* self-managed devices ignore beacon hints and country IE */
>  	if (wiphy->regulatory_flags & REGULATORY_WIPHY_SELF_MANAGED) {
>  		wiphy->regulatory_flags |= REGULATORY_DISABLE_BEACON_HINTS |
> @@ -4097,6 +4111,16 @@ void wiphy_regulatory_register(struct wiphy *wiphy)
>  		 */
>  		if (lr->initiator == NL80211_REGDOM_SET_BY_USER)
>  			reg_call_notifier(wiphy, lr);
> +	} else if (!regdb) {
> +		/*
> +		 * regulatory.db not yet loaded; trigger an async udev
> +		 * request to load it when the first wiphy registers.
> +		 */
> +		if (!firmware_request_nowait_nowarn(THIS_MODULE,
> +						    "regulatory.db",
> +						    &reg_fdev->dev, GFP_KERNEL,
> +						    NULL, regdb_fw_cb_restore))
> +			regdb = ERR_PTR(-EINPROGRESS);
>  	}
>  
>  	if (!reg_dev_ignore_cell_hint(wiphy))
> 
> base-commit: 972c4dd19cb92e03d75b66c426cfade07582a1ba

