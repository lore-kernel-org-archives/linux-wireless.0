Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:32826 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932436Ab1CDSpn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 13:45:43 -0500
Date: Fri, 4 Mar 2011 13:40:50 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Shan Wei <shanwei@cn.fujitsu.com>
Cc: Larry.Finger@lwfinger.net, davem@davemloft.net,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2011-02-22
Message-ID: <20110304184050.GC9866@tuxdriver.com>
References: <20110222215229.GJ12153@tuxdriver.com>
 <4D706C2E.40307@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4D706C2E.40307@cn.fujitsu.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 04, 2011 at 12:35:58PM +0800, Shan Wei wrote:
> John W. Linville wrote, at 02/23/2011 05:52 AM:
> > Please let me know if there are problems!
> 
> Fail to compile with attached config under net-next tree.
>  
> ======Error Begin================================================================
> drivers/net/wireless/rtlwifi/rtl8192cu/built-in.o: In function `rtl92c_phy_sw_chnl':
> /data2/net-next-2.6/drivers/net/wireless/rtlwifi/rtl8192cu/../rtl8192c/phy_common.c:803: multiple definition of `rtl92c_phy_sw_chnl'
> drivers/net/wireless/rtlwifi/rtl8192ce/built-in.o:/data2/net-next-2.6/drivers/net/wireless/rtlwifi/rtl8192ce/../rtl8192c/phy_common.c:803: first defined here
> drivers/net/wireless/rtlwifi/rtl8192cu/built-in.o: In function `rtl92c_fill_h2c_cmd':

This is already fixed in wireless-next-2.6:

commit 1472d3a87586eb7529d1d85f7c888055650b7208
Author: Larry Finger <Larry.Finger@lwfinger.net>
Date:   Wed Feb 23 10:24:58 2011 -0600

    rtlwifi: rtl8192ce: rtl8192cu: Fix multiple def errors for allyesconfig buil
    
    As noted by Stephan Rothwell, an allyesconfig build fails since rtl8192cu
    was merged with failures such as:
    
    drivers/net/wireless/rtlwifi/rtl8192cu/built-in.o: In function `rtl92c_phy_s
    (.opd+0xf30): multiple definition of `rtl92c_phy_sw_chnl'
    drivers/net/wireless/rtlwifi/rtl8192ce/built-in.o:(.opd+0xb70): first define
    drivers/net/wireless/rtlwifi/rtl8192cu/built-in.o: In function `rtl92c_fill_
    (.opd+0x288): multiple definition of `rtl92c_fill_h2c_cmd'
    drivers/net/wireless/rtlwifi/rtl8192ce/built-in.o:(.opd+0x288): first define
    
    These are caused because the code shared between rtl8192ce and rtl8192cu
    is included in both drivers. This has been fixed by creating a new modue tha
    contains the shared code.
    
    Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

It will be in my next pull request to Dave.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
