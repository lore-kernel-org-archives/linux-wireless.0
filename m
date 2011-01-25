Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46010 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036Ab1AYLSv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jan 2011 06:18:51 -0500
Date: Tue, 25 Jan 2011 19:18:13 +0800
From: Greg KH <gregkh@suse.de>
To: Roland Vossen <rvossen@broadcom.com>
Cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] staging: brcm80211: bugfix for softmac crash on multi
 cpu configurations
Message-ID: <20110125111813.GA14763@suse.de>
References: <1295952716-16161-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1295952716-16161-1-git-send-email-rvossen@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 25, 2011 at 11:51:56AM +0100, Roland Vossen wrote:
> Solved a locking issue that resulted in driver crashes with the 43224 and 43225
> chips. The problem has been reported on several fora. Root cause was two fold:
> hardware was being manipulated by two unsynchronized threads, and a scan
> operation could interfere with an ongoing dynamic calibration process. Fix was
> to invoke a lock on wl_ops_config() operation and to set internal flags when a
> scan operation is started and stopped.
> 
> Please add this to the staging-linus branch.

Should this also go to the .37 stable kernel tree?

thanks,

greg k-h
