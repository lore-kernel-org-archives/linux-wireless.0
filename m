Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:18972 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbYF3SKH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 14:10:07 -0400
Received: by nf-out-0910.google.com with SMTP id d3so468499nfc.21
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jun 2008 11:10:04 -0700 (PDT)
Message-ID: <48692161.9090403@gmail.com> (sfid-20080630_201027_982815_7A8AE1CC)
Date: Mon, 30 Jun 2008 19:09:37 +0100
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Harvey Harrison <harvey.harrison@gmail.com>,
	linux-wireless@vger.kernel.org, proski@gnu.org,
	orinoco-devel@lists.sourceforge.net
Subject: Re: [RFC PATCH 19/19] orinoco: Add MIC on TX and check on RX
References: <1214678305-7057-1-git-send-email-kilroyd@gmail.com>	 <1214678305-7057-7-git-send-email-kilroyd@gmail.com>	 <1214678305-7057-8-git-send-email-kilroyd@gmail.com>	 <1214678305-7057-9-git-send-email-kilroyd@gmail.com>	 <1214678305-7057-10-git-send-email-kilroyd@gmail.com>	 <1214678305-7057-11-git-send-email-kilroyd@gmail.com>	 <1214678305-7057-12-git-send-email-kilroyd@gmail.com>	 <1214678305-7057-13-git-send-email-kilroyd@gmail.com>	 <1214678305-7057-14-git-send-email-kilroyd@gmail.com>	 <1214678305-7057-15-git-send-email-kilroyd@gmail.com>	 <1214678305-7057-16-git-send-email-kilroyd@gmail.com>	 <1214678305-7057-17-git-send-email-kilroyd@gmail.com>	 <1214678305-7057-18-git-send-email-kilroyd@gmail.com>	 <1214678305-7057-19-git-send-email-kilroyd@gmail.com>	 <1214678305-7057-20-git-send-email-kilroyd@gmail.com>	 <1214776609.6037.11.camel@brick> (sfid-20080629_235718_050248_F270D991) <1214824008.5507.34.camel@johannes.berg>
In-Reply-To: <1214824008.5507.34.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Sun, 2008-06-29 at 14:56 -0700, Harvey Harrison wrote:
>> On Sat, 2008-06-28 at 19:38 +0100, kilroyd@googlemail.com wrote:
>>> Use the MIC algorithm from the crypto subsystem.
>>>
>>> Signed-off-by: David Kilroy <kilroyd@gmail.com>
>> Any reason not to use the net/mac80211/michael.c implementation?
> 
> Yes, depending on mac80211 for a full-mac driver wouldn't be too
> smart :)

I used (a copy of) the mac80211 version in my original implementation because it works within an interrupt, and can be called independently of the mac80211 stack.

However mac80211 doesn't export the MIC implementation, and even if it did, as Johannes says it wouldn't make sense for us to depend on mac80211 just for MIC.

I considered moving the MIC implementation out of mac80211 and exporting it in something like include/linux/ieee80211.h, but I didn't think it was worth it given the MIC implementation in crypto.


Dave.
