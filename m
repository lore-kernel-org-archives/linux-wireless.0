Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC4B43B3FB
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 12:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787229478; cv=none; b=eskoNOVkhVP7kXNt1hg+NY7PiJtoelM+QkI+6GIKQ7Tlet9gZeilSj/Sr86U+o/ZcLXzc2WvNiNpgRwzdye+VD2cxT/uCXcu3pXle/9SqZfIC0+FT6jdlp9kfK5SLjF6vvdbubBvoheFY654Ep2jwNR0AHshU1npMZ5CLn6qml0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787229478; c=relaxed/simple;
	bh=UCrvZDDTmo+QYnU7fvaZdmzgldTAAQxw6/JG7jwgwgc=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:References:
	 In-Reply-To:Content-Type; b=Fe7qfDxNj4vAALdjeph71gAokwpG6N2ONIdiKxhZqgoIq/SAcq6av28nFINlY2rakXw5JpTUljKBPqZfN8ozDK5IOfJblJLK0KrEiP4N0L14X788BjAjNvklBlMoqbfcDk9y8VpuYCRVfhMm6GMGUG3doeXzrJylbXS5+ebBUTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=V1qXJHmC; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=MxGvsJLp; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="V1qXJHmC";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="MxGvsJLp"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67K8KfYY1680228
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 12:37:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	6Ddo6WvT+kftbeXwJ9y5CABGvai4T6ssI5BD+OOeKAs=; b=V1qXJHmCb5in/+5v
	zqoxGVXSL75YTiAkwQj0vsLjAb00UEDNHVHklBOATRqrS7ZmNSDeGEo0NTce/nlA
	ib3nwJu1fx+Xvq/c/dlYaYwg8+fMzkfRSmr+Jxes9nMKiVQQVQ2vz8bhCr0yGENH
	zyAdQTADTwk1NzZQW2+n4znVv6rBIlc1EGgu7b02rNCn+kxMJBopthgRywUBYs1D
	2OMXlNUhK9HnkMbTNwg0hlVOodBhBJSL52DdLPsTQ81WaSHPvGqcayFOWFYwhi21
	Lt4QLNyl8z2SZJNpHZZctn8mX1gshEaWRdg6+NhXalwqWo4jiod8dbYzCgtiZXub
	cIctxA==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g5x05rxgr-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 12:37:55 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-930a098ea19so331582185a.1
        for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 05:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787229475; x=1787834275; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:to:subject:from:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6Ddo6WvT+kftbeXwJ9y5CABGvai4T6ssI5BD+OOeKAs=;
        b=MxGvsJLpAEssrteRifzkzoECRtvKCS8gSdAJmqnXQQ1eZ/O1M58Fi7251ERaWH+KcP
         Y8VkpTheur9tvt4gFLYQVT0Kn6e6RiuNzRKEMZGkNGWUWUJG9cpI8/3lg2tBoWC1PbnR
         vRmykLb9tF6qQucU5tSMIY0g8vWacKEljMntcGqNslg7fvUjUr1rnWbNB51bxdcikQWh
         owcGj6OPm6jfyjzu28VESbeRYsvrbdk1NofIQuBwyjTWxpfhSHlXKSP9whvU+BC8VRts
         OUP1IvM+VK8JzFFGf+rl760f+bCwuj7sZ89oVBree59kvzey4CaiZHIPXyey6i3ufUyP
         x7Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787229475; x=1787834275;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=6Ddo6WvT+kftbeXwJ9y5CABGvai4T6ssI5BD+OOeKAs=;
        b=b5yI/3XiDtskDwHOuJSCAZp042jXxez19hkvzHTAUU7aPC3fdV8KOuH0WNZjltDgSt
         MJZZTKFTFWfC9Qfpq7SkvH8XdAnCLKeGw9qHiFhub1bi0UEmpNP2fyiWLzBPrnrpJdWV
         9vyt5TOqOj1w2g4HUlEikJ4n6kssJsq3RrWyLXxIaxJfGL7r0bz0QmHAkplxyTiA/dba
         ri94W8bDYUsIFFpRKxoXkFkRhfgRF5BL6j31BVkvvyJ2+mBwVSaB9iGoo3CDk85qErva
         yDLmQgGJEdZ+ST+/OPQu2od/xuXoNXGNl47vq0/ridjohLCmupUmN6sB16+cK4OraCDR
         b8EA==
X-Forwarded-Encrypted: i=1; AHgh+RqCEMUx6qmje5CqAodCvRi6Z9fs90F7doLVNqSKtxMM4eF8529JJMYeSBPlMw3VB27U2JNYDPem8c9sZ8F5mg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxPJt48vvSYRploeIrPa6wS4kfEbcOQRXPZBLVDLGK28qcUlPn9
	srbJB2a4ssxSzcM21TE9BzUiyFkg8n5OtuHaOfjrj7H0n01spvWNB32DxUZMM8reajUhZduBbms
	aulqaJGh0H8j0C+c3qv6K9XkhMwHdy3kn1VYqDUv90z7ZE3/EU1oez84+OpaPnpgiQgJwTg==
X-Gm-Gg: AR+sD13hjXi4Eg4Gfpc6BeEzaa+g2WZ5VD3U62m9oiF5ig7cUQhYUBMuDIOC2EDH/6g
	U2Wo1L4eG64gcHZ8TW7VzdhatVOczsAhrtDz0SOD6vnAkm/5sAOnQ5NR4umb5seVWArKeLnOxsn
	374SIeQzytbOQq9y3Xmb98ZNuIDavXmzMiF7Vk6MApuDQgLPvvnYzRQVj5/QhJIq6lGyNXXjpf/
	porB8Xi35rl6vcV7Q0MeIxsFKDX/4HqXAJ500faLNjKaWQ0GSgpw4FxTcOQxClEWoUwwMyEK0ws
	5XQ9gmq5HyvQJ37eGMFiS5WR0OHo3CtYLDw8+JGXoY7HJ/pEgIdaPhPYWO0bRMoeqyykeka1UpN
	K2zoKEFZPtWHxfI6sBs69xYEgoz/+wwEG4MQ5t7tiR3hfSCZxG1tcnXnClwK6/y5xIsSN7hDa0X
	W6cAJUqaOIwVBM6LDUvMP3gHty61YzdjOZDN5rm/YrCVLZnjs6LhbC49y5fqYu08/oWDg=
X-Received: by 2002:a05:620a:2b4d:b0:932:dc4d:c755 with SMTP id af79cd13be357-9371e30f089mr1239514785a.15.1787229474430;
        Thu, 20 Aug 2026 05:37:54 -0700 (PDT)
X-Received: by 2002:a05:620a:2b4d:b0:932:dc4d:c755 with SMTP id af79cd13be357-9371e30f089mr1239506585a.15.1787229473734;
        Thu, 20 Aug 2026 05:37:53 -0700 (PDT)
Received: from ?IPV6:2001:1c00:c32:7800:5bfa:a036:83f0:f9ec? (2001-1c00-0c32-7800-5bfa-a036-83f0-f9ec.cable.dynamic.v6.ziggo.nl. [2001:1c00:c32:7800:5bfa:a036:83f0:f9ec])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c24589e2ab2sm63621366b.7.2026.08.20.05.37.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2026 05:37:52 -0700 (PDT)
Message-ID: <c461462f-de0b-43e8-ac9e-541013f5f8da@oss.qualcomm.com>
Date: Thu, 20 Aug 2026 14:37:51 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Hans de Goede <johannes.goede@oss.qualcomm.com>
Subject: Re: [PATCH v2 1/4] driver core: add device_schedule_reprobe()
To: Daniel Golle <daniel@makrotopia.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Danilo Krummrich <dakr@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Miri Korenblit <miriam.rachel.korenblit@intel.com>,
        driver-core@lists.linux.dev, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
References: <cover.1787185594.git.daniel@makrotopia.org>
 <08dc37c0d20896f5dc899a53c857935e91c6740f.1787185594.git.daniel@makrotopia.org>
Content-Language: en-US, nl
In-Reply-To: <08dc37c0d20896f5dc899a53c857935e91c6740f.1787185594.git.daniel@makrotopia.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: wChcdMUbLZznGNvOyEoGpEunxIDtzRhD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIwMDA5NCBTYWx0ZWRfXyR4+aMq/awiG
 eiH7LsjzDrZZrGc2cGsAiih7XgDReoafeQoe2zo4PdmUuaoqgDnNVIQDusbtxzIvuYvg3yiDuK7
 /fDoSFIBiW2lomuRjjJofvkdLH+QNN02AlbhHTnLlF2BdwSNg2GxRXmU+JKclHPXFjTXnN9IY46
 o7IxYZPTBOb7jFh17t3EsbFlBAdmTsZI7fcWeT52qzxGIy6kPT9mtb7bGGQk8f4mimWwCZDE9bQ
 qURFKSCV2merEM+fKsdrr2wxwkMZ03LGwEUc42+bIpuEX8n/TovdVVvlnTLHXkesgabGKhkIvSV
 HXNtNXwwYHJe4n13yN20KIM2QGyViy8voweo7oodMJSmU6t0D65d3htj1wj8FC2m7bkyqpdt99w
 YrqwtnY0J+3+zmoQB5v8v5zalLT7rDOyUHpoepsT64U83WnYjo2pqb1vIegWwsOhzcY+yyco7xH
 zS6n9wunfU09QoEsGLA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIwMDA5NCBTYWx0ZWRfX4/TtVC4Yb36e
 TVut/2ydpxDwwsf7xyA4+MDVWZ5wD5XmPt3+32Dh7CUwzdeDWlZtoeLOIvx0ScgE1VFa9mDtnC5
 OxPdf7jKbJ6ckmSoBZ/zUJrTS3wcBuY=
X-Authority-Analysis: v=2.4 cv=VfPH+lp9 c=1 sm=1 tr=0 ts=6a86f523 cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=VT4XjZGOAAAA:8
 a=EUspDBNiAAAA:8 a=hYbYuoZO4gQDBT1N23wA:9 a=QEXdDO2ut3YA:10
 a=IoWCM6iH3mJn3m4BftBB:22 a=6CpsfURP9XNmmWg3j1mJ:22
X-Proofpoint-GUID: wChcdMUbLZznGNvOyEoGpEunxIDtzRhD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-19_06,2026-08-19_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 phishscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 suspectscore=0 malwarescore=0 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608200094

Hi Daniel,

On 20-Aug-26 02:32, Daniel Golle wrote:
> Three in-tree drivers schedule a deferred re-probe of their own device
> from a work item whose work function lives in module text: iwlwifi
> (iwl_trans_schedule_reprobe(), firmware crash recovery when a lighter
> restart is not sufficient), hci_h5 (h5_btrtl_resume(), RTL devices
> lose their firmware state over suspend) and btintel_pcie (synchronous
> device_reprobe() from its own reset work, with a hand-rolled locking
> contract spanning several comments).
> 
> Two bug classes affect the hand-rolled implementations:
> 
> 1. The work function ends with put_device(); kfree();
>    module_put(THIS_MODULE); in module text. After the atomic decrement
>    a concurrent rmmod can free the module text before the function
>    epilogue has finished executing. This is exactly the race
>    module_put_and_kthread_exit() exists to close for kthreads; there
>    is no work-item equivalent.
> 
> 2. There is no synchronization between the deferred device_reprobe()
>    and device_shutdown() or a driver unbind. The drivers do not check
>    any bound state before calling device_reprobe(), so a stale
>    re-probe can undo an administrative unbind, and the detach half can
>    run against a device whose ->shutdown() callback has already run.
>    The core already blocks the attach half during shutdown
>    (device_shutdown() calls device_block_probing() before any
>    callback, and really_probe() honors defer_all_probes), but nothing
>    blocks the detach half. For drivers which clear their drvdata in
>    ->shutdown() so that a subsequent ->remove() becomes a no-op this
>    escalates to use-after-free of driver state which other subsystem
>    structures still reference.
> 
> Both classes disappear when the driver core owns the deferred work.
> Add device_schedule_reprobe(), which schedules a detach and re-probe
> of a device after a caller-specified delay:
> 
> - The work function is builtin text, so callers do not need to hold a
>   module reference. If the driver module is unloaded before the work
>   runs, driver_unregister() has already unbound the device, the bound
>   driver no longer matches the driver recorded at scheduling time and
>   the work does nothing.
> 
> - The recorded driver pointer is only ever compared, never
>   dereferenced, so it may legitimately point to freed memory.
> 
> - The bound-state check and __device_release_driver() run under a
>   single __device_driver_lock() hold, the same lock dance
>   device_release_driver_internal() uses. This closes the
>   check-vs-detach TOCTOU that drivers cannot close themselves,
>   because device_reprobe() takes the device lock internally.
> 
> - Both @dev and its parent are pinned for the lifetime of the work.
>   __device_driver_lock() and the attach half lock the parent, and an
>   unregister of @dev drops @dev's reference to the parent, so without
>   a reference of our own the parent could be freed before the work
>   runs.
> 
> - A new shutdown_done flag in struct device_private, set under the
>   device lock once device_shutdown() reaches a device, suppresses the
>   detach half during shutdown. It occupies a spare bit in an existing
>   byte, mirroring how kill_device() sets the dead flag.
> 
> - The attach half is plain device_attach(), which already honors both
>   the dead flag and defer_all_probes: a re-probe landing during
>   system suspend detaches immediately and the probe is deferred until
>   device_restore_probing() at resume time. The detach half
>   deliberately does not check defer_all_probes so that a re-probe
>   scheduled before suspend is not silently dropped. The parent is
>   re-locked across device_attach() on buses that set
>   need_parent_lock, mirroring bus_rescan_devices_helper().
> 
> One pre-existing window remains: __device_release_driver()
> transiently drops the locks while consumer device links are busy, so
> for devices with busy consumers a ->shutdown() can still interleave
> in the middle of the release. That window exists identically for
> every unbind path in the kernel, sysfs unbind included, and is not
> made worse by this helper.
> 
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> ---
>  drivers/base/base.h    |  5 +++
>  drivers/base/core.c    |  3 ++
>  drivers/base/dd.c      | 99 ++++++++++++++++++++++++++++++++++++++++++
>  include/linux/device.h |  2 +
>  4 files changed, 109 insertions(+)
> 
> diff --git a/drivers/base/base.h b/drivers/base/base.h
> index a5b7abc10ff0..6234e37de7e9 100644
> --- a/drivers/base/base.h
> +++ b/drivers/base/base.h
> @@ -106,6 +106,10 @@ struct driver_private {
>   * @dead: This device is currently either in the process of or has been
>   *	  removed from the system. Any asynchronous events scheduled for this
>   *	  device should exit without taking any action.
> + * @shutdown_done: Set once device_shutdown() has reached this device, under
> + *	  the device lock, before any shutdown callback runs. Read under the
> + *	  device lock. A deferred re-probe scheduled with
> + *	  device_schedule_reprobe() must not detach the device anymore.
>   *
>   * Nothing outside of the driver core should ever touch these fields.
>   */
> @@ -120,6 +124,7 @@ struct device_private {
>  	char *deferred_probe_reason;
>  	struct device *device;
>  	u8 dead:1;
> +	u8 shutdown_done:1;
>  };
>  #define to_device_private_parent(obj)	\
>  	container_of(obj, struct device_private, knode_parent)
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 4d026682944f..8a7dbe4e8362 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -4906,6 +4906,9 @@ void device_shutdown(void)
>  			device_lock(parent);
>  		device_lock(dev);
>  
> +		if (dev->p)
> +			dev->p->shutdown_done = true;
> +
>  		/* Don't allow any more runtime suspends */
>  		pm_runtime_get_noresume(dev);
>  		pm_runtime_barrier(dev);
> diff --git a/drivers/base/dd.c b/drivers/base/dd.c
> index 60c005223844..3394b1c7ed18 100644
> --- a/drivers/base/dd.c
> +++ b/drivers/base/dd.c
> @@ -1436,3 +1436,102 @@ void driver_detach(const struct device_driver *drv)
>  		put_device(dev);
>  	}
>  }
> +
> +struct device_reprobe {
> +	struct delayed_work work;
> +	struct device *dev;
> +	struct device *parent;
> +	const struct device_driver *drv;
> +};
> +
> +static void device_reprobe_work_fn(struct work_struct *work)
> +{
> +	struct device_reprobe *rp = container_of(work, struct device_reprobe,
> +						 work.work);
> +	struct device *dev = rp->dev;
> +	struct device *parent = rp->parent;
> +	bool detached = false;
> +
> +	__device_driver_lock(dev, parent);
> +	/*
> +	 * rp->drv is only ever compared, never dereferenced: the driver it
> +	 * points to may have been unregistered and freed by now.
> +	 */
> +	if (!dev->p->dead && !dev->p->shutdown_done &&
> +	    dev->driver && dev->driver == rp->drv) {
> +		__device_release_driver(dev, parent);
> +		detached = true;
> +	}
> +	__device_driver_unlock(dev, parent);
> +
> +	if (detached) {
> +		/*
> +		 * device_attach() must run with the parent locked on buses
> +		 * that require it, mirroring bus_rescan_devices_helper().
> +		 */
> +		if (parent && dev->bus->need_parent_lock)
> +			device_lock(parent);
> +		if (device_attach(dev) < 0)
> +			dev_err(dev, "re-probe failed, device left unbound\n");

Testing suspend/resume with a hci_h5 BT HCI which needs to be re-probed
at resume has shown that this may fail with -EPROBE_DEFER when run during
resume.

The probe does get successfully retried later and then everything works,
but this failure caused the dev_err() to log a spurious error.

So this should be switched to using dev_err_probe(), e.g.
squash in this:

--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -1451,6 +1451,7 @@ static void device_reprobe_work_fn(struct work_struct *work)
 	struct device *dev = rp->dev;
 	struct device *parent = rp->parent;
 	bool detached = false;
+	int ret;
 
 	__device_driver_lock(dev, parent);
 	/*
@@ -1471,8 +1472,9 @@ static void device_reprobe_work_fn(struct work_struct *work)
 		 */
 		if (parent && dev->bus->need_parent_lock)
 			device_lock(parent);
-		if (device_attach(dev) < 0)
-			dev_err(dev, "re-probe failed, device left unbound\n");
+		ret = device_attach(dev);
+		if (ret < 0)
+			dev_err_probe(dev, ret, "re-probe failed, device left unbound\n");
 		if (parent && dev->bus->need_parent_lock)
 			device_unlock(parent);
 	}

With that fixed this looks good to me:

Tested-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>

Regards,

Hans






> +		if (parent && dev->bus->need_parent_lock)
> +			device_unlock(parent);
> +	}
> +
> +	put_device(dev);
> +	put_device(parent);
> +	kfree(rp);
> +}
> +
> +/**
> + * device_schedule_reprobe - schedule a deferred detach and re-probe
> + * @dev: device to detach and re-probe
> + * @delay_ms: delay in milliseconds before the re-probe runs
> + *
> + * Schedule a detach and re-probe of @dev after @delay_ms milliseconds.
> + * The re-probe is skipped if, by the time the scheduled work runs, the
> + * device has been removed, the system shutdown sequence has reached the
> + * device, or @dev is no longer bound to the driver that was bound at
> + * scheduling time. In particular an administrative unbind is never
> + * undone by a stale re-probe.
> + *
> + * The work function is built-in text, so the bound driver may call this
> + * from its own code without holding a module reference. If the driver
> + * module is unloaded before the work runs, driver unregistration unbinds
> + * @dev first and the scheduled work does nothing.
> + *
> + * Multiple pending re-probes for the same device are individually safe;
> + * a caller that wants at most one pending re-probe must gate scheduling
> + * itself.
> + *
> + * May only be called from process context.
> + *
> + * Returns: 0 on success, -EINVAL if @dev is not a registered device
> + * bound to a driver, -ENOMEM on allocation failure.
> + */
> +int device_schedule_reprobe(struct device *dev, unsigned int delay_ms)
> +{
> +	struct device_reprobe *rp;
> +
> +	if (!dev->bus || !dev->p || !device_is_registered(dev))
> +		return -EINVAL;
> +	if (!dev->driver)
> +		return -EINVAL;
> +
> +	rp = kzalloc_obj(*rp);
> +	if (!rp)
> +		return -ENOMEM;
> +
> +	rp->dev = get_device(dev);
> +	/*
> +	 * Pin the parent too: the work locks it, and an unregister of @dev
> +	 * would otherwise drop the last reference before the work runs.
> +	 */
> +	rp->parent = get_device(dev->parent);
> +	rp->drv = READ_ONCE(dev->driver);
> +	INIT_DELAYED_WORK(&rp->work, device_reprobe_work_fn);
> +	queue_delayed_work(system_dfl_wq, &rp->work,
> +			   msecs_to_jiffies(delay_ms));
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(device_schedule_reprobe);
> diff --git a/include/linux/device.h b/include/linux/device.h
> index aee79fd6b32b..7a9916950577 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -1314,6 +1314,8 @@ int  __must_check device_attach(struct device *dev);
>  int __must_check driver_attach(const struct device_driver *drv);
>  void device_initial_probe(struct device *dev);
>  int __must_check device_reprobe(struct device *dev);
> +int __must_check device_schedule_reprobe(struct device *dev,
> +					 unsigned int delay_ms);
>  
>  bool device_is_bound(struct device *dev);
>  

