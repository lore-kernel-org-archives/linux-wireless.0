Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39600 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276AbbG2VMd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jul 2015 17:12:33 -0400
Date: Wed, 29 Jul 2015 14:12:31 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chandra S Gorentla <csgorentla@gmail.com>
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: wilc1000: host_interface.c: Fix build warning
Message-ID: <20150729211231.GA938@kroah.com> (sfid-20150729_231300_723332_102120FC)
References: <1438178819-12740-1-git-send-email-csgorentla@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1438178819-12740-1-git-send-email-csgorentla@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 29, 2015 at 07:36:59PM +0530, Chandra S Gorentla wrote:
> Fixed - warning: ‘*((void *)&strHostIFmsg+4).pu8Head’ may be used uninitialized 

The warning is incorrect, look at the code, I don't see anything wrong
with it.  I suggest upgrading to a newer version of gcc that doesn't
report incorrect things like this, gcc 5.2 works fine for me here.

greg k-h
