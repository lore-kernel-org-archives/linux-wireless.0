Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33415 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442Ab2BNK7d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Feb 2012 05:59:33 -0500
Subject: Re: DELBA processed in workqueue too slow?
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <CAGXE3d-ydmV8qrtihSHCNBtkTxT8M=JCACBZFuP+Ne3cQ1WVow@mail.gmail.com> (sfid-20120206_164853_205520_EC6E0AD1)
References: <CAGXE3d-ydmV8qrtihSHCNBtkTxT8M=JCACBZFuP+Ne3cQ1WVow@mail.gmail.com>
	 (sfid-20120206_164853_205520_EC6E0AD1)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Feb 2012 11:59:31 +0100
Message-ID: <1329217171.3941.10.camel@jlt3.sipsolutions.net> (sfid-20120214_115935_947004_BFA9F0E3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-02-06 at 16:48 +0100, Helmut Schaa wrote:
> Hi,
> 
> since all action frames are handled in the iface workqueue the following
> situation can cause problems on slow devices in AP mode:
> 
> - data stream AP -> STA with established TX BA session
> - peer sends a DELBA to tear the APs TX BA session down
> - new frames are still send as AMPDU but the receiver doesn't BlockAck
>   them anymore since it assumes the BA session is already teared down.
> - DELBA gets processed

> Hence, most frames between receiving the DELBA and actually processing
> it are basically lost. This can easily make TCP streams getting stuck for a
> few seconds :(

Why are they lost? They haven't been acknowledged so wouldn't they be
retransmitted?

In any case, it seems the easiest solution may be to stop queues? But to
really make this fool-proof you'd also have to tell the driver to
release all its internal buffers -- and you're never going to solve the
race completely.

johannes

