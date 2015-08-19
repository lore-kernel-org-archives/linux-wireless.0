Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38707 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbbHSKE7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 06:04:59 -0400
Date: Wed, 19 Aug 2015 13:05:09 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johnny Kim <johnny.kim@atmel.com>
Cc: devel@driverdev.osuosl.org, rachel.kim@atmel.com,
	chris.park@atmel.com, gregkh@linuxfoundation.org,
	linux-wireless@vger.kernel.org, jude.lee@atmel.com,
	Tony Cho <tony.cho@atmel.com>, leo.kim@atmel.com
Subject: Re: [PATCH 5/5] staging: wilc1000: use id value as argument
Message-ID: <20150819100509.GK5610@mwanda> (sfid-20150819_120502_750755_73906D8C)
References: <1439440883-16061-1-git-send-email-tony.cho@atmel.com>
 <1439440883-16061-6-git-send-email-tony.cho@atmel.com>
 <20150813144907.GA4484@mwanda>
 <55D2A23D.2080209@atmel.com>
 <20150818091224.GM5558@mwanda>
 <55D43738.7000008@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55D43738.7000008@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> Real ID value means the value mapped to an alive NIC handler.

Who is mapping it?  It's all within the driver so it is not "real"
unless there external requirements.

> And when the driver transmits and receives some data frame with chipset,
> the ID is used to distinguish the data frame's owner. Just like the driver,
> chipset uses the appointed identifier. the data frame always includes the
> identifier.

Yes.  But it uses whatever we give it, otherwise it will break when we
change this.

> You know, current driver is using 32bit pointer address as the identifier.
> So, this patch converts the address value to integer value. As mentioned
> earlier, '0' value is the reserved value to terminate an alive NIC handler
> and inform it to chipset.

Ah... I see now.  In the original code we used pointers and NULL meant
disconnect.  Now we are using integers but we still want zero to be
disconnect.  Fine, just make the array one pointer larger, it's not
worth the extra headache (the first version had off by one bugs, and the
second version still had an off by one bug even after I pointed them out
in the first version), just to save 8 bytes:

/* Zero is not used, because a zero ID means disconnect */
static tstrWILC_WFIDrv *wfidrv_list[NUM_CONCURRENT_IFC + 1];

static int add_handler_in_list(tstrWILC_WFIDrv *handler)
{
	int i;

	for (i = 1; i < ARRAY_SIZE(wfidrv_list); i++) {
		if (!wfidrv_list[i]) {
			wfidrv_list[i] = handler;
			return 0;
		}
	}

	return -ENOBUFS;
}

static int remove_handler_in_list(tstrWILC_WFIDrv *handler)
{
	int i;

	for (i = 1; i < ARRAY_SIZE(wfidrv_list); i++) {
		if (wfidrv_list[i] == handler) {
			wfidrv_list[i] = NULL;
			return 0;
		}
	}

	return -EINVAL;
}

static int get_id_from_handler(tstrWILC_WFIDrv *handler)
{
	int i;

	if (!handler)
		return 0;

	for (i = 1; i < ARRAY_SIZE(wfidrv_list); i++) {
		if (wfidrv_list[i] == handler)
			return i;
	}

	return 0;
}

static tstrWILC_WFIDrv *get_handler_from_id(int id)
{
	if (id <= 0 || id >= ARRAY_SIZE(wfidrv_list))
		return NULL;

	return wfidrv_list[id];
}

