Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56879 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932986AbbGGRWO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jul 2015 13:22:14 -0400
Message-ID: <559C0AC5.20801@infradead.org> (sfid-20150707_192228_657449_EA537E42)
Date: Tue, 07 Jul 2015 10:22:13 -0700
From: Randy Dunlap <rdunlap@infradead.org>
MIME-Version: 1.0
To: David Binderman <dcb314@hotmail.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	"dean.lee@atmel.com" <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: linux-4.2-rc1/drivers/staging/wilc1000/linux_wlan.c:1874: bad
 test ?
References: <DUB128-W333766FA47F8690AEA26469C920@phx.gbl>
In-Reply-To: <DUB128-W333766FA47F8690AEA26469C920@phx.gbl>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/07/15 04:19, David Binderman wrote:
> Hello there,
> 
> [linux-4.2-rc1/drivers/staging/wilc1000/linux_wlan.c:1874]: (style) A pointer can not be negative so it is either pointless or an error to check if it is.
> 
> Source code is
> 
>      if (wilc_mac_thread < 0) {
> 
> but
> 
> struct task_struct *wilc_mac_thread;


#include <linux/err.h>


	if (IS_ERR(wilc_mac_thread)) {


-- 
~Randy
