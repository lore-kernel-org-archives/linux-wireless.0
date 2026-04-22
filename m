Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6376F30E0C0;
	Wed, 22 Apr 2026 14:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776867809; cv=none; b=Ze7XD1IN9MUKNEu/7gaiywPbYg1ZfTZc75VkgIJD5oVqaeuKsPVOck7CpO7Y7zqV2KN5IO6JSK5n5fKfq67tGAdLOq9D4N66YKbQifmTqvILebNrqP4twHLVaY/GgfWNNnlmO5uPjk7WfEN+J/WPiVExi21cgTA4xy6CqMRXA5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776867809; c=relaxed/simple;
	bh=4xmE6LBI0sScIwfaVkGq0SafBNzd2O9CCu8v+/GUzNI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AwM0qmQ34reDewhFDZhGGw7XPJlHmr5YEV6lTewogcPjF7AbBuffRGuoh9PvfSi4aEhNPF5p/GKmR+2J9C1DHVj5HZ3Xzn+LV8fyqpYBAtYRpls+TAvyIXCXi38IsmUXWBDtbJld8L1FSrYdZaNNVfrOzYCPAhnO95V0lf7C/xk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=lU0NPNP6; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=czcPPcto; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="lU0NPNP6";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="czcPPcto"
Date: Wed, 22 Apr 2026 16:23:25 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1776867806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MTItmSKJevrRTerdc3R+aPw8HIJ4fgrUwrhkwX2FGZY=;
	b=lU0NPNP6aEESM9TR50ruLBAEZtUW3RHIPtLcXUJ655A7Ejg7+fRht/IoERer53JDSpTgn/
	8ghN1wXmZ+rqg12RpwJD3g97Rw/tzUFjFjXj+yvopgMNh7Mhjqm5zdrzNDD0IsdaZEr46y
	Z8rGC1FS6pOIylUGg0r6xHJa5+MwKMQzNAssfzhFAdEDMopL9QS8JvndBE5SCs9jWBBTYm
	tNBG2rGnhhkZIvw/wj8dr6Qw5o8BusPhEN4NjXQTVSJmRFkA7LnN0Q0Tw3kJmT5QQv4kpz
	ps0SH4jyQy7/ZTNdWa2NgUE7FkRp8mAnAEDG9gaPWa3aJ+pqqjk/Edf5Vaevhw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1776867806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MTItmSKJevrRTerdc3R+aPw8HIJ4fgrUwrhkwX2FGZY=;
	b=czcPPctozdzNm3TMqVBPnWsUXaVlHnvFeJMr6JzTxw7xbAFL/Wmj5jBhWQ5DueUndR6bw4
	kT0JU1OkDMItRnAQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Yu-Hsiang Tseng <asas1asas200@gmail.com>
Cc: Jeff Johnson <jjohnson@kernel.org>, ath12k@lists.infradead.org,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Rameshkumar Sundaram <quic_ramess@quicinc.com>,
	Kalle Valo <kvalo@kernel.org>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v2] wifi: ath12k: fix false positive RCU warnings on
 PREEMPT_RT
Message-ID: <20260422142325.Glnd_2Zc@linutronix.de>
References: <4cdf2e61-fe69-4168-9df7-55bb71585dfe@oss.qualcomm.com>
 <20260421172500.1050754-1-asas1asas200@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260421172500.1050754-1-asas1asas200@gmail.com>

On 2026-04-22 01:25:00 [+0800], Yu-Hsiang Tseng wrote:
> Two functions in ath12k assert that the caller holds an RCU read lock:
> ath12k_mac_get_arvif() and ath12k_p2p_noa_update_vdev_iter(). Both use:
> 
>     WARN_ON(!rcu_read_lock_any_held());
> 
> On PREEMPT_RT kernels built with CONFIG_PROVE_RCU=n, this produces a
> false positive splat whenever these functions are invoked from paths
> that do hold the RCU read lock (e.g. firmware stats processing or
> mac80211 interface iteration).

It depends what RCU section is expected/ tested for. SMP+preempt can use
preemptible RCU which does not disable preemption either. So this is not
PREEMPT_RT specific. It would be PREEMPT_RT specific if the RCU section
is implied by NAPI processing to so.

> Root cause:
> 
>   - On !PROVE_RCU, rcu_read_lock_any_held() is a static inline that
>     returns !preemptible() as a proxy for "in an RCU read section".
> 
>   - On PREEMPT_RT, rcu_read_lock() does not disable preemption. A
>     task can therefore be preemptible while legitimately holding an
>     RCU read lock.

As elaborated above, this is not PREEMPT_RT specific but preemptible
TREE RCU.

>   - Callers such as ath12k_wmi_tlv_rssi_chain_parse() (via guard(rcu)())
>     and ieee80211_iterate_active_interfaces_atomic() do hold the RCU
>     read lock, so these warnings are incorrect.

If both this then use this then I guess something like
	lockdep_assert_in_rcu_read_lock()

is what you look for.

> Typical splat seen on a WCN7850 station with periodic fw stats
> processing:
> 
>   WARNING: drivers/net/wireless/ath/ath12k/mac.c:791 at
>     ath12k_mac_get_arvif+0x9e/0xd0 [ath12k]
>   Tainted: G W O 6.19.13-rt #1 PREEMPT_RT
>   Call Trace:
>    ath12k_wmi_tlv_rssi_chain_parse+0x69/0x170 [ath12k]
>    ath12k_wmi_tlv_iter+0x7f/0x120 [ath12k]
>    ath12k_wmi_tlv_fw_stats_parse+0x342/0x6b0 [ath12k]
>    ath12k_wmi_op_rx+0xe9e/0x3150 [ath12k]
>    ath12k_htc_rx_completion_handler+0x3df/0x5b0 [ath12k]
>    ath12k_ce_per_engine_service+0x325/0x3e0 [ath12k]
>    ath12k_pci_ce_workqueue+0x20/0x40 [ath12k]

If that is the call chain and there are no spinlocks involved then
PREEMPT+SMP+lockdep should trigger with this patch, too. The suggestion
above restricts this to lockdep only but your patch does so to.

Sebastian
