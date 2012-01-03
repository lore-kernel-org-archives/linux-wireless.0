Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45070 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752650Ab2ACNmi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jan 2012 08:42:38 -0500
Date: Tue, 3 Jan 2012 13:43:31 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Alexander E. Patrakov" <patrakov@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: loading firmware while usermodehelper disabled.
Message-ID: <20120103134331.43e80a43@pyramind.ukuu.org.uk> (sfid-20120103_144247_236525_DB0B06F2)
In-Reply-To: <20120103151637.1388e204@home>
References: <Pine.LNX.4.44L0.1201021041550.10702-100000@netrider.rowland.org>
	<4F02165C.1060400@fastmail.fm>
	<CA+55aFwf06vRraVqtz8_2qWjxH0V=Yj5m7mEy3XVbA7+qj5k5A@mail.gmail.com>
	<20120102211904.GA15316@srcf.ucam.org>
	<CA+55aFwJuuvqcsgHnZ4-VhUhbVvL6beKogo1adgYyZt_ZM=H7A@mail.gmail.com>
	<20120102215028.GA15701@srcf.ucam.org>
	<20120103151637.1388e204@home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> What a heated discussion due to, essentially, a non-technical, legal
> issue! Remember that the whole "userspace firmware loader" saga
> together with the asynchronous firmware interface started when Debian
> started complaining over the non-freeness of the firmware being bundled
> as a part of the kernel module as an array of bytes. That design,

Actually thats only a part of it, and irrelevant anyway.

Compiling in the firmware is 1:1 mapping with doing request_firmware at
module load and freeing it on module unload. We can do that today, and in
fact some drivers with small firmware do. The other reason it exists is
because we have drivers that have megabytes of firmware data attached to
them, sometimes several versions for different chip versions. In those
cases neither compiling it in nor loading it on module load is a workable
solution because of the memory usage.

In some of the extreme cases like qcserial I don't think anyone has even
been able to count all the firmwares that exist !

> however, never had such dependency issues. So maybe revert to it, with
> the following changes, and solve the legal issue seen by Debian by
> hiring a lawyer?

It may have escaped your notice but a lot of Linux companies have
corporate lawyers and do talk to them about such issues and have been for
years.

Alan
