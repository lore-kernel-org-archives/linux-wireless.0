Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58048 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbYISNcJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2008 09:32:09 -0400
Received: from [38.100.210.50] (helo=localhost)
	by smtp.tuxdriver.com with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.63)
	(envelope-from <"linville@TUXDRIVER.COM"@tuxdriver.com>)
	id 1Kgg5e-0000B2-As
	for linux-wireless@vger.kernel.org; Fri, 19 Sep 2008 09:32:07 -0400
Message-ID: <a32f33a40809190006m299044e7uc12e5d6367cd7aa3@mail.gmail.com> (sfid-20080919_153213_763840_6FE50D14)
Date: Fri, 19 Sep 2008 09:06:39 +0200
From: "Ivo Van Doorn" <ivdoorn@gmail.com>
To: "John Daiker" <daikerjohn@gmail.com>
Subject: Re: [PATCH] rt2x00: Consolidate definition of CSR_OFFSET
Cc: "John Linville" <linville@tuxdriver.com>
In-Reply-To: <48D2EF65.4080900@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <48D2EF65.4080900@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 19, 2008 at 2:16 AM, John Daiker <daikerjohn@gmail.com> wrote:
> This consolidates the definition of CSR_OFFSET when CONFIG_RT2X00_LIB_DEBUG
> is also set.
> The original definition appeared in 5 files, but was moved to a common .h
> file instead.
>
> Compile-tested only, as I don't have any rt2x00 HW in a working machine.
>
> Signed-off-by: John Daiker <daikerjohn@gmail.com>

NACK
This patch does more then consolidating  the CRS_OFFSET definition since it
changes several lines for adding/removing whitespaces as well.
It completely breaks rt2500usb, and I really dislike using define
names in rt2x00.h
while the define itself is declared in the register headers only (and
is thus not really
visible in rt2x00.h, even though the compiler would accept it and it
would work as
expected).

Ivo

> ---
>
>
>

