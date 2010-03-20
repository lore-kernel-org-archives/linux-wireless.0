Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58475 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600Ab0CTDHS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 23:07:18 -0400
Received: by gyg8 with SMTP id 8so1825631gyg.19
        for <linux-wireless@vger.kernel.org>; Fri, 19 Mar 2010 20:07:17 -0700 (PDT)
From: Bruno Randolf <randolf.bruno@googlemail.com>
To: Bruno Randolf <randolf.bruno@googlemail.com>
Subject: Re: [PATCH V2] mac80211: Revise,pending queue depth in ieee80211_local data structure
Date: Sat, 20 Mar 2010 12:07:11 +0900
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"lorenzo.bianconi83@gmail.com" <lorenzo.bianconi@fluidmesh.com>,
	linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Tony Huang <ht6100@gmail.com>
References: <4BA24A12.4030208@gmail.com> <a0b9368788449213d36b75dccd97c6a6@localhost> <201003201144.24471.randolf.bruno@gmail.com>
In-Reply-To: <201003201144.24471.randolf.bruno@gmail.com>
MIME-Version: 1.0
Message-Id: <201003201207.11218.randolf.bruno@gmail.com>
Content-Type: Text/Plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 20 March 2010 11:44:24 Bruno Randolf wrote:
> i think i'm hitting the same bug, but not sure (i will try to check next
> week). this is easy to reproduce, but you need 4 (at least 3) machines:
> 
> setup 2 wireless cards, talking to each other (i use IBSS) on different
> machines. then setup routing like this:
> 
> [1] - [WL1] - [WL2] - [2]
> 
> now send more UDP traffic than the wireless link can handle (iperf -u -b
> 50M for example) between [1] and [2]. watch the free memory get less and
> less at [WL1] until it chrashes.

forgot to add: [1] and [2] are connected by ethernet to [WL1/2]... 
(obviously?)

bruno
