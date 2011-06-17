Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2830 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444Ab1FQGiX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2011 02:38:23 -0400
Message-ID: <4DFAF645.5030303@broadcom.com> (sfid-20110617_083827_844704_2E30857D)
Date: Fri, 17 Jun 2011 08:37:57 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Pavel Roskin" <proski@gnu.org>
cc: "Stanislaw Gruszka" <sgruszka@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] mac80211: use BUG_ON and return -EINVAL if
 rate_lowest_index() fails
References: <20110615220252.1918.73638.stgit@mj.roinet.com>
 <20110616102224.GB2178@redhat.com> <4DFA7EDF.70608@gnu.org>
In-Reply-To: <4DFA7EDF.70608@gnu.org>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/17/2011 12:08 AM, Pavel Roskin wrote:
> On 06/16/2011 06:22 AM, Stanislaw Gruszka wrote:
>> Hi Pavel
>>
>> On Wed, Jun 15, 2011 at 06:02:52PM -0400, Pavel Roskin wrote:
>>> WARN_ON is not enough, as we cannot return a valid index, and the
>>> callers will use whatever we return, causing a cascade of oopses and
>>> eventually a panic.
>> We have fedora bug (https://bugzilla.redhat.com/show_bug.cgi?id=702627)
>> where only that warning is generated, and system works further (at least
>> bug reporter did not mention about it's hang). When moving to BUG(),
>> system from user perspective will simply hang, what is much worse.
>> I think, we should rather fix callers to be prepared and recover itself
>> when rate_lowest_index fail. Of course fixing real bug(s) that cause
>> rate index is not found would be best.
> In my case, I was able to restart the system by sysrq when using BUG_ON,
> but the system would hang hard with WARN_ON.  I think continuing after
> returning an invalid index is wrong.  It will lead to memory corruption
> that could in turn lead to corruption of the filesystem.

I think it is generally a bad idea to use BUG_ON as a solution. As 
Stanislaw indicated there are platforms which can continue without a 
hang so you are regressing those. Regarding your patch I think the 
-EINVAL is good to have, but leave the WARN_ON.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


