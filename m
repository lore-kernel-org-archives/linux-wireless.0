Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25311531E8;
	Tue, 30 Jun 2026 21:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782856307; cv=none; b=WHiqhgHJJMgWCmtJ/qAlWUXHsLsdb8noKTXQxdoC2rg6izbYvUgsjBEDypSl91jlFQfQtil10DLYZlMPL7xF0Rw/0ja1NG0Yo/ewpW6mq7xUlc6S3lsEmsdZE92+ey/W1vpcldUBMZT8+ITQp+dNwpeecpeoXvu2TVkgjueD9cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782856307; c=relaxed/simple;
	bh=erKaMW3vTOeeBD8KlOdKPOCKA1xbAhQws5m+6iud2Bs=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=cIMw5ext8442+iAI5pJ2iIssa0P5vXP30io3cnw0PmBi6vf2kUFPEY/iy2RXQipYI7VFIUOvG0x7TKLyT5E0NgMZTepLE9seiuRo/FKijlyn1HYhHvpK7rUnoiYb3ZzXH7uVjsyVqKB4HLuEf7eah016a4wD0nHjCrAhNhufDS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MSrmPGc8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MSrmPGc8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77E111F000E9;
	Tue, 30 Jun 2026 21:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782856306;
	bh=erKaMW3vTOeeBD8KlOdKPOCKA1xbAhQws5m+6iud2Bs=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To;
	b=MSrmPGc8WNbNaLGgkWncTLN2qumtN2D/UMKgbQMiJbdgCU3veX4B9fyisLsTQagcx
	 vT0ZRALo5h4q/Gqw2Ct86MdWYycGYiSX7LGxIFv0CD3mwHrPiJns6m1zCV33D2+ZGE
	 fGuw1s5BFoYo0boq7zjkAfSwojMC99ThJigu9GFyK8v4hXq5tyIjzP/T97yH6uboj+
	 7klR37eYd5dhCaws1viE2qqZTD9jjlYHGKcqKU6fwiNMaz7E2wGkMh6hzybSWDv8T3
	 YzTlEK23HC2TEhwmS8JcrMhP/csope5cCVCNlYL6mZq2Ptptw04FnaCIu3cUn4ZYkW
	 547MX19VTIfsQ==
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 30 Jun 2026 23:51:43 +0200
Message-Id: <DJMPTAQEVOAR.2DFWCVVQ7KCOY@kernel.org>
Subject: Re: [PATCH 2/4] usb: usbtmc: don't keep usb_device_id
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael J. Wysocki"
 <rafael@kernel.org>, =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?=
 <toke@toke.dk>, "Johan Hovold" <johan@kernel.org>,
 <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-usb@vger.kernel.org>, <driver-core@lists.linux.dev>
To: "Gary Guo" <gary@garyguo.net>
From: "Danilo Krummrich" <dakr@kernel.org>
References: <20260630-usb_dyn_id_uaf-v1-0-160a02be5ac2@garyguo.net>
 <20260630-usb_dyn_id_uaf-v1-2-160a02be5ac2@garyguo.net>
In-Reply-To: <20260630-usb_dyn_id_uaf-v1-2-160a02be5ac2@garyguo.net>

On Tue Jun 30, 2026 at 1:38 PM CEST, Gary Guo wrote:
> usb_device_id is not guaranteed to live longer than probe due to presence
> of dynamic ID. This stored ID is unused so remove it.
>
> Signed-off-by: Gary Guo <gary@garyguo.net>

Reviewed-by: Danilo Krummrich <dakr@kernel.org>
