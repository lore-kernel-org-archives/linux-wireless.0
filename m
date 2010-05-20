Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:26019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757389Ab0ETUaE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 May 2010 16:30:04 -0400
Subject: Re: How the mac80211 handle "\0" essid?
From: Dan Williams <dcbw@redhat.com>
To: leo liang <leoliang9@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTinMa92irnw8fH8PPO6egbAVDFWBg4pCPp3dInwd@mail.gmail.com>
References: <AANLkTinMa92irnw8fH8PPO6egbAVDFWBg4pCPp3dInwd@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 May 2010 13:30:15 -0700
Message-ID: <1274387415.1422.33.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-05-20 at 15:40 -0400, leo liang wrote:
> Hi,
> 
> Does any one know that if the application send "\0" as essid to
> mac80211, how it handle this case?

What are you trying to do?  Are you trying to work with a hidden AP, or
do something else?

An SSID is simply a 32-byte array; the protocol and the stack don't care
what's in that array.  So while you can't use command-line tools like
'iwconfig' to send an SSID containing a \0, you can use netlink or
wpa_supplicant's nl80211 driver to do so.

But in the end, if you're trying to associate with an AP that has an
SSID of only '\0', that AP is likely broken or trying to hide it's SSID,
and you should be using the real SSID of that AP instead of '\0'.  

Dan


