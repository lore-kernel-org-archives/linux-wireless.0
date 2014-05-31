Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35614 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382AbaEaNmS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 09:42:18 -0400
Date: Sat, 31 May 2014 16:42:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	kbuild@01.org
Subject: Re: [PATCH] staging: vt6656: Fix vnt_rf_table_download
 __builtin_memcpy() addr* too small (3 vs 64).
Message-ID: <20140531133839.GJ17724@mwanda> (sfid-20140531_154302_364945_F476D647)
References: <1401541767-2940-1-git-send-email-tvboxspy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1401541767-2940-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 31, 2014 at 02:09:27PM +0100, Malcolm Priestley wrote:
> Fix following errors
> drivers/staging/vt6656/rf.c:1060 vnt_rf_table_download() error: __builtin_memcpy() 'addr2' too small (3 vs 64)
> drivers/staging/vt6656/rf.c:1078 vnt_rf_table_download() error: __builtin_memcpy() 'addr3' too small (3 vs 64)
> drivers/staging/vt6656/rf.c:1094 vnt_rf_table_download() error: __builtin_memcpy() 'addr1' too small (3 vs 48)
> drivers/staging/vt6656/rf.c:1108 vnt_rf_table_download() error: __builtin_memcpy() 'addr2' too small (3 vs 64)
> 

I guess I was confused where the 64 comes from in the:

		if (length2 >= 64)
			length = 64;

We only ever seem to use the first 64 bytes of "u8 array[256];" so my
guess is that it was intended to be sizeof(array)?

regards,
dan carpenter

