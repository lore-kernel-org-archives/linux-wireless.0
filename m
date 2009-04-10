Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:5658 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936162AbZDJUac (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2009 16:30:32 -0400
Received: by fg-out-1718.google.com with SMTP id e12so386591fga.17
        for <linux-wireless@vger.kernel.org>; Fri, 10 Apr 2009 13:30:30 -0700 (PDT)
Message-ID: <49DFAC64.5050208@tuffmail.co.uk> (sfid-20090410_223045_376263_525CF4C3)
Date: Fri, 10 Apr 2009 21:30:28 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
MIME-Version: 1.0
To: Pavel Roskin <proski@gnu.org>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ath5k-devel] BUG in wiphy_update_regulatory when loading ath5k
 (on latest git)
References: <49DF6216.8040303@tuffmail.co.uk>	 <49DF714F.9070600@tuffmail.co.uk> <1239385533.24621.11.camel@mj>	 <20090410181157.GC5750@tesla> <1239394864.3673.2.camel@mj>
In-Reply-To: <1239394864.3673.2.camel@mj>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin wrote:
> On Fri, 2009-04-10 at 11:11 -0700, Luis R. Rodriguez wrote:
>
>   
>> Thanks pavel, please try this patch:
>>     
>
> I checked ath5k, ath9k and b43, and in all cases last_request is
> initialized before it's used by the code changed in your patch.  In
> fact, last_request is initialized before there is any message from ath5k
> or another driver.
>
> I wonder if "module: create a request_module_nowait()" reverted in
> wireless-testing was causing the initialization to go in a different
> order.  I tried reapplying it and still could not reproduce the problem
> (that is, last_request is not NULL in wiphy_update_regulatory).  But
> maybe I'm just lucky.
>
> Anyway, your patch makes the code safer and doesn't break anything for
> me.
>   

I see.  That would explain why it's not deterministic.

I've done 5 or so test runs with the patch applied, and I haven't had
any more BUGs.  Thanks for the quick response!

Alan
