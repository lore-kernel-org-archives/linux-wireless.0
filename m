Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52665 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964916AbaFSWza (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2014 18:55:30 -0400
Date: Thu, 19 Jun 2014 15:59:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, kbuild@01.org,
	linux-wireless@vger.kernel.org
Subject: Re: [kbuild] [PATCH] staging: vt6656: Fix vnt_rf_table_download
 __builtin_memcpy() addr* too small (3 vs 64).
Message-ID: <20140619225930.GA15032@kroah.com> (sfid-20140620_005553_853355_18DAB220)
References: <1401541767-2940-1-git-send-email-tvboxspy@gmail.com>
 <20140531133839.GJ17724@mwanda>
 <20140531141115.GK17724@mwanda>
 <5389EDD4.9050808@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5389EDD4.9050808@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 31, 2014 at 03:57:24PM +0100, Malcolm Priestley wrote:
> On 31/05/14 15:11, Dan Carpenter wrote:
> >On Sat, May 31, 2014 at 04:42:02PM +0300, Dan Carpenter wrote:
> >>On Sat, May 31, 2014 at 02:09:27PM +0100, Malcolm Priestley wrote:
> >>>Fix following errors
> >>>drivers/staging/vt6656/rf.c:1060 vnt_rf_table_download() error: __builtin_memcpy() 'addr2' too small (3 vs 64)
> >>>drivers/staging/vt6656/rf.c:1078 vnt_rf_table_download() error: __builtin_memcpy() 'addr3' too small (3 vs 64)
> >>>drivers/staging/vt6656/rf.c:1094 vnt_rf_table_download() error: __builtin_memcpy() 'addr1' too small (3 vs 48)
> >>>drivers/staging/vt6656/rf.c:1108 vnt_rf_table_download() error: __builtin_memcpy() 'addr2' too small (3 vs 64)
> >>>
> >>
> >
> >Btw, the 3 here is a bug in Smatch...  I will fix that.  You shouldn't
> >have to work around that like this.  I'm sorry for the confusion.  My
> >only question when I reported the Smatch warning was about where we got
> >the 64.
> >
> 64 is the maximum that can be sent out at any one time so it must be from
> length.
> 
> array could be reduced to 64.
> 
> 3 is the element size of the tables, so the pointer should really point to
> the whole table.

I'm dropping this because it shouldn't be needed, right?  If not, please
resend.

thanks,

greg k-h
