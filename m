Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:43715 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757349AbYHMOSU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Aug 2008 10:18:20 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: Pondering: how to improve mac80211 roaming ...
Date: Wed, 13 Aug 2008 16:18:13 +0200
Cc: Helmut Schaa <hschaa@suse.de>, Jouni Malinen <j@w1.fi>
References: <200808120838.52888.hs4233@mail.mn-solutions.de> <20080812154223.GE4981@jm.kir.nu> <200808131426.55673.hschaa@suse.de>
In-Reply-To: <200808131426.55673.hschaa@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808131618.13141.hs4233@mail.mn-solutions.de> (sfid-20080813_161923_483551_9C58118B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> It might even be beneficial to cancel a currently active
> background scan once the TX queue is filling up and report the
> already gathered information to the user space.

This brings policy into the kernel. Why should TX data be more 
important than a scan result?

If an app only gets partial scan results because of "too much tx 
data", what can the app do against it?  Nothing. It can just 
retrigger a scan again. But what if then there is still "too 
much tx data"?  Then the times of n * "partial scan" might be 
bigger than a "real scan" and a happy application.
