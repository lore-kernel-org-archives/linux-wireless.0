Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:41219 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbXLSGfa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Dec 2007 01:35:30 -0500
Date: Wed, 19 Dec 2007 06:35:26 +0000
From: Al Viro <viro@ftp.linux.org.uk>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	yi.zhu@intel.com, viro@zeniv.linux.org.uk
Subject: Re: [PATCH] ipw2200: prevent alloc of unspecified size on stack
Message-ID: <20071219063526.GH8181@ftp.linux.org.uk> (sfid-20071219_063533_823036_CF2C4996)
References: <1198044062-25201-1-git-send-email-reinette.chatre@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1198044062-25201-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 18, 2007 at 10:01:02PM -0800, Reinette Chatre wrote:
> +	/* not using min() because of its strict type checking */
> +	log_size = sizeof(*log) * log_len < PAGE_SIZE ?

		   PAGE_SIZE / sizeof(*log) > len ?

to be provably safe against wraparounds, if you really want to limit that
to PAGE_SIZE...
