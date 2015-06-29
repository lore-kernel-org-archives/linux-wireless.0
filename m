Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gosford.compton.nu ([217.169.17.27]:43069 "EHLO
	gosford.compton.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbbF2K2h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jun 2015 06:28:37 -0400
Subject: Re: Null pointer dereference when station associates [introduced by
 4.0.5?]
To: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <558EC27A.60804@compton.nu> (sfid-20150627_181129_907073_7F8F41EE)
 <1435565678.2156.9.camel@sipsolutions.net> <55910222.8020906@compton.nu>
 <55910DC8.9040700@compton.nu> <55911375.3070003@compton.nu>
 <55911CEA.7010103@compton.nu>
Cc: stable@vger.kernel.org
From: Tom Hughes <tom@compton.nu>
Message-ID: <55911DD1.20606@compton.nu> (sfid-20150629_122843_515469_C0E2AE3E)
Date: Mon, 29 Jun 2015 11:28:33 +0100
MIME-Version: 1.0
In-Reply-To: <55911CEA.7010103@compton.nu>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29/06/15 11:24, Tom Hughes wrote:

> So I think this happens when hostapd switches the interface
> to AP mode, which causes the netdev to be torn down and then
> recreated, and the debugfs directory along with it.
>
> Except that if the netlink message to change the mode was
> sent from a daemon whose selinux context prevents searching
> debugfs the recreation somehow fails and leaves an invalid
> state that later causes the null pointer deref.

Think I have it...

The teardown runs ieee80211_debugfs_remove_netdev
which clears sdata->vif.debugfs_dir but does not clear 
sdata->debugfs.subdir_stations so that when ieee80211_debugfs_add_netdev 
later fails to create the top level
netdev directory we are left with a bogus pointer for the stations 
directory.

Then when we try and add an entry to the stations directory things blow up.

Tom

-- 
Tom Hughes (tom@compton.nu)
http://compton.nu/
