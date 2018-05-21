Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42656 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753591AbeEUR5y (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 May 2018 13:57:54 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: Eric Biggers <ebiggers3@gmail.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        linux-wireless@vger.kernel.org,
        Haim Dreyfuss <haim.dreyfuss@intel.com>
Subject: Re: [4.17 iwlwifi regression] NULL pointer dereference in reg_query_regdb_wmm()
References: <20180519183345.GA701@sol.localdomain>
        <1469fa7134c62e0323ea1b409d98953f6c1a70a3.camel@coelho.fi>
        <87r2m5f01p.fsf@kamboji.qca.qualcomm.com>
        <17add6524aa6980898b9772b0aee92e9f5b04223.camel@coelho.fi>
Date: Mon, 21 May 2018 20:57:49 +0300
In-Reply-To: <17add6524aa6980898b9772b0aee92e9f5b04223.camel@coelho.fi> (Luca
        Coelho's message of "Mon, 21 May 2018 19:30:09 +0300")
Message-ID: <87in7ggaci.fsf@kamboji.qca.qualcomm.com> (sfid-20180521_195758_694706_2EDAB06E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> On Mon, 2018-05-21 at 19:25 +0300, Kalle Valo wrote:
>> Luca Coelho <luca@coelho.fi> writes:
>> 
>> > On Sat, 2018-05-19 at 11:33 -0700, Eric Biggers wrote:
>> > > Hello,
>> > > 
>> > > Using v4.17-rc5, on a laptop with an "Intel Corporation Wireless
>> > > 3165
>> > > (rev 79)"
>> > > using the iwlwifi driver, I get a NULL pointer dereference
>> > > immediately after
>> > > boot.  Apparently, the 'regdb' variable in net/wireless/reg.c is
>> > > NULL, yet
>> > > reg_query_regdb_wmm() is checking for IS_ERR().  It goes away if
>> > > I
>> > > revert commit
>> > > 77e30e10ee28a5 ("iwlwifi: mvm: query regdb for wmm rule if
>> > > needed").  The
>> > > symbolized crash report is:
>> > > 
>> > > BUG: unable to handle kernel NULL pointer dereference at
>> > > 000000000000000a
>> > 
>> > Thanks for the report and analysis! Haim is working on a fix and I
>> > will
>> > send it out later today.
>> 
>> We are on -rc6 already and getting close to the final v4.17 release.
>> I
>> wonder should we just revert 77e30e10ee28a5 for now?
>
> I don't think we should revert it, this implements the new ETSI
> requirements for the WMM settings and this will be enforced in all new
> devices sold after mid-June (IIRC).
>
> We haven't seen this problem and cfg80211 should not crash if the
> driver does stupid things, so we should just reject the call if regdb
> is still NULL.  It's a simple fix for the crash and the driver should
> recover from the issue later on.
>
> I'll push the patch for cfg80211 later this evening.

Very good that we have a quick fix, and I assume that will go through
mac80211 tree so I can send my w-d pull request tomorrow.

-- 
Kalle Valo
