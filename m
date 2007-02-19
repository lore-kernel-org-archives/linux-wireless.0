Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:36064 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750911AbXBSKi2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 05:38:28 -0500
Received: by nf-out-0910.google.com with SMTP id o25so2385876nfa
        for <linux-wireless@vger.kernel.org>; Mon, 19 Feb 2007 02:38:27 -0800 (PST)
Message-ID: <a32f33a40702190238w6c3527ccne5592b0aae1db17c@mail.gmail.com>
Date: Mon, 19 Feb 2007 11:38:27 +0100
From: "Ivo Van Doorn" <ivdoorn@gmail.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: [PATCH] rt2x00: fix memory corruption caused by eeprom buffer overflow
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
In-Reply-To: <20070219024654.3480.9392.stgit@dl.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <20070219024654.3480.9392.stgit@dl.roinet.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> eeprom_93cx6_multiread() expects the last argument to be the buffer
> length in words, but kzalloc() expects the length in bytes.  This
> results in dangerous kernel memory corruption.
>
> Since there are already occurrences of "EEPROM_SIZE * sizeof(u16)" in
> the driver, I'm assuming that EEPROM_SIZE is in words, so the driver
> needs to allocate more memory.
>
> Signed-off-by: Pavel Roskin <proski@gnu.org>

ACK, this fix has been in CVS already, but I hadn't send the patch yet.

Ivo
