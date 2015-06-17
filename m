Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52316 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546AbbFQODO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2015 10:03:14 -0400
Date: Wed, 17 Jun 2015 07:03:13 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: wilc1000: remove WILC_WFIDrvHandle
Message-ID: <20150617140313.GA17337@kroah.com> (sfid-20150617_160318_786459_DF0A0109)
References: <1434546980-19094-1-git-send-email-sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1434546980-19094-1-git-send-email-sudipm.mukherjee@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 17, 2015 at 06:46:20PM +0530, Sudip Mukherjee wrote:
> WILC_WFIDrvHandle was:
> 
> typedef struct {
>        s32 s32Dummy;
> } *WILC_WFIDrvHandle;
> 
> which basically meant a pointer to an integer.
> so removed the typedef and replaced all WILC_WFIDrvHandle with int *
> 
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> ---
> 
> replacement was done by using sed, just manually removed the typedef.
> build ok, before this change total 77 build warning, after this patch
> same number of warnings.

Which means this is not the correct fix for this :)

The driver is obviously broken for 64bit systems, and these warnings are
showing that, let's fix this "correctly" please.

sorry, I'm not going to take this patch.

greg k-h
