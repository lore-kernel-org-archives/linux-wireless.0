Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33861 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752193AbeGDPNW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jul 2018 11:13:22 -0400
Subject: Re: [BUG] staging: r8822be: RTL8822be can't find any wireless AP
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jian-Hong Pan <jian-hong@endlessm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Frank A. Cancio Bello" <frank@generalsoftwareinc.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        devel@driverdev.osuosl.org, Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Upstreaming Team <linux@endlessm.com>,
        Colin Ian King <colin.king@canonical.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Arnd Bergmann <arnd@arndb.de>
References: <CAPpJ_ed1oFQW_xmBtetP-ztoL7Z14T6akOSgKJ_8jxogdf3FWg@mail.gmail.com>
 <f3bf0687-76fb-9411-6fa2-e8ef312efb58@lwfinger.net>
 <20180704140933.3dk2ylbntltz6jqd@mwanda>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <7e95bd6a-97bc-b030-26ce-83da66e5f279@lwfinger.net> (sfid-20180704_171441_742132_E03B85E1)
Date: Wed, 4 Jul 2018 10:13:20 -0500
MIME-Version: 1.0
In-Reply-To: <20180704140933.3dk2ylbntltz6jqd@mwanda>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/04/2018 09:09 AM, Dan Carpenter wrote:
> On Wed, Jul 04, 2018 at 08:55:00AM -0500, Larry Finger wrote:
>> I do not think this is a bug.
> 
> It's obviously a bug.  The driver should just work by default.
> 
> As a last resort, we would do something like add quirk or something.  I
> haven't looked at how quirks would be handled for this driver but grep
> for quirk to see how other drivers do it.

We will have to agree to disagree.

I have no idea what the vendors are doing that cause some motherboards to need a 
different aspm value. What I do know is that we have had to live with the idiocy 
of some vendors saving a few pennies by only including a single antenna, rather 
than two, and then making a problem by miscoding the EFUSE bit that indicates 
which connector is actually in use. As we have no means that I know about to 
detect which boxes have the problem, a module parameter was created, just as in 
this case.

I agree that drivers should work "out of the box", but finite resources and lack 
of vendor cooperation make this a goal that may not be attainable.

Larry
