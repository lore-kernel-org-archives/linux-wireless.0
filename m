Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47469 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759262Ab0JYSBS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Oct 2010 14:01:18 -0400
Message-ID: <4CC5C5F5.3080607@lwfinger.net>
Date: Mon, 25 Oct 2010 13:01:25 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: htl10@users.sourceforge.net
CC: "John W. Linville" <linville@tuxdriver.com>,
	Serafeim Zanikolas <sez@debian.org>, herton@mandriva.com.br,
	joe@perches.com, davem@davemloft.net,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: rtl818x: request DMA-able memory
References: <902045.66378.qm@web29504.mail.ird.yahoo.com>
In-Reply-To: <902045.66378.qm@web29504.mail.ird.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/25/2010 10:39 AM, Hin-Tak Leung wrote:
> 
> okay - sorry about the confusion - I was grep'ing for GFP_DMA and only b43/b43lagacy have it and it is relatively rare. AFAIK none of the rtl8187 devices are non-USB... probably a NACK then, but I should ask Serafeim if there is a reason for him to submit this patch? (other than "it says dma"...) 

There are some devices driven by b43/b43legacy that implement only 24-bit DMA.
For that reason, they need to allocate DMA buffers in the low 16 MB of RAM. For
rtl8187, that consideration does not apply.

Larry
