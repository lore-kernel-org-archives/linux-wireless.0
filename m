Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:33093 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbcBDLcI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 06:32:08 -0500
Received: by mail-wm0-f47.google.com with SMTP id l66so22049663wml.0
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2016 03:32:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CABPxzY+HpP=NTrAaUEzV5nFm=LK93m=kxPV14-cdftt+VPsWNw@mail.gmail.com>
References: <CABPxzY+HpP=NTrAaUEzV5nFm=LK93m=kxPV14-cdftt+VPsWNw@mail.gmail.com>
Date: Thu, 4 Feb 2016 12:32:06 +0100
Message-ID: <CA+BoTQ=s_SMgs9zkgYjKOHKDwRORWk-Re7XZ=AiKiHCuNc0L8A@mail.gmail.com> (sfid-20160204_123214_106573_FAAAB8D4)
Subject: Re: mac80211_hwsim + iperf + netns
From: Michal Kazior <michal.kazior@tieto.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4 February 2016 at 12:22, Krishna Chaitanya <chaitanya.mgit@gmail.com> wrote:
> Hi All,
>
> I am trying to run some iperf tests using mac80211_hwsim b/w AP and STA.
> Even after tweaking the routing table, the packets are still not going through
> mac80211_hwsim instead they are just looping back.
>
> After a quick search i found that we should use different network namespaces.
> Can anyone tell me the exact procedure for this? I have found a procedure
> in the below link, but i dont have the lxc-unshare for my embedded box.
> Is there any alternate way for this.

If you have a recent enough iproute2 package you can use:

 ip netns add ns1
 ip netns exec ns1 bash # get the PID in the session and don't close it
 iw phy phyX set netns $pid_of_that_shell
 # you can close the bash now; phyX will remain in ns1

Or you could try using ipv6 link-local addresses which will not
require you to use namespaces at all.


Michał
