Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE461319871;
	Tue, 19 May 2026 12:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779193417; cv=none; b=LFGs2o4JbDcXDL1KZrQlAomcbfKBv40kdYOsAEjupKhM2A/2youD4hiqvR+jM3YLoV+wsnYSXi7tjDFeIapZzRAgvkJDjXQRvzdnC1j1blKtNaNh8dhuUqhw33E9JiTPKibs6abx1+TrfUR6hESrqM1PpVdLndrXSgEgK52vENY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779193417; c=relaxed/simple;
	bh=qGZP8hXYGPQB/iOgWSSD3DsF3WO8hjlg2hcQI+4q6Jo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qrfhJ3yuLFxzcYMVwve8qDFnUANgj+NCMi5t3RDTo+HF7TAN65ccTPZ2RWs9wFtyEhBtDAavkfNR37zwoAXWpj1x6FnYIyWXAmCD8hVsRMY2m1Wd7RXW8HKWCAqOrM19osFz2gTZesd7NHstTn/AH+3N0xy+VOwSbR+aKg62tCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ct1Ne8MA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ct1Ne8MA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C3BC2BCB8;
	Tue, 19 May 2026 12:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1779193417;
	bh=qGZP8hXYGPQB/iOgWSSD3DsF3WO8hjlg2hcQI+4q6Jo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ct1Ne8MAEsBe7HdF9DS3R9J2gQcEvg/MS4xCUyHRGSmMckS58uaQq+4uqrzPyCVkG
	 f4UxT9i5/jjjCo8tQgDexwg+WM21vkKo7HpB/WwY0+hM2y3ut/T4+t5wr98aS5r/tn
	 yxzTY1E3h3lX5eROnxGj7b+QkvTa7RKLMSYw1v8s=
Date: Tue, 19 May 2026 14:22:50 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johnson Tsai <wenjie.tsai@realtek.com>, driver-core@lists.linux.dev
Subject: Re: [RFC rtw-next 1/2] wifi: rtw89: usb: add hw_info sysfs attribute
Message-ID: <2026051957-refract-barge-b21e@gregkh>
References: <20260519072415.25746-1-pkshih@realtek.com>
 <efb61959e14e4f57b78fbd49a563398e@realtek.com>
 <83ddb427597663b947c49afd835014f2bc1033f2.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83ddb427597663b947c49afd835014f2bc1033f2.camel@sipsolutions.net>

On Tue, May 19, 2026 at 02:11:32PM +0200, Johannes Berg wrote:
> Hi,
> 
> > > Example usage from user-space:
> > >   $ cat /sys/bus/usb/devices/2-3.1.2:1.0/hw_info
> > >   SN: 36 42 00 01 23
> > >   UUID: aa ec 2b 7c 0a 55 47 27 8d e0 b3 0f eb cc bb aa
> 
> Sysfs has a "one value per file" rule (soft rule according to the docs,
> but harder in practice, I believe), so seems if anything that should be
> two files. Maybe a UUID should also be formatted as such with %pU or
> similar.

That should be 2 separate sysfs files please.

And yes, use %pU.

And be careful about exposing serial numbers to userspace, some systems
don't like normal users to read them so be sure to get the permissions
correct.  We had to add some USB code for ALLOW_SERIAL_NUMBER to make it
so that systems can handle this if they want to.

And shouldn't this just be the USB serial number to start with?  Why is
there a different string here?  We already have a sysfs file for this
value.

thanks,

greg k-h
