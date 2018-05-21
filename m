Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52314 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753035AbeEUQZo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 May 2018 12:25:44 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: Eric Biggers <ebiggers3@gmail.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        linux-wireless@vger.kernel.org,
        Haim Dreyfuss <haim.dreyfuss@intel.com>
Subject: Re: [4.17 iwlwifi regression] NULL pointer dereference in reg_query_regdb_wmm()
References: <20180519183345.GA701@sol.localdomain>
        <1469fa7134c62e0323ea1b409d98953f6c1a70a3.camel@coelho.fi>
Date: Mon, 21 May 2018 19:25:38 +0300
In-Reply-To: <1469fa7134c62e0323ea1b409d98953f6c1a70a3.camel@coelho.fi> (Luca
        Coelho's message of "Mon, 21 May 2018 10:42:00 +0300")
Message-ID: <87r2m5f01p.fsf@kamboji.qca.qualcomm.com> (sfid-20180521_182547_805589_47624275)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> On Sat, 2018-05-19 at 11:33 -0700, Eric Biggers wrote:
>> Hello,
>> 
>> Using v4.17-rc5, on a laptop with an "Intel Corporation Wireless 3165
>> (rev 79)"
>> using the iwlwifi driver, I get a NULL pointer dereference
>> immediately after
>> boot.  Apparently, the 'regdb' variable in net/wireless/reg.c is
>> NULL, yet
>> reg_query_regdb_wmm() is checking for IS_ERR().  It goes away if I
>> revert commit
>> 77e30e10ee28a5 ("iwlwifi: mvm: query regdb for wmm rule if
>> needed").  The
>> symbolized crash report is:
>> 
>> BUG: unable to handle kernel NULL pointer dereference at
>> 000000000000000a
>
> Thanks for the report and analysis! Haim is working on a fix and I will
> send it out later today.

We are on -rc6 already and getting close to the final v4.17 release. I
wonder should we just revert 77e30e10ee28a5 for now?

-- 
Kalle Valo
