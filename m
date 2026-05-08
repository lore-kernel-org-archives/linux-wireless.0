Received: from mail.lysator.liu.se (mail.lysator.liu.se [130.236.254.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8223EC2CD
	for <linux-wireless@vger.kernel.org>; Fri,  8 May 2026 13:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=130.236.254.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778248520; cv=none; b=uK5S1uu1kbXa4OI2MdDloGlJm5YkSMqXCswROof1E5LodFmbwqzQ6ap4/2mN+pp5QH2O/a9K5kMFulBIQJDA/MdihxhrR56HqKSAu68jNeemkU2GykAzBsjYJDDBWfyJ0BE2QjbZalx0xBAMMbFj2ZwXo0K6TJO6ioL+hTAxXGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778248520; c=relaxed/simple;
	bh=/Y4ZcFAe/iEELrNS7QRb0o3eWro+PU6LNBa2mtRWlLY=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=lQskniyABWLrnwNSnALVm94Vn3buNSe1jOmrgYnJ9OqWBAO8+VsFzmcLKUuworTtL8xIjWtSS+3+/mUNzj8WyjVxTupuv9bXLCsNgo+CDq7SesnLdOhBQRa4sSsQR8HZqeBfXJ930t4KMp83fTvkTffynG3N+yJ7PCc8jiWjtNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lysator.liu.se; spf=pass smtp.mailfrom=lysator.liu.se; arc=none smtp.client-ip=130.236.254.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lysator.liu.se
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lysator.liu.se
Received: from mail.lysator.liu.se (localhost [127.0.0.1])
	by mail.lysator.liu.se (Postfix) with ESMTP id E7BAD670C
	for <linux-wireless@vger.kernel.org>; Fri,  8 May 2026 15:55:09 +0200 (CEST)
Received: by mail.lysator.liu.se (Postfix, from userid 1004)
	id B854E670A; Fri,  8 May 2026 15:55:09 +0200 (CEST)
X-Spam-Level: 
X-Spam-Score: -1.0
Received: from sara (unknown [IPv6:2001:9b1:efc:9600:673b:b32b:2a17:9d71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by mail.lysator.liu.se (Postfix) with ESMTPSA id 00ECA65F9;
	Fri,  8 May 2026 15:55:07 +0200 (CEST)
Date: Fri, 8 May 2026 15:55:07 +0200 (CEST)
From: =?UTF-8?Q?Peter_=C3=85strand?= <astrand@lysator.liu.se>
To: Andreas Kemnade <andreas@kemnade.info>
cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wifi: wlcore: Add support for IGTK key
In-Reply-To: <20260508102403.4e2fb1bc@kemnade.info>
Message-ID: <a2040dcc-af47-1de0-b731-defffe3ce4cd@lysator.liu.se>
References: <0d3df7ab-6c41-c3cc-83cc-5ba55fe4e4bd@lysator.liu.se> <20260508102403.4e2fb1bc@kemnade.info>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323329-471329042-1778247882=:903464"
Content-ID: <5092aff2-96bd-bf45-04dc-25bc0d04bb0b@lysator.liu.se>
X-Virus-Scanned: ClamAV using ClamSMTP

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-471329042-1778247882=:903464
Content-Type: text/plain; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <409fd941-97eb-4315-d94e-5af72c3c9f7c@lysator.liu.se>

On Fri, 8 May 2026, Andreas Kemnade wrote:

> Hi,
> 
> On Fri, 16 Jan 2026 18:58:58 +0100 (CET)
> Peter Åstrand <astrand@lysator.liu.se> wrote:
> 
> > This change re-applies commit 2b7aadd3b9e1 ("wlcore: Adding suppoprt for IGTK key in
> > wlcore driver") (sic), but only enables WLAN_CIPHER_SUITE_AES_CMAC with modern
> > firmware. This patch is required to support WPA3 connections.
> > 
> 
> I have seen this after this patch:
> [  484.113311] wlcore: WARNING could not set keys
> [  484.117828] wlcore: ERROR Could not add or replace key
> [  484.123016] wlan0: failed to set key (5, ff:ff:ff:ff:ff:ff) to hardware (-5)
> [  484.123046] wlcore: Hardware recovery in progress. FW ver: Rev 7.3.10.0.142
> [  484.139923] wlcore: pc: 0x0, hint_sts: 0x00000048 count: 1
> [  484.145721] wlcore: down
> [  484.148986] ieee80211 phy0: Hardware restart was requested
> [  484.610473] wlcore: firmware booted (Rev 7.3.10.0.142)
> [  484.633758] wlcore: Association completed.
> [  484.690490] wlcore: ERROR command execute failure 14
> [  484.690490] ------------[ cut here ]------------
> [  484.700195] WARNING: drivers/net/wireless/ti/wlcore/main.c:872 at wl12xx_queue_recovery_work+0x64/0x74 [wlcore], CPU#0: kworker/0:0/892
> 
> This repeats endlessly.
> As soon as I set pmf to 1 in wpa_supplciant, once per second. Reverting this patch helps. Seen this
> on the Epson Moverio BT-200.

Thanks for this feedback. From the firmware version, I assume that this is 
not wl18xx but probably wl12xx? Unfortunately I have no experience with 
that module. So, while my patch is an improvement over the original patch 
because it checks firmware version, it did not consider non-wl18xx 
modules. 

I guess we need to throw in something like:

strcmp(pdev_data->family->name, "wl18xx")

...in the if statement. 

Br,
Peter
--8323329-471329042-1778247882=:903464--
