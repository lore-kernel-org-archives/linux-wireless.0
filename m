Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45400 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752803AbeEUQaN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 May 2018 12:30:13 -0400
Message-ID: <17add6524aa6980898b9772b0aee92e9f5b04223.camel@coelho.fi> (sfid-20180521_183017_196089_1901115D)
From: Luca Coelho <luca@coelho.fi>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Eric Biggers <ebiggers3@gmail.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        linux-wireless@vger.kernel.org,
        Haim Dreyfuss <haim.dreyfuss@intel.com>
Date: Mon, 21 May 2018 19:30:09 +0300
In-Reply-To: <87r2m5f01p.fsf@kamboji.qca.qualcomm.com>
References: <20180519183345.GA701@sol.localdomain>
         <1469fa7134c62e0323ea1b409d98953f6c1a70a3.camel@coelho.fi>
         <87r2m5f01p.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [4.17 iwlwifi regression] NULL pointer dereference in
 reg_query_regdb_wmm()
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-05-21 at 19:25 +0300, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > On Sat, 2018-05-19 at 11:33 -0700, Eric Biggers wrote:
> > > Hello,
> > > 
> > > Using v4.17-rc5, on a laptop with an "Intel Corporation Wireless
> > > 3165
> > > (rev 79)"
> > > using the iwlwifi driver, I get a NULL pointer dereference
> > > immediately after
> > > boot.  Apparently, the 'regdb' variable in net/wireless/reg.c is
> > > NULL, yet
> > > reg_query_regdb_wmm() is checking for IS_ERR().  It goes away if
> > > I
> > > revert commit
> > > 77e30e10ee28a5 ("iwlwifi: mvm: query regdb for wmm rule if
> > > needed").  The
> > > symbolized crash report is:
> > > 
> > > BUG: unable to handle kernel NULL pointer dereference at
> > > 000000000000000a
> > 
> > Thanks for the report and analysis! Haim is working on a fix and I
> > will
> > send it out later today.
> 
> We are on -rc6 already and getting close to the final v4.17 release.
> I
> wonder should we just revert 77e30e10ee28a5 for now?

I don't think we should revert it, this implements the new ETSI
requirements for the WMM settings and this will be enforced in all new
devices sold after mid-June (IIRC).

We haven't seen this problem and cfg80211 should not crash if the
driver does stupid things, so we should just reject the call if regdb
is still NULL.  It's a simple fix for the crash and the driver should
recover from the issue later on.

I'll push the patch for cfg80211 later this evening.  Haim is still
working on fixing it in the driver side.

--
Cheers,
Luca.
