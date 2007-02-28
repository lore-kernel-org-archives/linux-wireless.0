Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:11413 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932274AbXB1SsG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 13:48:06 -0500
Received: by nf-out-0910.google.com with SMTP id o25so642303nfa
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 10:48:04 -0800 (PST)
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH 8/28] rt2x00: optimize mac/bssid writing
Date: Wed, 28 Feb 2007 19:48:00 +0100
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702281507.11726.IvDoorn@gmail.com> <200702281930.12972.IvDoorn@gmail.com> <200702281946.14128.mb@bu3sch.de>
In-Reply-To: <200702281946.14128.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702281948.00464.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > > Do you writel this array in a loop inside of register_multiwrite?
> > > If yes, it's broken. writel expects values in CPU endianess.
> > > This array will always be little endian.
> > 
> > register_multiread uses memcpy_fromio(), and
> > register_multiwrite uses memcpy_toio().
> 
> Ah, ok.
> 
> > So that should be safe to use right?
> 
> Yes.
> 
> > Otherwise would making register_multiwrite  accept a void* pointer be better?
> 
> Yeah it would. The argument type is wrong. If the function uses
> memcpy_foo it expects an u8 array (or void array, whatever you prefer).

Ok, thanks. I'll fix this as soon as possible.

Ivo
