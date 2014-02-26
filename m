Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:2435 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751740AbaBZQst convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Feb 2014 11:48:49 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Paul Stewart <pstew@chromium.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 26 Feb 2014 08:48:48 -0800
Subject: RE: [PATCH] mwifiex: Track BA sequence number reset
Message-ID: <477F20668A386D41ADCC57781B1F70430F53C082DB@SC-VEXCH1.marvell.com> (sfid-20140226_174900_447862_846EE285)
References: <20140226003254.6ADE9200505@clearcreek.mtv.corp.google.com>
In-Reply-To: <20140226003254.6ADE9200505@clearcreek.mtv.corp.google.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Paul,

Thanks for the patch.

> Some stations reset the sequence number for traffic-ids (TIDs)
> as they initiate a block-ACK session.  In order to detect such
> behavior, mwifiex must note the starting sequence number given
> during the ADDBA request.  If the first received sequence number
> after the ADDBA falls outside the receive window for this TID but
> after the the ADDBA starting sequence number, we can assume that
> this AP has reset its sequence number during the ADDBA.  In this
> case we must adjust the input window backward to incorporate this
> received sequence number instead of ignoring it.  Otherwise, we
> could fail to successfully retrieve an arbitrarily large number
> of downstream frames at the beginning of the block-ACK session.
> 
> Signed-off-by: Paul Stewart <pstew@chromium.org>

Acked-by: Bing Zhao <bzhao@marvell.com>

Regards,
Bing

> ---
>  drivers/net/wireless/mwifiex/11n_rxreorder.c | 27
> +++++++++++++++++++++------
>  drivers/net/wireless/mwifiex/11n_rxreorder.h |  3 ++-
>  drivers/net/wireless/mwifiex/main.h          |  1 +
>  3 files changed, 24 insertions(+), 7 deletions(-)


