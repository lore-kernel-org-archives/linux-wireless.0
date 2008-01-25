Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:37369 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752422AbYAYEgB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2008 23:36:01 -0500
Message-ID: <47996701.8000804@lwfinger.net> (sfid-20080125_043613_461519_4AAD61EE)
Date: Thu, 24 Jan 2008 21:35:13 -0700
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	Stefano Brivio <stefano.brivio@polimi.it>
Subject: Re: Kernel Panic in mac80211
References: <47983B31.4020304@lwfinger.net> <1201185235.3454.93.camel@johannes.berg>
In-Reply-To: <1201185235.3454.93.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Thu, 2008-01-24 at 00:16 -0700, Larry Finger wrote:
>> I have been having "random" kernel panics where the "Caps Lock" LED is flashing at ~1 Hz. These 
>> crashes only occur for the wireless-2.6 tree and have been happening for roughly 3 weeks. After 
>> running a memory test to ensure that these panics were not caused by a hardware problem, I enabled 
>> netconsole logging and caught the following crash report for my x86_64 system:
> 
>> Code: f6 44 02 08 10 74 12 45 85 ed 78 05 44 39 e9 7f 08 89 8f 24
>> RIP  [<ffffffff88202940>] :mac80211:rate_control_pid_tx_status+0x426/0x45a
> 
> Damn, I've seen that too but blamed it on my own patching. Stefano, any
> idea? IIRC some sta struct was NULL in pid_tx_status.

The problem is not a NULL in one of the structs, but a runaway loop. The error occurs in the
following loop in rate_control_pid_adjust_rate():

         while (newidx != sta->txrate) {
                 if (rate_supported(sta, mode, newidx) &&
                     (maxrate < 0 || newidx <= maxrate)) {
                         sta->txrate = newidx;
                         break;
                 }

                 newidx += back;
         }

The panic triggers in rate_supported(), which is compiled in-line, with newidx having a value of 576
at the time of the panic!! I'm not sure of the fix, but I think newindex should always be <=
mode->num_rates. The following patch should cure the crash, but may not be the best fix.

Index: wireless-2.6/net/mac80211/rc80211_pid_algo.c
===================================================================
--- wireless-2.6.orig/net/mac80211/rc80211_pid_algo.c
+++ wireless-2.6/net/mac80211/rc80211_pid_algo.c
@@ -123,6 +123,8 @@ static void rate_control_pid_adjust_rate
  		}

  		newidx += back;
+		if (newidx < 0 || newidx >= mode->num_rates)
+			return;
  	}

  #ifdef CONFIG_MAC80211_DEBUGFS

This patch has been compile tested at the moment, but it will get further testing after this E-mail
is sent.

Larry

