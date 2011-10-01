Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56403 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab1JAQWG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Oct 2011 12:22:06 -0400
Received: by eya28 with SMTP id 28so1841624eya.19
        for <linux-wireless@vger.kernel.org>; Sat, 01 Oct 2011 09:22:04 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: r8712u driver - on ARM
Date: Sat, 1 Oct 2011 18:22:00 +0200
Cc: Ian Jeffray <ian@emobix.co.uk>, linux-wireless@vger.kernel.org
References: <4E81ED65.7060703@emobix.co.uk> <201109302106.12028.chunkeey@googlemail.com> <4E873944.70104@lwfinger.net>
In-Reply-To: <4E873944.70104@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201110011822.00637.chunkeey@googlemail.com> (sfid-20111001_182219_646173_9E03C71E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 01 October 2011 18:01:08 Larry Finger wrote:
> Ian,
> 
> Most of the skb assignments in r8712u are aligned OK and most aligned on 
> 512-byte boundaries, but there was one that had the minimal offset of 14 bytes. 
> The attached patch should fix it. Does it help?
Interesting, this "patch" goes in a completely different direction.
Can you tell me where the driver aligns the frames which will be
xmitted by the device [i.e.: which is passed to the usb subsystem
by usb_submit_urb]? Because that's what actually matters.

Regards,
	Chr
