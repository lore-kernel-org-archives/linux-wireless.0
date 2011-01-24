Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:48793 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab1AXFmp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 00:42:45 -0500
Received: by yib18 with SMTP id 18so1157797yib.19
        for <linux-wireless@vger.kernel.org>; Sun, 23 Jan 2011 21:42:44 -0800 (PST)
Message-ID: <4D3D1179.3080102@lwfinger.net>
Date: Sun, 23 Jan 2011 23:43:21 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>,
	chaoming_li <chaoming_li@realsil.com.cn>
Subject: Re: Question about rate control
References: <4D3CF5E3.4060507@lwfinger.net>
In-Reply-To: <4D3CF5E3.4060507@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/23/2011 09:45 PM, Larry Finger wrote:
> I'm trying to use a special rate-control algorithm. ATM, this is necessary
> because I don't know how to get the retry info from the firmware. This setup
> worked fine with rtl8192ce using a fixed name compiled in the rate_control_ops
> struct. The problem is that this code is also used by a new USB driver named
> rtl8192cu that shares the rtlwifi module with the PCIe driver. When both are
> loaded, the second gets a duplicate name warhing. To fix this, I have set up
> code that generates a unique name, but it doesn't work. To help debug, I added a
> printk to dump the name used in every call to ieee80211_rate_control_register().
> The result of that printk is shown below. The 3rd value listed is my new one and
> all looks OK; however, the selected rate control is "minstrel_ht", not my
> special one.
> 
> ops->name: minstrel
> ops->name: minstrel_ht
> --snip--
> ops->name: rtl-rc-0
> ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
> 
> Any thoughts on what might be wrong, or what values should be dumped for debugging?

I figured out my problem - I was not setting the rate_control_algorithm entry in
struct ieee80211_hw correctly. All is fine now.

Larry
