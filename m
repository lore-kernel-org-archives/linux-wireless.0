Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f167.google.com ([209.85.217.167]:47649 "EHLO
	mail-gx0-f167.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbZCLElO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 00:41:14 -0400
Received: by gxk11 with SMTP id 11so791879gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 11 Mar 2009 21:41:11 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 12 Mar 2009 00:41:11 -0400
Message-ID: <14df1c3e0903112141w645c716bu47e2309353527535@mail.gmail.com> (sfid-20090312_054120_864962_18FEF95D)
Subject: ath9k panic when connecting to 802.11n-enabled AP
From: Vladimir Senkov <hangup@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm new here so I apologize ahead of time if this is a known issue. In
my defense, I did a quick search on the archives.

My client machine (running wireless-testing kernel updated with git
today) panics when connecting to a hostapd access point (also running
ath9k) only when 802.11n is enabled on the access point.
More specifically, here is the hostapd configuration that causes the
client to crash:
ieee80211n=0
ht_capab=[HT40+][SHORT-GI-40][DSSS_CCK-40]

If I disable 802.11n on the access point everything works ok.
Interesting enough, access point machine never crashes. At one point
both access point and client machine ran identical code and client
would always crash while the access point box would stay up. So
upgraded client to the latest and greatest and tried a few versions in
between, this panic has been very consistent. It always panics right
after 1st attempt to associate.

I was able to narrow down the panic to this assert ath_rc_ratefind_ht() in rc.c:
        ASSERT((rate_table->info[rate].valid && !ath_rc_priv->single_stream) ||
               (rate_table->info[rate].valid_single_stream &&
                ath_rc_priv->single_stream));
When I ifdef'ed this assert panic went away and everything sort of
worked (haven't tested it heavily), but the performance dropped to
about 700Kbps. I usually get 10x when 802.11n is off and there is no
panic.

Has anyone else seen this?
I'm not including panic printk's because several routines get inlined
so panic printout points to the ath_get_rate(), but if you disass that
at the right offset you'll see the trap instruction and I'm pretty
sure I am barking up the right assert here :)

Here is the lspci output:
0c:00.0 Network controller [0280]: Atheros Communications, Inc.
Unknown device [168c:002a] (rev 01)

This client is a dell E1705 laptop with mini-pcie.

-- 
Regards,
Vladimir
