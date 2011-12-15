Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:49307 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180Ab1LOIk6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 03:40:58 -0500
From: "Elias, Ilan" <ilane@ti.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
CC: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH 3/8] NFC: Do not take the genl mutex from the netlink
 release notifier
Date: Thu, 15 Dec 2011 08:40:44 +0000
Message-ID: <B30D1FD582D6484ABF57420512E5803504FD8F3B@DNCE03.ent.ti.com> (sfid-20111215_094112_243657_FF28FDBB)
References: <1323877392-20567-1-git-send-email-sameo@linux.intel.com>
 <1323877392-20567-4-git-send-email-sameo@linux.intel.com>
In-Reply-To: <1323877392-20567-4-git-send-email-sameo@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi  Samuel,

> @@ -504,12 +504,10 @@ static int nfc_genl_rcv_nl_event(struct 
> notifier_block *this,
>  	dev = nfc_device_iter_next(&iter);
>  
>  	while (dev) {
> -		mutex_lock(&dev->genl_data.genl_data_mutex);
>  		if (dev->genl_data.poll_req_pid == n->pid) {
>  			nfc_stop_poll(dev);
>  			dev->genl_data.poll_req_pid = 0;
>  		}
> -		mutex_unlock(&dev->genl_data.genl_data_mutex);
>  		dev = nfc_device_iter_next(&iter);
>  	}

Please note that the function nfc_stop_poll might also sleep, since mutex_lock is also called inside:
nfc_genl_rcv_nl_event -> nfc_stop_poll -> device_lock -> mutex_lock.

BR,
Ilan