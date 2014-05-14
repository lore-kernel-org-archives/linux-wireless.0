Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:46053 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753250AbaENCxG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 May 2014 22:53:06 -0400
From: Bing Zhao <bzhao@marvell.com>
To: James Cameron <quozl@laptop.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Avinash Patil <patila@marvell.com>
Date: Tue, 13 May 2014 19:52:47 -0700
Subject: RE: mwifiex: no wr_port available
Message-ID: <477F20668A386D41ADCC57781B1F70430F70D87C4D@SC-VEXCH1.marvell.com> (sfid-20140514_045311_600006_DCE5386F)
References: <20140507120634.GM17490@us.netrek.org>
In-Reply-To: <20140507120634.GM17490@us.netrek.org>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi James,

> G'day,
> 
> Is there a short duration leak of wr_port in
> mwifiex_sdio_host_to_card()?

You are right. There is a leak in the error case. Thanks for pointing it out.

> 
> If mwifiex_host_to_card_mp_aggr fails because of is_suspended in
> mwifiex_write_data_sync, is the wr_port ever released?
> 
> Or maybe mp_wr_bitmap is re-read from the card when a download
> interrupt occurs, or if an upload interrupt occurs after a command is
> sent.

A patch has been sent to address this issue.

Thanks,
Bing

