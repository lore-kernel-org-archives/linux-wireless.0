Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35567 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935Ab1DUQ5W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Apr 2011 12:57:22 -0400
Received: by iwn34 with SMTP id 34so1538205iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 21 Apr 2011 09:57:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <EE97821C81277E459BEA5C6384C6F24101086A274525@srvexch01.SODIELEC.local>
References: <EE97821C81277E459BEA5C6384C6F24101086A274525@srvexch01.SODIELEC.local>
From: Javier Cardona <javier@cozybit.com>
Date: Thu, 21 Apr 2011 09:57:02 -0700
Message-ID: <BANLkTimL+nC9WTZw_UD4vixsXqf9nB5XUg@mail.gmail.com>
Subject: Re: Problem Mesh security with ath9k and hostap-sae: mesh points
 can't authenticate
To: =?ISO-8859-1?Q?C=E9dric_MOLINIER?= <c.molinier@actiasodielec.fr>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/4/14 Cédric MOLINIER <c.molinier@actiasodielec.fr>:
> On my embedded system, I'm trying to use the tools for authenticated MESH.
> I am using the fork of wpa_supplicant available that can authenticate mesh peers, available here:https://github.com/cozybit/hostap-sae.
> I followed what is described in the open80211s HOW page (http://o11s.org/trac/wiki/HOWTO#Testing).
>
> But, none Mesh Point does not authenticate.
>
> So can someone tell me what is the problem, please?
>
> Below, you can see my configuration and the output debug of wpa_supplicant (SAE).
> You can see a station (MP) is detected ("nl80211: New station 00:15:61:10:4f:7d"),
> but wpa_supplicant reject it:
>   mesh0: 0: 00:15:61:10:4f:7d ssid='' wpa_ie_len=0 rsn_ie_len=20 caps=0x0 level=-67
>   mesh0:    skip - SSID not known
>
>
> Thanks.
>
> C. Molinier
>
>
>
> I have two Mesh Point (MP) (with the same configuration):
> - MP(A) with MAC address 00:0B:6B:B5:EC:37
> - MP(B) with MAC address 00:15:61:10:4f:7d
>
> I use:
> - kernel 2.6.27
> - compat-wireless 2.6.39-rc1-3 for ath9k driver

The supplicant logs below seem to indicate that you may not have the
changes required to do mesh node authentication.  Try to find out if
that compat-wireless has, for instance, this patch:
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commit;h=71839121a0f35f9968d2e204a76eb22683156fd8

> nl80211: Register frame command failed (type=176): ret=-22 (Invalid argument)
> nl80211: Register frame match - hexdump(len=1): 03
> nl80211: Failed to register Auth frame processing - ignore for now

Cheers,

Javier
