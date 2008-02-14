Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from astra.ktv.nu ([81.216.9.70]:51468 "EHLO astra.sktv.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758207AbYBNT2F (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2008 14:28:05 -0500
Message-ID: <47B48DE2.7000303@ludd.ltu.se> (sfid-20080214_192810_628529_2B75F316)
Date: Thu, 14 Feb 2008 19:52:18 +0100
From: Christian Fredriksson <ille@ludd.ltu.se>
MIME-Version: 1.0
To: Sebastian Siewior <ipw+2200@ml.breakpoint.cc>
CC: Dan Williams <dcbw@redhat.com>,
	ipw2100-devel@lists.sourceforge.net, "zHU, yI" <yi.zhu@intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [Ipw2100-devel] [RFT] ipw2200: fix ucode assertion for RX queue
 overrun
References: <1202740070.2806.9.camel@localhost.localdomain> <20080213235621.GA10003@Chamillionaire.breakpoint.cc>
In-Reply-To: <20080213235621.GA10003@Chamillionaire.breakpoint.cc>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sebastian Siewior wrote:
> * Dan Williams | 2008-02-11 09:27:50 [-0500]:
>
>   
>> Restock the RX queue when there are a lot of unused frames so that the
>> RX ring buffer doesn't overrun, causing a ucode assertion.  Backport of
>> patch "iwlwifi: fix ucode assertion for RX queue overrun".
>>
>> Signed-off-by: Dan Williams <dcbw@redhat.com>
>>     
> Tested-by: Sebastian Siewior <sebastian@breakpoint.cc>
>
>   
>> Sebastian, can you test and ensure that this works for you?  Also, can
>>     
> Yep, it does.
>
>   
>> you do some throughput testing to ensure that this patch doesn't cause a
>> throughput regression?  Thanks!
>>     
> 00:49:41 (666.64 KB/s) - `/dev/null' saved [122563640/122563640]
>
> this was a wget from the inet and it hits almost my cap. Currently I don't
> have another local machine where I can test a "local" transfer.
>
> Is this okey for you?
>
> Sebastian
>
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Microsoft
> Defy all challenges. Microsoft(R) Visual Studio 2008.
> http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
> _______________________________________________
> ipw2100-devel mailing list
> ipw2100-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/ipw2100-devel
>
>   
The patch seem stable. Throughput are ok.

sftp> get 1001_20071125080100.mpg
Fetching /myth/tv/1001_20071125080100.mpg to 1001_20071125080100.mpg
/myth/tv/1001_20071125080100.mpg              100% 1120MB   2.6MB/s   
07:16   
sftp>

/Christian




