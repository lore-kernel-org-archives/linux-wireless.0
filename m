Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39842 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbbHMOt1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 10:49:27 -0400
Date: Thu, 13 Aug 2015 17:49:07 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Tony Cho <tony.cho@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	rachel.kim@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	jude.lee@atmel.com, leo.kim@atmel.com
Subject: Re: [PATCH 5/5] staging: wilc1000: use id value as argument
Message-ID: <20150813144907.GA4484@mwanda> (sfid-20150813_164936_356278_576E3D11)
References: <1439440883-16061-1-git-send-email-tony.cho@atmel.com>
 <1439440883-16061-6-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1439440883-16061-6-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 13, 2015 at 01:41:23PM +0900, Tony Cho wrote:
> +static u32 get_id_from_handler(tstrWILC_WFIDrv *handler)
> +{
> +	u32 id;
> +
> +	if (!handler)
> +		return 0;
> +
> +	for (id = 0; id < NUM_CONCURRENT_IFC; id++) {
> +		if (wfidrv_list[id] == handler) {
> +			id += 1;
> +			break;
> +		}
> +	}
> +
> +	if (id > NUM_CONCURRENT_IFC)
> +		return 0;
> +	else
> +		return id;
> +}
> +

This still has an off by one bug.  Just use zero offset arrays
throughout.

static int get_id_from_handler(tstrWILC_WFIDrv *handler)
{
	int id;

	if (!handler)
		return -ENOBUFS;

	for (id = 0; id < NUM_CONCURRENT_IFC; id++) {
		if (wfidrv_list[id] == handler)
			return id;
	}

	return -ENOBUFS;
}

> +static tstrWILC_WFIDrv *get_handler_from_id(u32 id)
> +{
> +	if (id > 0 && id <= NUM_CONCURRENT_IFC)
> +		return wfidrv_list[id - 1];
> +	else
> +		return NULL;
> +}

static tstrWILC_WFIDrv *get_handler_from_id(int id)
{
	if (id < 0 || id >= NUM_CONCURRENT_IFC)
		return NULL;
	return wfidrv_list[id];
}

regards,
dan carpenter

