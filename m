Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41795 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbbGNVMz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2015 17:12:55 -0400
Date: Tue, 14 Jul 2015 14:12:54 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Johnny Kim <johnny.kim@atmel.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	chris.park@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	austin.shin@atmel.com, Nicolas.FERRE@atmel.com, tony.cho@atmel.com
Subject: Re: [PATCH 2/3] staging: wilc1000: wilc_wlan_cfg_get(): replace
 integer with void pointer
Message-ID: <20150714211254.GA11675@kroah.com> (sfid-20150714_231259_084708_2B5C0B4E)
References: <1436507759-4546-1-git-send-email-johnny.kim@atmel.com>
 <1436507759-4546-3-git-send-email-johnny.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1436507759-4546-3-git-send-email-johnny.kim@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 10, 2015 at 02:55:56PM +0900, Johnny Kim wrote:
> Last argument of wilc_wlan_cfg_get function is actually structure's address.
> This should be changed to be compatible with 64bit machine.
> Because wilc_wlan_cfg_get function is mapped by function pointer later,
> wilc_wlan_oup_t.wlan_cfg_get should be changed together.
> 
> tstrWILC_WFIDrv structure is defined after wilc_wlan_oup_t.wlan_cfg_get
> is defined. So, this patch changes the argument to void type pointer.

No, you should never use a void pointer, that indicates the code is
designed wrong.

Please reorder the structures in a .h file if needed, there is nothing
preventing you from doing the right thing here.

Please fix up this whole series and resend, I can't take it as-is,
sorry.

greg k-h
