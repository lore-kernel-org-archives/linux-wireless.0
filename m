Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:48818 "EHLO
        mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751387AbdIUOkR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Sep 2017 10:40:17 -0400
Received: by mail-io0-f169.google.com with SMTP id n69so11318093ioi.5
        for <linux-wireless@vger.kernel.org>; Thu, 21 Sep 2017 07:40:16 -0700 (PDT)
Subject: Re: rtl8821ae keep alive not set, connection lost
To: James Cameron <quozl@laptop.org>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170912220916.GB32211@us.netrek.org>
 <59e28611-9840-8873-2f15-1263e4e93d1c@lwfinger.net>
 <20170913214649.GC20283@us.netrek.org>
 <5f16881e-471b-4ffc-5e5e-93785bb999b6@lwfinger.net>
 <20170914092738.GG20283@us.netrek.org> <20170919094204.GR26927@us.netrek.org>
 <20170920093633.GO9946@us.netrek.org>
 <476b183f-5cc5-9a34-1a85-332dd5244b66@lwfinger.net>
 <20170920232228.GC9210@us.netrek.org> <20170921080746.GL9210@us.netrek.org>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <abff13d3-4115-4935-6546-b0fd8c860124@lwfinger.net> (sfid-20170921_164021_227090_B7728904)
Date: Thu, 21 Sep 2017 09:40:14 -0500
MIME-Version: 1.0
In-Reply-To: <20170921080746.GL9210@us.netrek.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/21/2017 03:07 AM, James Cameron wrote:
> My test kernel "-qb" was write_readback = false in sw.c, with 8-bit
> read of REG_DBI_RDATA, and has been stable for four hours.  I'll focus
> on some more testing of this one.  It is a surprise.
> 
> http://dev.laptop.org/~quozl/z/1dutXk.txt  (dmesg)
> 
> Observe how REG_DBI_FLAG+0 is briefly seen as 1, which doesn't happen
> with write_readback = true.

Again, thanks for your efforts.

At this point, my system has been up over 17 hours without a single drop. As a 
result, I will leave the reversion of commit 40b368af4b75 in place. It seems 
safer than turning off write_readback. After we get more testing, that could 
still be an option.

Larry
