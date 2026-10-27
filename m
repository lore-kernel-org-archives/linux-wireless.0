Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793143632;
	b=SOQw208Hft5KbM4G/YvlKSHzjy6wsCucMEsnOeXvAlXZdLkWOl3FaoUN+5oQl3oePBsD
	 3bOsCPFm6KEtk+i3a6njQpVwwVozP085B/3Lb10vvCUqmF+crVoTNfC8HEFA5HG14K3NS
	 xDg4piy76guTHc4LfA22sCBIV2byTCL0CncUr2b5soo+iRtptswc0mh6gmi10ENPKoikR
	 0bTVhV5We6OqaVPTC2bugMWA75B3gFMutEA2g6vVYKwtMjENoB9wEjX9nHRXLYsltooy1
	 KOeffsK1tM4oOMjbawozNpuBNediL/XLQU0ZKsHa3NIWB1ulk52C819w/m+brX144tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793143632;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=6PiYxlEEX0HQs1enBKQ/4zeLAPHx1PfbUOEoP+WBVLo=;
	b=cd1zlw8gt+kS9x7qPo3yXkh/Q47HeTaVyWgrFiySTyho0hamKBrEg5FeItkYoxuDqKh0
	 35y3preCguL6Inu7Ad2/6KAdE4Kl8nYHKg1gQQaHe+cGBeTR3ZHmFGM6ILv4HciyfinKB
	 c7I5KVdfD5G7eL0a2D9+/8/MIqY2n1kffkMcQN36JdF4N2g/TyjsU3OVUxeQWnpdbePuG
	 qtOWCsB7W8VZtWrUtE0pD7D+l/Oy7G2wRyX1fQ1dsxrV6f7AMiYobye1DKiIQ8zsBzK3d
	 9W2FeXIKPWFi96Us9IYz6VtWiMW336LqNXalhw9+5RWhBwV1KeJ00rJq2hEv3R4VFKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QWMkrCgA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7319D606A31A;
	Tue, 27 Oct 2026 23:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QWMkrCgA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60D31F01825;
	Tue, 27 Oct 2026 23:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793143632;
	bh=6PiYxlEEX0HQs1enBKQ/4zeLAPHx1PfbUOEoP+WBVLo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=QWMkrCgAZV0PjW43souxOJIGFHjjAKD6FO1vIC2Uhw2W6YQJaCgcdJ/cUqogWd/8g
	 NylE37jKgsHEFuq2D7pxCrPKzt5NsqVTaxrI9UARVAt8lUBEQqk0ir2kOad/Xpv7Ft
	 TsbGd8MvFlaMK349wO2PB+0LPa0nDhNL3XDQR3pVXZ0ku9Bm6b7U//GsNpeqoaVnWE
	 S4hpJcMpULzC1NxSJTmv3FCrN1j8C+CwLWKOGOU1l4lg76wXxmMJB0tdYaB3hHfgaN
	 tNJ+Mulsbv6gcNCv7nNP5GbgSRpRQ3FbjHFE5oM/4wgjGOJDFw2Ga0q3YgMWMuMOv+
	 vEiklsRVlCYmA==
Date: Tue, 27 Oct 2026 16:27:10 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Cosmin Ratiu <cratiu@nvidia.com>
Cc: <linux-wireless@vger.kernel.org>, Johannes Berg
 <johannes@sipsolutions.net>, Tariq Toukan <tariqt@nvidia.com>, Carolina
 Jubran <cjubran@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>,
 <netdev@vger.kernel.org>
Subject: Re: [PATCH wireless v2] wifi: wext: Limit notifier event flushes to
 the device's netns
Message-ID: <20261027162710.34e0e17c@kernel.org>
In-Reply-To: <20261023081044.728500-1-cratiu@nvidia.com>
References: <20261023081044.728500-1-cratiu@nvidia.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 23 Oct 2026 11:10:44 +0300 Cosmin Ratiu wrote:
> With mlx5 netdev instance locking enabled, registering an IPoIB netdev
> calls the WEXT notifier while holding the instance mutex. Its call to
> wireless_nlevent_flush() takes net_rwsem to walk every namespace,
> completing the following lockdep dependency cycle:
> 
>   netdev instance mutex -> net_rwsem (read) -> GID table mutex
>     -> event_handler_rwsem (read) -> netdev instance mutex  
> 
> RoCE GID enumeration takes the GID table mutex under net_rwsem. GID
> updates dispatch events under the table mutex, taking event_handler_rwsem.
> The IPoIB event handler takes the netdev instance mutex in
> ipoib_queue_work() to traverse child interfaces.
> 
> The all-namespace walk originated in the single global worker servicing
> per-namespace WEXT queues. The ordering fixes later reused that routine
> in netdevice notifiers to prevent delayed WEXT RTM_NEWLINK messages from
> following RTM_DELLINK or reporting stale interface flags. A notifier only
> needs to drain the affected device's namespace; there is no reason for it
> to walk and flush all namespaces.
> 
> Pass dev_net(dev) from both notifier callers and make the flush helper
> operate on that namespace. Keep the all-namespace walk and net_rwsem in
> the existing worker. This removes the instance-mutex -> net_rwsem
> dependency while retaining synchronous flushing from the notifiers.
> 
> It may seem strange that the fix for a lock cycle across multiple
> subsystems lies in a completely unrelated part of the code, but this
> seemed the most justified lock cycle edge to break.

If Johannes thinks this scoping is good for other reasons - SGTM.
But my knee jerk fix would be to skip all the wifi processing
for ops-locked devices since no wifi device is ops locked.
