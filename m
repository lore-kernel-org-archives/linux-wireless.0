Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38792 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750986AbeDYI6w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 25 Apr 2018 04:58:52 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 25 Apr 2018 11:58:51 +0300
From: merez@codeaurora.org
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Alexei Avshalom Lazar <ailizaro@codeaurora.org>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [02/10] wil6210: set/get EDMG channel through debugfs
In-Reply-To: <878t9dorzo.fsf@codeaurora.org>
References: <1523520526-24997-3-git-send-email-merez@codeaurora.org>
 <20180419161506.868FA60A06@smtp.codeaurora.org>
 <bf89143fe2765fab1aad65b9587030bf@codeaurora.org>
 <878t9dorzo.fsf@codeaurora.org>
Message-ID: <8284e049104ad878e1722927ca2b345f@codeaurora.org> (sfid-20180425_105857_600448_D99C3D3C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-04-24 12:47, Kalle Valo wrote:
> merez@codeaurora.org writes:
> 
>> On 2018-04-19 19:15, Kalle Valo wrote:
>>> Maya Erez <merez@codeaurora.org> wrote:
>>> 
>>>> Setting EDMG channel through debugfs for connect and PCP start
>>>> commands.
>>> Why? And what is an EDMG channel?
>>> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#commit_log_does_not_answer_why
>>> I get bad vibes that this debugfs file is just a workaround for not
>>> adding this to nl80211, a proper commit log would not give me such
>>> vibes in the first place :)
>> 
>> EDMG (Enhanced Directional Multi-Gigabit) is a new feature, part of
>> 11ad/11ay specification. In a nutshell it allows channel bonding of
>> 60Ghz channels.
>> 
>> The debugfs is used for debug-only to allow forcing a channel, not
>> intended to replace NL API, which we are working to upstream such.
> 
> But why cannot you do debugging via nl80211 as well?

Debugging via nl80211 is possible, but there are benefits in using the 
debugfs interface:
- Debugfs allows forcing a specific channel, which is not always an 
option with NL API
- Debug via nl80211 is less straight forward and requires development of 
user-space application
and upgrade of the kernel version on the debug setups

If you believe that the duplication is not justified please drop this 
patch.

-- 
Maya Erez
Qualcomm Israel, Inc. on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a 
Linux Foundation Collaborative Project
