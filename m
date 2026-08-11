Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BF618859B;
	Tue, 11 Aug 2026 08:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786435762; cv=none; b=T7TDH1XvWYJFhPNaABxSWv/x2/L35Hwai7JJlgiYaDL05PjCfK5G75pjPnCSwkmD2c8xKBKWSkXlKJeMjSB8U8V3wUtuyTXKy8OiPZHAUu5z6d+YR9O+LuApAIfzhD9OXmRSthYMqJv5U0sJ10PQkSSU4WPWQGVCKdAGg8XA3vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786435762; c=relaxed/simple;
	bh=ePAdljDcdsfvuasHZ5n4jZREdIMdEcgFzfeljlFJ+jM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mTSE/7QH6g0g0BYAF8tXCmcN3WyC7TXjb/7BdImperX/84BpsNAh5PhfXMpGbLy4XgPfPrqy44/4XCkh6MkESSxsLY8c+1f/wZucYm1ZsE4qr6qIMkOS7ZCB0wAAeDFFKdVW89dM6XIO0OmQNq2muvIfb4a2ZqJ19jVX2cpoX2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0dGRHikZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0dGRHikZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E129D1F00A3A;
	Tue, 11 Aug 2026 08:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786435760;
	bh=qczULJpt96LeJaZ/zjB52AXaUhP9pAogYg198FsFXKk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=0dGRHikZLML0GQtfgc26zebh3/0WZdKxQ8Jnq0cY8kwSLOrw+3hS9f5yhF8oRmdya
	 /ze5msbXY1jClGhHQS13bx2Mb2gSMRjDUN35gFSiEsmFYd2lp0KM1Ps6IiwCneNvMd
	 hmsDw4C/+bvgclfdHVHPSnojkdSdufAjgGsoDyhw=
Date: Tue, 11 Aug 2026 17:07:47 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Hans de Goede <johannes.goede@oss.qualcomm.com>
Cc: Daniel Golle <daniel@makrotopia.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>, driver-core@lists.linux.dev,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
	Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	linux-wireless@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	linux-bluetooth@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] device_schedule_reprobe(): core helper and
 conversions
Message-ID: <2026081133-crazy-enquirer-97ce@gregkh>
References: <anpxFdwNxk0XwPjQ@makrotopia.org>
 <2026081139-strenuous-greasily-f4e5@gregkh>
 <cb0d42dd-4755-49a8-8a05-297e4283914e@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb0d42dd-4755-49a8-8a05-297e4283914e@oss.qualcomm.com>

On Tue, Aug 11, 2026 at 09:32:45AM +0200, Hans de Goede wrote:
> Hi Greg,
> 
> On 11-Aug-26 04:33, Greg Kroah-Hartman wrote:
> > On Tue, Aug 11, 2026 at 01:47:17AM +0100, Daniel Golle wrote:
> >> Three in-tree drivers (iwlwifi, hci_h5, btintel_pcie) schedule a
> >> deferred re-probe of their own device from a work item in module
> >> text.
> > 
> > That's a mess, why?  Why not fix that up to not do that?  Thousands of
> > other kernel drivers do not do that, what makes these so special?
> 
> I can only speak for the hci_h5 driver where I added the reprobe code-path.
> 
> The problem is some of the Bluetooth HCI devices using hci_h5 loose all
> state during system-suspend. This means that the HCI and the Bluetooth core
> end up being out of sync.
> 
> So we basically need to tear down and re-build everything including
> e.g. the firmware upload which happens at probe(). Doing a full reprobe
> is by far the easiest way to do this.
> 
> I suspect the other 4 users + the pending driver which triggered
> this are similar.

Full reprobe feels different than the THIS_MODULE stuff, which is what I
objected to here.

> Sure we can do the whole tear-down + setup from some worker
> scheduled at resume, while keep the driver attached but if we need
> to duplicate that over 4 drivers + the pending driver which triggers
> this then IMHO those 5 users are a pattern which deserves having
> some helper to do this through the existing probe() + remove(),
> rather then requiring those 5 drivers to open code this themselves.
> 
> Note that we already have device_reprobe(), which has 15 existing
> users. This series just adds a helper to do a device_reprobe() from
> a worker in a safe way.

That feels a bit better, as long as this code really is "safe" :)

So, how can this be tested and fixed up so it isn't a RFC anymore?

thanks,

greg k-h
