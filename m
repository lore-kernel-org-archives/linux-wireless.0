Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:39450 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754670Ab3EVUWQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 May 2013 16:22:16 -0400
Date: Wed, 22 May 2013 22:22:10 +0200
From: Jakub =?UTF-8?B?S2ljacWEc2tp?= <moorray3@wp.pl>
To: Mohit <mt1037ag11@pdm.ac.in>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Ralink RT3290 proprietary drivers causing kernel panic
Message-ID: <20130522222210.4e005cec@north> (sfid-20130522_222219_171769_4775E58B)
In-Reply-To: <519D0D44.1040901@pdm.ac.in>
References: <519D0D44.1040901@pdm.ac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 22 May 2013 23:54:04 +0530, Mohit wrote:
> Hello,
> 
>            I am on openSUSE 12.3 with kernel 3.7.10-1.4-desktop, i 
> wanted to try out the proprietary drivers for Ralink RT3290 so i 
> downloaded the drivers from 
> http://www.mediatek.com/_en/07_downloads/01_windows.php?sn=501 and 
> compiled the drivers as mentioned on my thread here : 
> https://forums.opensuse.org/english/get-technical-help-here/wireless/486975-rt3290-wireless-proprietary-drivers-not-working.html#post2557514. 
> Everything compiled fine, openSUSE was able to scan and connect to 
> access points after installation, but when i access the internet a 
> kernel panic occurs after ~5sec (time varies based on the data usage). 
> So i humbly request you to please provide the solution for the same, you 
> can reach me through email or reply to my thread (probably faster as i 
> don't check my email everyday).

I think vendor drivers crash on 64bit kernel because they
have faulty skb offsets handling. It's usually enough to fix
GCC warnings to make them work.

Having said that - I agree with Gertjan, you should really try
rt2800 from your kernel (or preferably from compat-wireless)
and if that doesn't work ask the vendor for help.

  -- Kuba
