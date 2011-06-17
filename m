Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:39161 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754790Ab1FQUdl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2011 16:33:41 -0400
Message-ID: <4DFBBA22.4050406@gnu.org> (sfid-20110617_223353_023252_CA48BC3B)
Date: Fri, 17 Jun 2011 16:33:38 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Stanislaw Gruszka <sgruszka@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] mac80211: use BUG_ON and return -EINVAL if rate_lowest_index()
 fails
References: <20110615220252.1918.73638.stgit@mj.roinet.com> <20110616102224.GB2178@redhat.com> <4DFA7EDF.70608@gnu.org> <4DFAF645.5030303@broadcom.com>
In-Reply-To: <4DFAF645.5030303@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/17/2011 02:37 AM, Arend van Spriel wrote:
> On 06/17/2011 12:08 AM, Pavel Roskin wrote:

>> In my case, I was able to restart the system by sysrq when using BUG_ON,
>> but the system would hang hard with WARN_ON. I think continuing after
>> returning an invalid index is wrong. It will lead to memory corruption
>> that could in turn lead to corruption of the filesystem.
>
> I think it is generally a bad idea to use BUG_ON as a solution. As
> Stanislaw indicated there are platforms which can continue without a
> hang so you are regressing those. Regarding your patch I think the
> -EINVAL is good to have, but leave the WARN_ON.

Well, then it would be pointless.  The whole idea was to prevent memory 
corruption and to stop early.  Returning -EINVAL for real (as opposed to 
having it in the dead code) could lead to worse memory corruption than 
returning 0.

The real fix would be to make rate control algorithms robust to the case 
when no rates are allowed.  My patch was meant as a first little step 
towards it by making it easier to capture the backtrace and restart the 
system.  But it's not worth the trouble for me to argue about it.

-- 
Regards,
Pavel Roskin
