Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31083 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbbKZMgm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2015 07:36:42 -0500
Date: Thu, 26 Nov 2015 15:36:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: walter harms <wharms@bfs.de>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] rt2x00: type bug in _rt2500usb_register_read()
Message-ID: <20151126123618.GE7289@mwanda> (sfid-20151126_133646_960127_69E0DE55)
References: <20151126115523.GD10556@mwanda>
 <5656F95C.60107@bfs.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5656F95C.60107@bfs.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 26, 2015 at 01:21:48PM +0100, walter harms wrote:
> > If the low 16 bits were initialized to zero then this code would only be
> > a problem on big endian systems.

> perhaps, cleaning *value would be sufficient ? Avoiding the need for a tmp var.
> 
> *value = 0
> rt2500usb_register_read(rt2x00dev, offset, (u16 *)value);
> 

Because if you initialize value then you still have a bug on big endian
systems.

regards,
dan carpenter

