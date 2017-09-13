Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from civicrm.laptop.org ([18.85.44.157]:38026 "EHLO swan.laptop.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751364AbdIMVq4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Sep 2017 17:46:56 -0400
Date: Thu, 14 Sep 2017 07:46:49 +1000
From: James Cameron <quozl@laptop.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: rtl8821ae keep alive not set, connection lost
Message-ID: <20170913214649.GC20283@us.netrek.org> (sfid-20170913_234700_431346_4321441A)
References: <20170912220916.GB32211@us.netrek.org>
 <59e28611-9840-8873-2f15-1263e4e93d1c@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <59e28611-9840-8873-2f15-1263e4e93d1c@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 13, 2017 at 10:01:37AM -0500, Larry Finger wrote:
> Thank you very much for making the effort to bisect this problem. I
> know that several people have reported the problem, which we cannot
> duplicate; however, most of them just say it drops the connection
> and do nothing more.  In fact, we are lucky to have them even report
> which kernel version they are running!

Yes, in the reported bugs that style is common; almost animistic, very
mystical, and based on heuristics rather than analysis.  ;-)

> As we do not see the problem, we will be relying on you to help
> diagnose the issue. Merely changing the read from 8 to 16 bits
> should not cause any change.

Agreed.

> As _rtl8821ae_dbi_read() is only called from
> _rtl8821ae_enable_aspm_back_door(), we want to test turning off
> ASPM. The following patch will accomplish this. Unfortunately, the
> patch is white-space damaged, thus you will need to apply it
> manually. Please try it to see if it helps your connection
> loss. Note that ASPM settings are preserved through a module
> unload/reload sequence. Thus you will need to reboot after
> rebuilding the driver.

Went back to 4.13, added your test patch, and built kernel.

http://dev.laptop.org/~quozl/z/1dsFOW.txt is dmesg.

New symptom occurs; after 23 seconds since last transmission, the
device becomes unresponsive to ping from another host, but begins to
respond if the device transmits.  Flurry of responses then it settles
down to regular ping.

64 bytes from nl3-e.lan (10.0.0.94): icmp_seq=39 ttl=64 time=1.71 ms
64 bytes from nl3-e.lan (10.0.0.94): icmp_seq=40 ttl=64 time=1.93 ms
64 bytes from nl3-e.lan (10.0.0.94): icmp_seq=41 ttl=64 time=1.71 ms
64 bytes from nl3-e.lan (10.0.0.94): icmp_seq=42 ttl=64 time=1.66 ms
64 bytes from nl3-e.lan (10.0.0.94): icmp_seq=43 ttl=64 time=1.70 ms
64 bytes from nl3-e.lan (10.0.0.94): icmp_seq=44 ttl=64 time=1.69 ms
64 bytes from nl3-e.lan (10.0.0.94): icmp_seq=45 ttl=64 time=37.7 ms
64 bytes from nl3-e.lan (10.0.0.94): icmp_seq=46 ttl=64 time=383 ms
64 bytes from nl3-e.lan (10.0.0.94): icmp_seq=47 ttl=64 time=11464 ms
64 bytes from nl3-e.lan (10.0.0.94): icmp_seq=48 ttl=64 time=10465 ms
64 bytes from nl3-e.lan (10.0.0.94): icmp_seq=49 ttl=64 time=9465 ms
64 bytes from nl3-e.lan (10.0.0.94): icmp_seq=50 ttl=64 time=8466 ms
64 bytes from nl3-e.lan (10.0.0.94): icmp_seq=51 ttl=64 time=7466 ms
64 bytes from nl3-e.lan (10.0.0.94): icmp_seq=52 ttl=64 time=6466 ms
64 bytes from nl3-e.lan (10.0.0.94): icmp_seq=53 ttl=64 time=5466 ms
64 bytes from nl3-e.lan (10.0.0.94): icmp_seq=54 ttl=64 time=4467 ms
64 bytes from nl3-e.lan (10.0.0.94): icmp_seq=55 ttl=64 time=3467 ms
64 bytes from nl3-e.lan (10.0.0.94): icmp_seq=56 ttl=64 time=2468 ms
64 bytes from nl3-e.lan (10.0.0.94): icmp_seq=57 ttl=64 time=1468 ms
64 bytes from nl3-e.lan (10.0.0.94): icmp_seq=58 ttl=64 time=469 ms
64 bytes from nl3-e.lan (10.0.0.94): icmp_seq=59 ttl=64 time=1.79 ms
64 bytes from nl3-e.lan (10.0.0.94): icmp_seq=60 ttl=64 time=1.75 ms
64 bytes from nl3-e.lan (10.0.0.94): icmp_seq=61 ttl=64 time=1.72 ms
64 bytes from nl3-e.lan (10.0.0.94): icmp_seq=62 ttl=64 time=1.68 ms
64 bytes from nl3-e.lan (10.0.0.94): icmp_seq=63 ttl=64 time=1.68 ms
64 bytes from nl3-e.lan (10.0.0.94): icmp_seq=64 ttl=64 time=1.95 ms
64 bytes from nl3-e.lan (10.0.0.94): icmp_seq=65 ttl=64 time=1.68 ms

I'll give it some more testing and let you know, but it seems as
capable of keeping a connection as 4.13 plus my earlier revert.

-- 
James Cameron
http://quozl.netrek.org/
