Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:36595 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbbD3QL6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Apr 2015 12:11:58 -0400
Received: by obbeb7 with SMTP id eb7so47947695obb.3
        for <linux-wireless@vger.kernel.org>; Thu, 30 Apr 2015 09:11:57 -0700 (PDT)
Message-ID: <5542544A.40102@lwfinger.net> (sfid-20150430_181223_773705_F8088013)
Date: Thu, 30 Apr 2015 11:11:54 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Source of Reason 7 disconnects
References: <55417E0C.2010206@lwfinger.net> <0BA3FCBA62E2DC44AF3030971E174FB31B6FB273@hasmsx107.ger.corp.intel.com>
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B6FB273@hasmsx107.ger.corp.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/30/2015 12:57 AM, Grumbach, Emmanuel wrote:
>> Emmanuel and Johannes,
>>
>> I am trying to fix "Reason: 7=CLASS3_FRAME_FROM_NONASSOC_STA"
>> disconnections for the Realtek drivers. When I did a search for similar
>> examples from other drivers, I found some forum entries for the same
>> disconnects happening on Intel
>> 7260 hardware. It appears that the problem was fixed in the 3.16 timeframe.
>> I looked through the iwlwifi commits from that time, but I failed to see any
>> patches that appeared to be appropriate.
>>
>> Do either of you happen to remember what was needed to fix the problem?
>> So far, I have determined that disabling power save helps, but it is not the
>> complete solution.
>>
>
> Oh yeah - this one is annoying. Thing is I don't remember anything specific.
> We had quite a few issues with our firmware that was going deaf for a while.
> That made the AP deauth us, but we couldn't even hear that. So when would
> transmit and assuming the receive path was working again, the AP was kicking
> us out because from its POV, we weren't associated anymore.
> I am sorry I can't point to any commit, but the problem was that we actually were
> disconnected, but didn't know about that.

Thanks for the reply. As far as I can tell, we don't get disconnected without 
knowing about it, but only when the solution is found will we know for sure. 
Thus far, I do not have any over-the-air captures to investigate.

Thanks again,

Larry


