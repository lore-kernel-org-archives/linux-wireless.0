Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45340 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750883AbeEUHmE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 May 2018 03:42:04 -0400
Message-ID: <1469fa7134c62e0323ea1b409d98953f6c1a70a3.camel@coelho.fi> (sfid-20180521_094207_703492_2781BD25)
From: Luca Coelho <luca@coelho.fi>
To: Eric Biggers <ebiggers3@gmail.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        linux-wireless@vger.kernel.org,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Date: Mon, 21 May 2018 10:42:00 +0300
In-Reply-To: <20180519183345.GA701@sol.localdomain>
References: <20180519183345.GA701@sol.localdomain>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [4.17 iwlwifi regression] NULL pointer dereference in
 reg_query_regdb_wmm()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2018-05-19 at 11:33 -0700, Eric Biggers wrote:
> Hello,
> 
> Using v4.17-rc5, on a laptop with an "Intel Corporation Wireless 3165
> (rev 79)"
> using the iwlwifi driver, I get a NULL pointer dereference
> immediately after
> boot.  Apparently, the 'regdb' variable in net/wireless/reg.c is
> NULL, yet
> reg_query_regdb_wmm() is checking for IS_ERR().  It goes away if I
> revert commit
> 77e30e10ee28a5 ("iwlwifi: mvm: query regdb for wmm rule if
> needed").  The
> symbolized crash report is:
> 
> BUG: unable to handle kernel NULL pointer dereference at
> 000000000000000a

Thanks for the report and analysis! Haim is working on a fix and I will
send it out later today.

--
Cheers,
Luca.
