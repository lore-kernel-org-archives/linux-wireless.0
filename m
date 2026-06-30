Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F07266576;
	Tue, 30 Jun 2026 21:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782856290; cv=none; b=ZrAUTAXDtB1dYOeaHOJJgNHJhT3UByBd6YJ84BmtF9xlpbMa8ho8kCMwfxTlQfIzkHTN5kSCpfqqo4OXgcYxX/0WpZZgKMxTjryAmD3MHbgu8gZ4C0Veq6XHsY+tpzTwbgyMbf2ljo1OCdMDnpBmpQ9dJjQl7wU89U0gUQCgE6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782856290; c=relaxed/simple;
	bh=edpMslYdQ4suQQYZ0fpPVhs3/NvftDGtLCzkTzvy+84=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:To:From:Subject:
	 References:In-Reply-To; b=FPad9nBl62KobG22mSh8/pGqrI1/oh5gJ5AnONTNm1UM+SpF9+rgLChE051PDl49Z9j3mjrkWMoB6pYudqBZB5nj7hoLEKHk11+QP2lovQCZsXDWurq+1UszzhzzI3i9dVvoYMjF3CcTzryI9/gFt36op4RJ+Fb42RYKqtuO+jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m7A/Hc15; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m7A/Hc15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267DC1F000E9;
	Tue, 30 Jun 2026 21:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782856289;
	bh=edpMslYdQ4suQQYZ0fpPVhs3/NvftDGtLCzkTzvy+84=;
	h=Date:Cc:To:From:Subject:References:In-Reply-To;
	b=m7A/Hc15Pch7waVVQKngS9RUrdfRy+Y28mzmEEV0fYso7nyI2LEg8JJDyIh+7Bqbd
	 zn/QkdLOYItfq9DetZPC4qNCVUh4irtsoHOIW3Fo+Jd4xbvNtsTFAOb403AJIv5DOc
	 X09FAz/TsOu1+kATHxURNSMVYD95h75E4OprToGt5G4ahyq81ZMvQMFGgbR9COG2B7
	 J7KIuJcfktkd34iqE85FervA9z5WOiLQzOUL+EGn3rRp1NJgEbe966LOL0c0/H8DT7
	 ZLb8gtC6rNHEwo1bd3F7gd7PNAavY/aid1LYSfM1asAIxr/dH7Qa1guBpqVOUH5GRJ
	 uSLaJuk60ixhA==
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 30 Jun 2026 23:51:25 +0200
Message-Id: <DJMPT2QY8TTO.39DLGWZ2Z21U2@kernel.org>
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael J. Wysocki"
 <rafael@kernel.org>, =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?=
 <toke@toke.dk>, "Johan Hovold" <johan@kernel.org>,
 <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-usb@vger.kernel.org>, <driver-core@lists.linux.dev>
To: "Gary Guo" <gary@garyguo.net>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [PATCH 1/4] wifi: ath9k_htc: don't keep usb_device_id
References: <20260630-usb_dyn_id_uaf-v1-0-160a02be5ac2@garyguo.net>
 <20260630-usb_dyn_id_uaf-v1-1-160a02be5ac2@garyguo.net>
In-Reply-To: <20260630-usb_dyn_id_uaf-v1-1-160a02be5ac2@garyguo.net>

On Tue Jun 30, 2026 at 1:38 PM CEST, Gary Guo wrote:
> usb_device_id is not guaranteed to live longer than probe due to presence
> of dynamic ID. All information apart from driver_data can be easily
> retrieved from usb_device, so just store driver_data.
>
> Signed-off-by: Gary Guo <gary@garyguo.net>

Reviewed-by: Danilo Krummrich <dakr@kernel.org>
