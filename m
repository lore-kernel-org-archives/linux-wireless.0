Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1E32AD2E
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 08:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784795596; cv=none; b=i++fShqbfs6NrpSIq9aUTpUkUUCCpcxbIXt8Hf0s86GNta9sRxQvlqePTsKIs9aVCHVOKw+DIX0TQdS1QDrljkb2tkc+NfG0Uc/sLZiq4mIpI1tyoB9oFBV/0hh9OVAX/tFptu88hMhJj87KV2amox5WIhNmAaS3lw0lza0a59k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784795596; c=relaxed/simple;
	bh=UGeOF6Qgse1F02GFrP8rFb3Y+xAc13XsQLnd7/VOuDA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g2uFMO9IiTwzktLkuKj8kdsLKlMoMjjmBtjO8nlxJtoQcR8JmN7qUhPw3FY9pvAndZDIDv322gvnxvGMi+G4ECjGMSYd6ajSVbC327z45N+T8i9OJYaheELmklXN927PrO1IucKlKCCIcYrIQdq+TKxIKyKXqQTuAyWgBh0nwCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=Ms/xoC2z; arc=none smtp.client-ip=212.77.101.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="Ms/xoC2z"
Received: (wp-smtpd smtp.wp.pl 22432 invoked from network); 23 Jul 2026 10:33:11 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1784795591; bh=Ri5m/BcfITOpl40vNOHEdVtvGXnlsWi7fcTjJcW7gBs=;
          h=From:To:Cc:Subject;
          b=Ms/xoC2zV48629GLfFxH9DnY9z66nJ2OKmkIYR9M0ip22HXiGrmhBO60XmKQttS2m
           L4/JTRReQivtljmhZ40SWqXNwSr7sH3rshVn3imwF+btBWRfja4TA73byu6rWzu494
           dQ/qFnChVfEdclfGWeY45KYb1yaOcWeDWod/MvJYuvwmwHs3JVMwxJmsL/JCCsW4qh
           zXb5IHoyvO7gpJFugmLdnLmmh1lo2QFVHiSaYHCno4Q+cI16YSVB2JebWbGJ1W0lGc
           ZiSaTdD3frHSQKKoHhqdTOTmNJzqZg2PTAdRh18Sg1/F1uXXt4cOOyUlac5a5ZmCwE
           qLKyv2NcmW0vw==
Received: from 77-236-11-167.static.play.pl (HELO localhost) (stf_xl@wp.pl@[77.236.11.167])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <rosenp@gmail.com>; 23 Jul 2026 10:33:11 +0200
Date: Thu, 23 Jul 2026 10:33:10 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH wireless-next] wifi: rt2x00: Use device-managed register
 buffers
Message-ID: <20260723083310.GC4577@wp.pl>
References: <20260717220052.824624-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717220052.824624-1-rosenp@gmail.com>
X-WP-MailID: 99da899a07fd48a92231d014ce85229b
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [cQNB]                               

On Fri, Jul 17, 2026 at 03:00:52PM -0700, Rosen Penev wrote:
> The rt2x00 PCI and USB probe paths allocate EEPROM and RF storage with
> plain kzalloc() and then free it from bus-specific teardown helpers.  The
> USB path also manages the CSR cache the same way.  These buffers are
> tied to the device lifetime, so the explicit free paths add probe and
> disconnect cleanup without providing separate ownership.
> 
> Allocate the buffers with devm_kzalloc() before the mac80211 hardware is
> allocated, then attach the resulting storage to struct rt2x00_dev after
> the driver-private state exists.  This lets driver detach and probe
> failure rely on device-managed cleanup and removes the duplicated
> bus-specific buffer freeing.
> 
> Assisted-by: Codex:GPT-5.5
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

>  int rt2x00usb_probe(struct usb_interface *usb_intf,
>  		    const struct rt2x00_ops *ops)
>  {
>  	struct usb_device *usb_dev = interface_to_usbdev(usb_intf);
> -	struct ieee80211_hw *hw;
>  	struct rt2x00_dev *rt2x00dev;
> +	struct ieee80211_hw *hw;
> +	__le16 *eeprom;
> +	void *cache;
>  	int retval;
> +	u32* rf;

Nit, u32 *rf;

Regards
Stanislaw
