Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39784 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab0KISvs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 13:51:48 -0500
Subject: Re: Wireless and RFKILL, this way integrators like myself
From: Johannes Berg <johannes@sipsolutions.net>
To: Clyde McPherson <ccmcphe@verizon.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4CD99096.5020105@verizon.net>
References: <4CD99096.5020105@verizon.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Nov 2010 10:53:07 -0800
Message-ID: <1289328787.3660.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-11-09 at 13:19 -0500, Clyde McPherson wrote:

> I build and use the compat-wireless source for use with SBC 
> applications, and I have a question about the wireless portion of the 
> code. Our SBCs do not have RFKILL capabilities, and since we use 
> wireless we are forced to include it in our kernel due to the depends in 
> wireless.

Not true. The depends is "depends on RFKILL || !RFKILL".

> What are the chances of adding #ifdef's for CONFIG_RFKILL on 
> the code segments that require RFKILL

Zero, because if you configure w/o RFKILL then the rfkill functions all
become stubs and there's nothing for you to worry about.

johannes

