Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:50222 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbXLSG6C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 01:58:02 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH] ipw2200: prevent alloc of unspecified size on stack
Date: Tue, 18 Dec 2007 22:52:11 -0800
Message-ID: <D936D925018D154694D8A362EEB08920033B497E@orsmsx416.amr.corp.intel.com> (sfid-20071219_065809_229090_4C64FCA0)
In-Reply-To: <20071219063526.GH8181@ftp.linux.org.uk>
References: <1198044062-25201-1-git-send-email-reinette.chatre@intel.com> <20071219063526.GH8181@ftp.linux.org.uk>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: "Al Viro" <viro@ftp.linux.org.uk>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>, <viro@zeniv.linux.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, December 18, 2007 10:35 PM, Al Viro  wrote:

> On Tue, Dec 18, 2007 at 10:01:02PM -0800, Reinette Chatre wrote:
>> +	/* not using min() because of its strict type checking */
>> +	log_size = sizeof(*log) * log_len < PAGE_SIZE ?
> 
> 		   PAGE_SIZE / sizeof(*log) > len ?
> 
> to be provably safe against wraparounds, if you really want to limit
> that to PAGE_SIZE...

To cover this I reset log_len after allocating the memory:

+	}
+	log_len = log_size / sizeof(*log);
 	ipw_capture_event_log(priv, log_len, log);


If we use the original length then we are ok and log_len is just what it
was before. If we use PAGE_SIZE then log_len is reset to fit in the
amount of memory we allocated (PAGE_SIZE).

Is this what you meant?

Reinette
