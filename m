Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate03.web.de ([217.72.192.234]:50481 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760147AbYJIQtB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Oct 2008 12:49:01 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC][PATCH 1/5] p54: broken out vdcf code
Date: Thu, 9 Oct 2008 18:53:01 +0200
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
References: <200810050238.28100.chunkeey@web.de> <48EE2139.102@lwfinger.net>
In-Reply-To: <48EE2139.102@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200810091853.02076.chunkeey@web.de> (sfid-20081009_184923_549113_E2CC3F8E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 09 October 2008 17:20:25 Larry Finger wrote:
> Christian Lamparter wrote:
> > Broken out the vdcf's code into another patch, as it caused problems in the last RFC.
> 
> This patch has the following insertion as a replacement:
> 
> +struct p54_tx_vdcf_queues {
> +	u8 aifs;
> +	u8 padding;
> +	__le16 cwmin;
> +	__le16 cwmax;
> +	__le16 txop;
> +} __attribute__ ((packed));

Well, I took this idea from stlc45xx. But now, after some digging in the specs about WMM...
I came to the conclusion that this is superfluous. I'll revert back to the original __le16 aifs,
in the next RFC/RFT round... But now, we should better fix the code for big-endian machines.

I tried to use qemu to emulate a PPC machine, but it's painfully slow and the QEMU's USB 
loop through code doesn't work as advertised (yet?).

Regards,
	Chr
