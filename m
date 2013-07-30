Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from elwsc.co.jp ([27.50.121.29]:44013 "EHLO elwsc.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649Ab3G3LWL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jul 2013 07:22:11 -0400
Received: from [192.168.0.199] (p2192-ipbf202hodogaya.kanagawa.ocn.ne.jp [221.191.33.192])
	(authenticated bits=0)
	by elwsc.co.jp (8.14.5/8.14.5) with ESMTP id r6UBM7mg027943
	for <linux-wireless@vger.kernel.org>; Tue, 30 Jul 2013 20:22:10 +0900
Date: Tue, 30 Jul 2013 20:22:11 +0900
From: KATSUMI masanori <masanori-katsumi@elwsc.co.jp>
To: linux-wireless@vger.kernel.org
Subject: Re: How to read WiFi radio frequency.
In-Reply-To: <20130725210249.89DD.635158EF@elwsc.co.jp>
References: <20130725210249.89DD.635158EF@elwsc.co.jp>
Message-Id: <20130730202208.9333.635158EF@elwsc.co.jp> (sfid-20130730_132215_767394_291B90AC)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 25 Jul 2013 21:02:51 +0900
KATSUMI masanori <masanori-katsumi@elwsc.co.jp> wrote:

> I am trying to make p2p software with the current device as the group
> owner.
> I would like to acquire the channel that GO started, from normal user(NOT
> root).
> How can I get this information?

I think I can get own GO operating channel or freq through NL80211_ATTR_WIPHY_FREQ attribute
in nl80211 interface.

However, I was not able to get this attribute by NL80211_CMD_GET_INTERFACE which is used in
iw command.
In addition to that, I tried several nl80211 commands but I couldn't get it.
e.g) 
   NL80211_CMD_GET_WIPHY
   NL80211_CMD_GET_INTERFACE
   NL80211_CMD_GET_SCAN
   NL80211_CMD_GET_SURVEY
   NL80211_CMD_REMAIN_ON_CHANNEL

I can get the operating freq during STA but I cannot find the way to
get the own operating freq during running GO.

BTW, NL80211_CMD_FRAME_TX_STATUS event is only notified when GO started.
But, even this event didn't contain the frequency information.

Is there any other way to get the own GO's operating channel ??

I tried kernel v3.0.31
And do you know this feature supports in the latest kernel ??

Regards,

