Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37985 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757508Ab2FZQxH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 12:53:07 -0400
Message-ID: <1340729582.4484.8.camel@jlt3.sipsolutions.net> (sfid-20120626_185349_872724_FC593B01)
Subject: Re: Intel N 1030 desn't connect to AP with WPA2 | Linux 3.4.2
From: Johannes Berg <johannes@sipsolutions.net>
To: Mariusz Fik <fisiu82@jabster.pl>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 26 Jun 2012 18:53:02 +0200
In-Reply-To: <2073595.T30nNVXCf4@pendrak> (sfid-20120626_182719_237485_C45FA59E)
References: <2073595.T30nNVXCf4@pendrak>
	 (sfid-20120626_182719_237485_C45FA59E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-06-26 at 18:27 +0200, Mariusz Fik wrote:
> Hi,
> 
> I installed openSUSE 12.2 Beta 2 with linux 3.4.2 recently and my wifi card 
> has problems with connecting to AP with WPA2. Hardware I have:
> | 02:00.0 Network controller [0280]: Intel Corporation Centrino Wireless-N 
> 1030 [8086:008a] (rev 34)
> 
> After boot I connected to my AP and wifi worked fine. After few seconds 
> connection was disconnected and nm asked me again for password. Every try of 
> connection was unsuccessful since now. `dmesg`, in the time of trying to 
> connect, gives me:
> | [  434.134710] wlan0: authenticate with 00:22:15:0b:55:a3
> | [  434.143822] wlan0: direct probe to 00:22:15:0b:55:a3 (try 1/3)
> | [  434.344492] wlan0: direct probe to 00:22:15:0b:55:a3 (try 2/3)
> | [  434.545185] wlan0: send auth to 00:22:15:0b:55:a3 (try 3/3)
> | [  434.745882] wlan0: authentication with 00:22:15:0b:55:a3 timed out

You're probably running into the TX power issue, that is fixed in 3.4.4:
http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=commitdiff;h=75862961e9b445a9bfce25b9da70ef930a857762


> | [  434.747111] iwlwifi 0000:02:00.0: ACTIVATE a non DRIVER active station id 
> 0 addr 00:22:15:0b:55:a3

I have a separate fix for this, but I think it's a red herring and
probably doesn't cause your problem.

johannes

