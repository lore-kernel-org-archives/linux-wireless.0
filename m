Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:54418 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932Ab1AZVXc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 16:23:32 -0500
Message-ID: <4D4090CD.9090407@hauke-m.de>
Date: Wed, 26 Jan 2011 22:23:25 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: James <bjlockie@lockie.ca>
CC: linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: Re: no CONFIG_WIRELESS_EXT
References: <4D40774A.608@lockie.ca>
In-Reply-To: <4D40774A.608@lockie.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/26/2011 08:34 PM, James wrote:
> I installed compat-wireless-2011-01-25 and iwlist doesn't work but iw does.
> The warning dmesg shows is "cfg80211: wext will not work because kernel
> was compiled with CONFIG_WIRELESS_EXT=n. Tools using wext interface,
> like iwconfig will not work." which is fine BUT my kernel is compiled with
> CONFIG_WIRELESS=y
> CONFIG_WIRELESS_EXT_SYSFS=y
> and those are the only 2 'WIRELESS' anything.
> 
> I have kernel 2.6.36.3.

Hi,

you have to activate CONFIG_WIRELESS_EXT and nothing else to use the
wext interface. You can not doe this directly in your kernel config, you
have to modify the KConfig or build something that depends on
CONFIG_WIRELESS_EXT like ipw2200. Just set CONFIG_IPW200=m in the kernel
configuration and it will also activate CONFIG_WIRELESS_EXT=y

Hauke
