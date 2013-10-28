Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:34435 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103Ab3J1Ooq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Oct 2013 10:44:46 -0400
Message-ID: <1382971479.17956.29.camel@jlt4.sipsolutions.net> (sfid-20131028_154449_993088_2016076D)
Subject: Re: [PATCH] cfg80211/nl80211: Add support to report unsafe
 frequency ranges(s)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Chauhan, Rajesh" <rajeshc@qca.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Rodriguez, Luis" <rodrigue@qca.qualcomm.com>,
	"Malinen, Jouni" <jouni@qca.qualcomm.com>,
	"Bahini, Henri" <hbahini@qca.qualcomm.com>,
	"Chang, Leo" <schang@qca.qualcomm.com>,
	"Luo, Xun" <xunl@qca.qualcomm.com>
Date: Mon, 28 Oct 2013 15:44:39 +0100
In-Reply-To: <D19FD2B13A40CD4B8DA64DB9B8F112E9218DAC92@nasanexd01a.na.qualcomm.com>
References: <1381985833-31312-1-git-send-email-rajeshc@qca.qualcomm.com>
	 <1382020835.14410.16.camel@jlt4.sipsolutions.net>
	 <D19FD2B13A40CD4B8DA64DB9B8F112E9218DAC92@nasanexd01a.na.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-10-17 at 17:19 +0000, Chauhan, Rajesh wrote:
> Hi Johannes,
> 
> Thanks for your comment. Purpose of this patch is to add an API for
> WLAN driver to report frequency ranges which should be avoided for
> SAP/P2P-GO because of interference.
> 
> How about if I reword commit test as below?
> 
> cfg80211/nl80211: Add API to report frequency range(s) to be avoided
> 
> Add support for WLAN driver to report frequency range(s) to be avoided
> because of interference.

Wouldn't it make more sense to raise a "detected interference" event?
There's no way to know what channel range is affected anyway. I fear
that this is vague enough for you to (ab)use it for all kinds of random
"channel steering" from the driver.

johannes

