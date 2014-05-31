Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40392 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382AbaEaOMB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 May 2014 10:12:01 -0400
Date: Sat, 31 May 2014 17:11:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: gregkh@linuxfoundation.org, kbuild@01.org,
	linux-wireless@vger.kernel.org
Subject: Re: [kbuild] [PATCH] staging: vt6656: Fix vnt_rf_table_download
 __builtin_memcpy() addr* too small (3 vs 64).
Message-ID: <20140531141115.GK17724@mwanda> (sfid-20140531_161307_028213_79D78610)
References: <1401541767-2940-1-git-send-email-tvboxspy@gmail.com>
 <20140531133839.GJ17724@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140531133839.GJ17724@mwanda>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 31, 2014 at 04:42:02PM +0300, Dan Carpenter wrote:
> On Sat, May 31, 2014 at 02:09:27PM +0100, Malcolm Priestley wrote:
> > Fix following errors
> > drivers/staging/vt6656/rf.c:1060 vnt_rf_table_download() error: __builtin_memcpy() 'addr2' too small (3 vs 64)
> > drivers/staging/vt6656/rf.c:1078 vnt_rf_table_download() error: __builtin_memcpy() 'addr3' too small (3 vs 64)
> > drivers/staging/vt6656/rf.c:1094 vnt_rf_table_download() error: __builtin_memcpy() 'addr1' too small (3 vs 48)
> > drivers/staging/vt6656/rf.c:1108 vnt_rf_table_download() error: __builtin_memcpy() 'addr2' too small (3 vs 64)
> > 
> 

Btw, the 3 here is a bug in Smatch...  I will fix that.  You shouldn't
have to work around that like this.  I'm sorry for the confusion.  My
only question when I reported the Smatch warning was about where we got
the 64.

regards,
dan carpenter

