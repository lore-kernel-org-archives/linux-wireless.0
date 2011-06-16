Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:4060 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422631Ab1FPWId (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jun 2011 18:08:33 -0400
Message-ID: <4DFA7EDF.70608@gnu.org> (sfid-20110617_000835_904838_25ED0E0D)
Date: Thu, 16 Jun 2011 18:08:31 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] mac80211: use BUG_ON and return -EINVAL if rate_lowest_index()
 fails
References: <20110615220252.1918.73638.stgit@mj.roinet.com> <20110616102224.GB2178@redhat.com>
In-Reply-To: <20110616102224.GB2178@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/16/2011 06:22 AM, Stanislaw Gruszka wrote:
> Hi Pavel
>
> On Wed, Jun 15, 2011 at 06:02:52PM -0400, Pavel Roskin wrote:
>> WARN_ON is not enough, as we cannot return a valid index, and the
>> callers will use whatever we return, causing a cascade of oopses and
>> eventually a panic.
>
> We have fedora bug (https://bugzilla.redhat.com/show_bug.cgi?id=702627)
> where only that warning is generated, and system works further (at least
> bug reporter did not mention about it's hang). When moving to BUG(),
> system from user perspective will simply hang, what is much worse.
> I think, we should rather fix callers to be prepared and recover itself
> when rate_lowest_index fail. Of course fixing real bug(s) that cause
> rate index is not found would be best.

In my case, I was able to restart the system by sysrq when using BUG_ON, 
but the system would hang hard with WARN_ON.  I think continuing after 
returning an invalid index is wrong.  It will lead to memory corruption 
that could in turn lead to corruption of the filesystem.

-- 
Regards,
Pavel Roskin
