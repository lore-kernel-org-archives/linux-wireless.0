Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:41523 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755802Ab2KMUui (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 15:50:38 -0500
Received: by mail-pa0-f46.google.com with SMTP id hz1so5291086pad.19
        for <linux-wireless@vger.kernel.org>; Tue, 13 Nov 2012 12:50:38 -0800 (PST)
Date: Tue, 13 Nov 2012 12:50:35 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Malcolm Priestley <tvboxspy@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 08/14] staging: vt6656: 64 bit fixes : correct all type
 sizes
Message-ID: <20121113205035.GB27716@kroah.com> (sfid-20121113_215041_704074_833E37B7)
References: <1352648485.6460.16.camel@canaries32-MCP7A>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1352648485.6460.16.camel@canaries32-MCP7A>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 11, 2012 at 03:41:25PM +0000, Malcolm Priestley wrote:
>  /****** Common pointer types ***********************************************/
>  
> -typedef unsigned long   ULONG_PTR;      // 32-bit
> -typedef unsigned long   DWORD_PTR;      // 32-bit
> +typedef u32 ULONG_PTR;
> +typedef u32 DWORD_PTR;

A pointer does not fit in u32 on all arches, only unsigned long works
here.

thanks,

greg k-h
