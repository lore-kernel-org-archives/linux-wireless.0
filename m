Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:33192 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753498AbYAYFhs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2008 00:37:48 -0500
Date: Fri, 25 Jan 2008 06:24:38 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Larry Finger <larry.finger@lwfinger.net>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Subject: Re: Kernel Panic in mac80211
Message-ID: <20080125062438.389fe2f8@morte> (sfid-20080125_053830_051203_3FC8E803)
In-Reply-To: <47996701.8000804@lwfinger.net>
References: <47983B31.4020304@lwfinger.net>
	<1201185235.3454.93.camel@johannes.berg>
	<47996701.8000804@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[D'oh, I missed this report until now.]

On Thu, 24 Jan 2008 21:35:13 -0700
Larry Finger <larry.finger@lwfinger.net> wrote:

> Johannes Berg wrote:
> > On Thu, 2008-01-24 at 00:16 -0700, Larry Finger wrote:
> >> I have been having "random" kernel panics where the "Caps Lock" LED is flashing at ~1 Hz. These 
> >> crashes only occur for the wireless-2.6 tree and have been happening for roughly 3 weeks. After 
> >> running a memory test to ensure that these panics were not caused by a hardware problem, I enabled 
> >> netconsole logging and caught the following crash report for my x86_64 system:
> > 
> >> Code: f6 44 02 08 10 74 12 45 85 ed 78 05 44 39 e9 7f 08 89 8f 24
> >> RIP  [<ffffffff88202940>] :mac80211:rate_control_pid_tx_status+0x426/0x45a
> > 
> > Damn, I've seen that too but blamed it on my own patching. Stefano, any
> > idea? IIRC some sta struct was NULL in pid_tx_status.
> 
> The problem is not a NULL in one of the structs, but a runaway loop. The error occurs in the
> following loop in rate_control_pid_adjust_rate():
> 
>          while (newidx != sta->txrate) {
>                  if (rate_supported(sta, mode, newidx) &&
>                      (maxrate < 0 || newidx <= maxrate)) {
>                          sta->txrate = newidx;
>                          break;
>                  }
> 
>                  newidx += back;
>          }

Is this commit in the tree you are testing?

commit 5bfcaca1279835867e2aa3406cfaf2fd7d92ff7c
Author: Stefano Brivio <stefano.brivio@polimi.it>
Date:   Sun Dec 23 04:41:19 2007 +0100

    rc80211-pid: simplify and fix shift_adjust

> The panic triggers in rate_supported(), which is compiled in-line, with newidx having a value of 576
> at the time of the panic!! I'm not sure of the fix, but I think newindex should always be <=
> mode->num_rates. The following patch should cure the crash, but may not be the best fix.

Sure, but rate_control_pid_shift_adjust() ensures that the newindex we
start with is within the ranges, so that I can't actually explain how
run-away can ever happen (because as soon as we hit the lower or the higher
limit, that should be a supported rate!) However, a bug prevented that from
working correctly, but should be fixed by the commit I mentioned above.

> Index: wireless-2.6/net/mac80211/rc80211_pid_algo.c
> ===================================================================
> --- wireless-2.6.orig/net/mac80211/rc80211_pid_algo.c
> +++ wireless-2.6/net/mac80211/rc80211_pid_algo.c
> @@ -123,6 +123,8 @@ static void rate_control_pid_adjust_rate
>   		}
> 
>   		newidx += back;
> +		if (newidx < 0 || newidx >= mode->num_rates)
> +			return;
>   	}
> 
>   #ifdef CONFIG_MAC80211_DEBUGFS
> 
> This patch has been compile tested at the moment, but it will get further testing after this E-mail
> is sent.

ACK, this can be useful as an additional sanity check, even if that
shouldn't be needed. Please ensure you have that commit in your tree -- I'll
investigate further, in case. Thank you for the report, I never hit that!


--
Ciao
Stefano
