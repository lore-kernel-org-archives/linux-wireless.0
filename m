Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:60477
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbXCQPHF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Mar 2007 11:07:05 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Andy Green <andy@warmcat.com>
Subject: Re: [PATCH 2/2] mac80211: Monitor mode radiotap-based packet injection
Date: Sat, 17 Mar 2007 16:06:58 +0100
Cc: linux-wireless@vger.kernel.org
References: <20070317105800.659633351@warmcat.com> <200703171459.23246.mb@bu3sch.de> <45FC0205.2020409@warmcat.com>
In-Reply-To: <45FC0205.2020409@warmcat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200703171606.58803.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 17 March 2007 15:58, Andy Green wrote:
> Michael Buesch wrote:
> 
> >> +#define IEEE80211_TXCTL_INJECTED_PACKET (1<<10) /* tx into monitor IF */
> > 
> > What is a driver supposed to do on this flag? More documentation, please.
> 
> Hi Michael -
> 
> The driver doesn't have to do anything with that flag... it's a private 
> mac80211-internal flag to get the attribute that the packet was injected 

> If there's a simpler way I'm happy to use it.

Ok, no. I'm fine with this. But please mark it as mac80211-internal
flag, so driver authors don't waste time on thinking about wtf this is. ;)
Either by documenting it in a comment or by doing a special define
(two underscores or something). Or both.

-- 
Greetings Michael.
